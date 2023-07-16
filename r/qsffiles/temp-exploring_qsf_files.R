
options(useFancyQuotes = FALSE)

library(tidyverse)
library(jsonlite)
library(tidyjson)
library(stringi)

# datafolder <- "C:/Users/Ted/Documents/Code/R/QualtricsTools-master/data/Sample Surveys"
datafolder <- "C:/Users/Ted/Documents/GitHub/sandbox/r/qsffiles/QualtricsTools-master/data/Sample Surveys"
qsf_string <- readLines(file.path(datafolder, "Better Sample Survey", "Better_Sample_Survey.qsf"), warn = FALSE)

# setwd("C:/Users/Ted/Documents/GitHub/sandbox/r/qsffiles/QualtricsTools-master/data")
# qsf_string <- readLines("./Sample Surveys/Better Sample Survey/Better_Sample_Survey.qsf", warn = FALSE)
# # qsf_string <- readLines("./Long_Exhaustive_Sample_Survey.qsf", warn = FALSE)
# # qsf_string <- readLines("./Sample Surveys/Many Different Question Types/Sample_Survey.qsf", warn = FALSE)

# qsf_string |>
#   prettify() |>
#   writeLines(con = file.path(datafolder, "Better Sample Survey", "Better_Sample_Survey_prettified.qsf"))
# writeLines(prettify(qsf_string), "./Sample Surveys/Many Different Question Types/Sample_Survey_prettified.json")

qsf <- fromJSON(qsf_string, simplifyVector = FALSE, flatten = FALSE)
qsf2 <- fromJSON(qsf_string)

# length(qsf)
# glimpse(qsf, max.level = 2)

survey_entry <- qsf[["SurveyEntry"]]
survey_elements <- qsf[["SurveyElements"]]
# glimpse(survey_elements, max.level = 2)
# 
# glimpse(qsf["SurveyElements"], max.level = 2)

nonpayload <- survey_elements |>
  lapply(\(x) {x$Payload <- NULL; x}) |>
  bind_rows()

names(survey_elements) <- nonpayload[["PrimaryAttribute"]]
# glimpse(survey_elements, max.level = 2)

### sprintf("Total number of questions in the survey: %s", nonpayload |> filter(Element == "QC") |> pull(SecondaryAttribute))

survey_blocks <- survey_elements[["Survey Blocks"]]
# glimpse(survey_blocks, max.level = 2)
# glimpse(survey_blocks[["Payload"]], max.level = 2)
# sapply(survey_blocks[["Payload"]], \(x) {x[["Type"]]})
trash_block_index <- which(sapply(survey_blocks[["Payload"]], \(x) {x[["Type"]] == "Trash"}))

# pluck(survey_blocks, "Payload", 2, "Description")
# pluck(survey_blocks, "Payload", 2, "BlockElements")
survey_trash <- pluck(survey_blocks, "Payload", trash_block_index)
# survey_trash$BlockElements
# unlist(survey_trash[["BlockElements"]], recursive = FALSE) |> bind_rows()

trash_question_ids <- survey_trash |>
  pluck("BlockElements") |>
  # unlist(recursive = FALSE) |>
  bind_rows() |>
  filter(Type == "Question") |>
  pull(QuestionID)

survey_questions <- survey_elements[nonpayload |> filter(Element == "SQ") |> pull(PrimaryAttribute)]
# length(survey_questions)
# glimpse(survey_questions, max.level = 2)

payloads <- survey_elements |>
  lapply(\(x) {x[["Payload"]]})
# length(payloads)
# glimpse(payloads, max.level = 2)
# map(survey_elements, "Payload")

survey_question_payloads <- survey_questions |> lapply(\(x) {x[["Payload"]]})
# glimpse(survey_question_payloads, max.level = 2)
# 
# # lapply(survey_question_payloads, \(x) {is.list(x) && (length(x) > 0L)})
# lapply(survey_question_payloads, \(x) {sapply(x, \(y) {is.list(y) && (length(y) > 0L)})})
# map(survey_questions, "Payload")

sqp_meta <- survey_question_payloads |>
  lapply(\(x) {sapply(x, \(y) {is.list(y) && (length(y) > 0L)})}) |>
  bind_rows()
sqp_meta <- sqp_meta |>
  replace_na(
    replace = list(FALSE) %>% rep(ncol(sqp_meta)) %>% setNames(colnames(sqp_meta))
  )
# glimpse(sqp_meta)
# 
# as.data.frame(sqp_meta)
# 
# sapply(sqp_meta, any)
safe_to_extract <- sapply(sqp_meta, Negate(any))

# survey_question_payloads |>
#   select(vars(safe_to_extract))

# survey_question_payloads[, safe_to_extract]
sqp_nonlists <- survey_question_payloads |>
  # lapply(\(x) {x[names(which(safe_to_extract))]}) |>
  lapply(\(x) {x[names(which(safe_to_extract))] |> unlist(recursive = FALSE)}) |>
  bind_rows() |>
  mutate(
    question_is_in_trash = QuestionID %in% trash_question_ids
  )
glimpse(sqp_nonlists)
table(sqp_nonlists$question_is_in_trash, useNA = "ifany")

sqp_nonlists |>
  pull(QuestionText)
  # pull(QuestionDescription)

# sqp_nonlists |>
#   pull(QuestionText) |>
#   # rvest::html_text2()
#   rvest:::html_text_block()

tempfun <- function(x) paste0("<p>", paste0(x, collapse = "<br /></p><p>"), "</p>")
sqp_nonlists |>
  pull(QuestionText) |>
  tempfun() |>
  rvest::read_html() |>
  rvest::html_text() |>
  cat()

sqp_nonlists |>
  # select(QuestionID, QuestionDescription)
  # select(QuestionID, QuestionText)
  select(QuestionID, IsTrashed = question_is_in_trash)

table(sqp_nonlists$QuestionType, useNA = "ifany")
table(sqp_nonlists$Selector, useNA = "ifany")
table(sqp_nonlists$NumberOfQuestions, useNA = "ifany")
table(sqp_nonlists$question_is_in_trash, useNA = "ifany")

sqp_nonlists |>
  # count(Selector, NumberOfQuestions)
  # count(Selector, SubSelector)
  # count(Selector, QuestionType)
  count(QuestionType, Selector, SubSelector)

sqp_nonlists |>
  filter(QuestionType == "MC") |>
  select(QuestionID)

sqp_lists <- survey_question_payloads |>
  lapply(\(x) {x[names(which(!safe_to_extract))] %>% `[`(which(!is.na(names(.))))})
# # if ((length(trash_question_ids) > 0L) && (any(names(sqp_lists) %in% trash_question_ids)))  {
#   sqp_lists <- sqp_lists[setdiff(names(sqp_lists), trash_question_ids)]
# # }

length(sqp_lists)
glimpse(sqp_lists, max.level = 2)
# bind_rows(sqp_lists)

glimpse(sqp_lists[[length(sqp_lists)]], max.level = 1)
names(sqp_lists[[length(sqp_lists)]])

lapply(sqp_meta, which)
glimpse(sqp_lists[[5]], max.level = 1)
sqp_lists[[5]][["ChoiceDataExportTags"]]


sqp_lists |>
  lapply(\(x) {x[["Choices"]]})

# sqp_lists |>
#   lapply(\(x) {x[["Choices"]] %>% lapply(\(y) {bind_cols(n = names(y), d = y[["Display"]])})})

sqp_lists |>
  lapply(\(x) {x[["Choices"]]}) |>
  lapply(\(x) {coalesce(names(x), NA_character_)})

# sqp_lists |>
#   lapply(\(x) {x[["Choices"]]}) |>
#   lapply(\(x) {bind_cols(n = names(x), d = unlist(x, recursive = FALSE)[["Display"]])})


sqp_lists |>
  lapply(\(x) {x[["Choices"]] |> lapply(\(y) {y[["Display"]]})})
  # lapply(\(x) {x[["Choices"]] |> lapply(\(y) {bind_rows(y[["Display"]])})})
  # lapply(\(x) {x[["Choices"]] |> lapply(\(y) {y[["Display"]] %>%
  #     bind_cols(n = names(.), d = unlist(.))})})

# sqp_lists |>
#   lapply(\(x) {x[["Choices"]] |> lapply(\(y) {y[["Display"]] %>% ifelse(length(.) > 0L, ., NA)})})
# sqp_lists |>
#   lapply(\(x) {x[["Choices"]] |> lapply(\(y) {length(y[["Display"]])})})

# sqp_lists |>
#   lapply(\(x) {x[["Choices"]] |> lapply(\(y) {unlist(y[["Display"]], recursive = FALSE)})})
sqp_lists |>
  lapply(\(x) {x[["Choices"]] |> sapply(\(y) {unlist(y[["Display"]])})})

sqp_lists |>
  lapply(\(x) {x[["Choices"]] |> sapply(\(y) {y[["Display"]]})})

sqp_lists |>
  lapply(\(x) {x[["Choices"]] |> sapply(\(y) {y[["Display"]]})}) |>
  bind_rows()

sqp_lists |>
  lapply(\(x) {x[["Choices"]] |> sapply(\(y) {y[["Display"]] %>% ifelse(is.null(.) || length(.) == 0L, NA_character_, .)})}) |>
  bind_rows()

sqp_lists[["QID3"]][["Choices"]]

sqp_lists |>
  # lapply(\(x) {x[["Choices"]] |> sapply(\(y) {ifelse(is.null(y[["Display"]]) || length(y[["Display"]]) == 0L, NA_character_, y[["Display"]])})}) |>
  lapply(\(x) {x[["Choices"]] |> sapply(\(y) {if(is.null(y) || length(y[["Display"]]) == 0L) {NA_character_} else {y[["Display"]]}})}) |>
  bind_rows()



lapply(sqp_lists, \(x) {x[["ChoiceOrder"]]})
lapply(sqp_lists, \(x) {unlist(x[["ChoiceOrder"]], recursive = FALSE)})
lapply(sqp_lists, \(x) {as.character(unlist(x[["ChoiceOrder"]], recursive = FALSE))})
lapply(sqp_lists, \(x) {y <- as.character(unlist(x[["ChoiceOrder"]], recursive = FALSE)); ifelse(is.null(y) | (length(y) == 0L), NA_character_, y)})







qsf_files <- list.files(
  path = "C:/Users/Ted/Documents/GitHub/sandbox/r/qsffiles/QualtricsTools-master/data/Sample Surveys",
  pattern = "*.qsf",
  full.names = TRUE,
  recursive = TRUE
)
qsf_list <- vector(mode = "list", length = length(qsf_files))
names(qsf_list) <- tools::file_path_sans_ext(basename(qsf_files))
for (i in seq_along(qsf_list)) {
  qsf_list[[i]][["filepath"]] <- qsf_files[i]
  qsf_list[[i]][["qsf_string"]] <- readLines(qsf_files[i], warn = FALSE)
  # qsf_list[[i]][["json"]] <- jsonlite::fromJSON(txt = qsf_list[[i]][["qsf_string"]], simplifyVector = FALSE, flatten = FALSE)
  qsf_list[[i]][["json"]] <- jsonlite::fromJSON(txt = qsf_files[i], simplifyVector = FALSE, flatten = FALSE)
  qsf_list[[i]][["schema"]] <- tidyjson::json_schema(qsf_files[i])
}
rm(i)

glimpse(qsf_list, max.level = 2)

# qsf_list
# map(qsf_list, "schema")
# map(qsf_list, \(x) {x[["schema"]] |> fromJSON(simplifyVector = FALSE, flatten = FALSE) |> enter_object(SurveyEntry) |> json_get() |> prettify()})
# map(qsf_list, \(x) {x[["schema"]] |> fromJSON(flatten = TRUE) |> as_tbl_json()})# |> tibble(json = _) |> as_tbl_json("json")})


qsf_tidy <- qsf_list[["Better_Sample_Survey"]][["filepath"]] |>
  read_json(format = "json")

qsf_tidy
qsf_tidy |>
  gather_object()

survey_entry <- qsf_tidy |>
  gather_object("name") |>
  filter(name == "SurveyEntry")

survey_entry <- qsf_tidy |>
  # gather_object("name") |>
  spread_values(
    SurveyID = jstring(SurveyEntry, SurveyID),
    SurveyName = jstring(SurveyEntry, SurveyName),
    SurveyDescription = jstring(SurveyEntry, SurveyDescription),
    SurveyOwnerID = jstring(SurveyEntry, SurveyOwnerID),
    SurveyBrandID = jstring(SurveyEntry, SurveyBrandID),
    DivisionID = jstring(SurveyEntry, DivisionID),
    SurveyLanguage = jstring(SurveyEntry, SurveyLanguage),
    SurveyActiveResponseSet = jstring(SurveyEntry, SurveyActiveResponseSet),
    SurveyStatus = jstring(SurveyEntry, SurveyStatus),
    SurveyStartDate = jstring(SurveyEntry, SurveyStartDate),
    SurveyExpirationDate = jstring(SurveyEntry, SurveyExpirationDate),
    SurveyCreationDate = jstring(SurveyEntry, SurveyCreationDate),
    CreatorID = jstring(SurveyEntry, CreatorID),
    LastModified = jstring(SurveyEntry, LastModified),
    LastAccessed = jstring(SurveyEntry, LastAccessed),
    LastActivated = jstring(SurveyEntry, LastActivated),
    Deleted = jstring(SurveyEntry, Deleted)
  ) |> #glimpse()
  gather_object("name") |>
  filter(name == "SurveyElements") |>
  select(-name) |>
  gather_array("name")
# survey_entry2 <- qsf_tidy |> gather_object() |> filter(name == "SurveyEntry") |> spread_all() #|> glimpse()

survey_elements <- survey_entry |>
  select(name) |>
#  gather_object("name2")
  spread_values(
    SurveyID = jstring(SurveyID),
    Element = jstring(Element),
    PrimaryAttribute = jstring(PrimaryAttribute),
    SecondaryAttribute = jstring(SecondaryAttribute),
    TertiaryAttribute = jstring(TertiaryAttribute)
  )

payloads <- survey_elements |>
  gather_object("name2") |>
  filter(name2 == "Payload") |>
  select(-name2)

payloads_simple <- payloads |>
  filter(Element == "BL") |>
  gather_array("SurveyBlockNumber") |>
  select(-c(Element, SecondaryAttribute, TertiaryAttribute)) |>
  # gather_object("name2")
  spread_values(
    SurveyBlockType = jstring(Type),
    SurveyBlockDescription = jstring(Description),
    SurveyBlockID = jstring(ID)
  ) |>
  enter_object(BlockElements) |>
  gather_array("SurveyBlockElementNumber") |>
  # gather_object()
  spread_values(
    SurveyBlockElementType = jstring(Type),
    QuestionID = jstring(QuestionID)#,
    # SkipLogic.SkipLogicID = jstring(SkipLogic, SkipLogicID),
    # SkipLogic.ChoiceLocator = jstring(SkipLogic, ChoiceLocator),
    # SkipLogic.Condition = jstring(SkipLogic, Condition),
    # SkipLogic.SkipToDestination = jstring(SkipLogic, SkipToDestination),
    # SkipLogic.Locator = jstring(SkipLogic, Locator),
    # SkipLogic.SkipToDescription = jstring(SkipLogic, SkipToDescription),
    # SkipLogic.Description = jstring(SkipLogic, Description),
    # SkipLogic.QuestionID = jstring(SkipLogic, QuestionID)
  ) #|> #glimpse()

payloads_simple |>
  gather_object("SurveyBlockElementSubtype") |>
  filter(SurveyBlockElementSubtype == "SkipLogic") |>
  select(-c(PrimaryAttribute, SurveyBlockType, SurveyBlockDescription, SurveyBlockElementType, SurveyBlockElementSubtype)) |>
  gather_array("SkipLogicArrayIndex") |> #glimpse()
  gather_object("SkipLogic") |> #glimpse()
  select(SkipLogic)

payloads_simple |>
  gather_object("SurveyBlockElementSubtype") |>
  filter(SurveyBlockElementSubtype == "SkipLogic") |>
  select(-c(PrimaryAttribute, QuestionID, SurveyBlockType, SurveyBlockDescription, SurveyBlockElementType, SurveyBlockElementSubtype)) |>
  gather_array("SkipLogicArrayIndex") |>
  spread_values(
    SkipLogic.SkipLogicID = jnumber(SkipLogicID),
    SkipLogic.ChoiceLocator = jstring(ChoiceLocator),
    SkipLogic.Condition = jstring(Condition),
    SkipLogic.SkipToDestination = jstring(SkipToDestination),
    SkipLogic.Locator = jstring(Locator),
    SkipLogic.SkipToDescription = jstring(SkipToDescription),
    SkipLogic.Description = jstring(Description),
    SkipLogic.QuestionID = jstring(QuestionID)
  ) |> #glimpse()
  select(SurveyID, QuestionID = SkipLogic.QuestionID, SurveyBlockID, SurveyBlockElementNumber, SkipLogicArrayIndex, starts_with("SkipLogic.")) |>
  left_join(
    x = payloads_simple,
    y = _,
    by = join_by(SurveyID, SurveyBlockID, SurveyBlockElementNumber, QuestionID)
  ) |>
  mutate(
    question_has_skip_logic = !is.na(SkipLogicArrayIndex)
  )




survey_entry <- qsf_tidy |>
  gather_object() |>
  filter(name == "SurveyEntry") |>
  spread_all() #|> glimpse()
survey_elements <- qsf_tidy |>
  enter_object(SurveyElements) |>
  gather_array("SurveyElementsArrayIndex") |>
  gather_object("SurveyElements")

survey_elements <- qsf_tidy |>
  enter_object(SurveyElements) |>
  gather_array("SurveyElementsArrayIndex") |>
  spread_values(
    SurveyID = jstring(SurveyID),
    Element = jstring(Element),
    PrimaryAttribute = jstring(PrimaryAttribute),
    SecondaryAttribute = jstring(SecondaryAttribute),
    TertiaryAttribute = jstring(TertiaryAttribute)
  ) #|>
  # enter_object(Payload)
survey_elements

# ### NB: This implicitly drops all objects that do not have a "Payload" property. (TSZB, 2023-07-16)
# survey_elements |> enter_object(Payload)


x <- json_structure(qsf_tidy)
dim(x)
glimpse(x)

x_survey_entry <- x |>
  filter(name == "SurveyEntry", level == 1L) |>
  as_tibble() |>
  select(parent.id = child.id) |>
  inner_join(
    x |> json_get_column("json") |> as_tibble(),
    by = "parent.id"
  ) |>
  as_tbl_json("json")

x_survey_entry |>
  select(-c(parent.id, level, child.id, seq, length))


x_survey_elements <- x |>
  filter(name == "SurveyElements", level == 1L) |>
  as_tibble() |>
  select(parent.id = child.id) |>
  inner_join(
    x |> json_get_column("json") |> as_tibble(),
    by = "parent.id"
  ) |>
  as_tbl_json("json")

table(x_survey_elements$length, useNA = "ifany")

xse <- x_survey_elements |>
  as_tibble() |>
  select(parent.id = child.id) |>
  inner_join(
    x |> json_get_column("json") |> as_tibble(),
    by = "parent.id"
  ) |>
  as_tbl_json("json") |>
  mutate(
    parent.id.order = type.convert(stri_extract_last_regex(str = parent.id, pattern = "(\\d+)"), as.is = TRUE)
  ) |>
  # arrange(document.id, level, index)
  arrange(document.id, parent.id.order, level, index)
xse
table(xse$type, useNA = "ifany")
table(xse$name, useNA = "ifany")
table(xse$length, useNA = "ifany")

filter(xse, name == "Payload")
filter(xse, length > 1L)

xse1 <- xse |>
  filter(name != "Payload")
xse2 <- xse |>
  filter(
    name == "Payload",
    # length > 0L
    type != "null"
  ) |>
  select(-name)

xse1
xse1 |>
  # as_tibble() |>
  filter(type != "null") |>
  # json_get_column("json") |>
  select(document.id, index, name)

xse1 |>
  # select(document.id, parent.id, index, name) |>
  select(document.id, parent.id, name) |>
  json_get_column("json") |>
  as_tibble() |>
  pivot_wider(
    # names_from = c(name, index),
    # names_sep = "_",
    names_from = name,
    # names_from = index,
    # names_prefix = "index_",
    values_from = json,
    values_fn = \(x) {coalesce(unlist(x), NA)}
  )





x <- json_structure(qsf_tidy)
x_survey_elements_nonpayloads <- x |>
  filter(name == "SurveyElements", level == 1L) |>
  as_tibble() |>
  select(parent.id = child.id) |>
  inner_join(
    x |> json_get_column("json") |> as_tibble(),
    by = "parent.id"
  ) |>
  as_tibble() |>
  select(parent.id = child.id) |>
  inner_join(
    x |> json_get_column("json") |> as_tibble(),
    by = "parent.id"
  ) |>
  as_tbl_json("json") |>
  mutate(
    parent.id.order = type.convert(stri_extract_last_regex(str = parent.id, pattern = "(\\d+)"), as.is = TRUE)
  ) |>
  # arrange(document.id, level, index)
  arrange(document.id, parent.id.order, level, index) |>
  json_get_column("json") |>
  as_tibble() |>
  mutate(has_payload = max(name == "Payload" & type != "null"), .by = c(document.id, parent.id)) |>
  as_tbl_json("json") |>
  filter(name != "Payload") |>
  select(document.id, parent.id, name, has_payload) |>
  json_get_column("json") |>
  as_tibble() |>
  pivot_wider(
    names_from = name,
    values_from = json,
    values_fn = \(x) {coalesce(unlist(x), NA)}
  )
x_survey_elements_nonpayloads

select(x_survey_elements_nonpayloads, Element, PrimaryAttribute)


xse2
table(xse2$type, useNA = "ifany")
count(xse2, type, .drop = FALSE)

xse2 |>
  filter(type == "array") |>
  gather_array() |> json_get()

xse2$seq

temp <- xse2 |>
  json_get_column("json") |>
  as_tibble() |>
  inner_join(
    select(x_survey_elements_nonpayloads, parent.id, Element),
    by = "parent.id"
  ) |>
  as_tbl_json("json")
temp
count(temp, Element)

temp |>
  # filter(Element == "BL")
  filter(Element == "SQ")

temp |>
  filter(Element == "BL") |>
  gather_array()

temp |>
  filter(Element == "BL") |>
  select(parent.id = child.id) |>
  as_tibble() |>
  inner_join(
    x |> as_tibble(),
    by = "parent.id"
  ) |>
  select(parent.id = child.id) |>
  as_tibble() |>
  inner_join(
    x |> json_get_column("json") |> as_tibble(),
    by = "parent.id"
  ) |>
  as_tbl_json("json") |>
  # count(type)
  # count(length)
  filter(type == "string") |>
  # select(-c(type, length))
  select(document.id, parent.id, name) |>
  json_get_column("json") |>
  as_tibble() |>
  pivot_wider(
    names_from = name,
    values_from = json,
    values_fn = \(x) {coalesce(unlist(x), NA)}
  )

temp |>
  filter(Element == "BL") |>
  select(parent.id = child.id) |>
  as_tibble() |>
  inner_join(
    x |> as_tibble(),
    by = "parent.id"
  ) |>
  select(parent.id = child.id) |>
  as_tibble() |>
  inner_join(
    x |> json_get_column("json") |> as_tibble(),
    by = "parent.id"
  ) |>
  as_tbl_json("json") |>
  # count(type)
  # count(length)
  filter(type == "array") |>
  # select(-type) |>
  # gather_array() |>
  # # count(name)
  # # count(length)
  # gather_object("BlockElement") |>
  # count(BlockElement)
  select(parent.id = child.id) |>
  as_tibble() |>
  inner_join(
    # x |> json_get_column("json") |> as_tibble(),
    x |> as_tibble(),
    by = "parent.id"
  ) |>
  # as_tbl_json("json") |>
  # # count(name)
  # # count(type)
  # count(length)
  select(parent.id = child.id) |>
  inner_join(
    x |> json_get_column("json") |> as_tibble(),
    by = "parent.id"
  ) |>
  as_tbl_json("json") |>
  # count(type)
  # count(name)
  # count(type, name)
  filter(type != "array") |>
  select(document.id, parent.id, name) |>
  json_get_column("json") |>
  as_tibble() |>
  pivot_wider(
    names_from = name,
    values_from = json,
    values_fn = \(x) {coalesce(unlist(x), NA)}
  )



temp |>
  filter(Element == "BL") |>
  select(parent.id = child.id) |>
  as_tibble() |>
  inner_join(
    x |> as_tibble(),
    by = "parent.id"
  ) |>
  select(parent.id = child.id) |>
  as_tibble() |>
  inner_join(
    x |> json_get_column("json") |> as_tibble(),
    by = "parent.id"
  ) |>
  as_tbl_json("json") |>
  # count(type)
  # count(length)
  filter(type == "array") |>
  # select(-type) |>
  # gather_array() |>
  # # count(name)
  # # count(length)
  # gather_object("BlockElement") |>
  # count(BlockElement)
  select(parent.id = child.id) |>
  as_tibble() |>
  inner_join(
    # x |> json_get_column("json") |> as_tibble(),
    x |> as_tibble(),
    by = "parent.id"
  ) |>
  # as_tbl_json("json") |>
  # # count(name)
  # # count(type)
  # count(length)
  select(parent.id = child.id) |>
  inner_join(
    x |> json_get_column("json") |> as_tibble(),
    by = "parent.id"
  ) |>
  as_tbl_json("json") |>
  # count(type)
  # count(name)
  # count(type, name)
  filter(type == "array") |>
  select(parent.id = child.id) |>
  as_tibble() |>
  inner_join(
    x |> json_get_column("json") |> as_tibble(),
    by = "parent.id"
  ) |>
  as_tbl_json("json")



temp1 <- temp |>
  filter(Element == "BL") |>
  select(parent.id = child.id) |>
  as_tibble() |>
  inner_join(
    x |> as_tibble(),
    by = "parent.id"
  ) |>
  select(parent.id = child.id) |>
  as_tibble() |>
  inner_join(
    x |> json_get_column("json") |> as_tibble(),
    by = "parent.id"
  ) |>
  as_tbl_json("json") |>
  filter(type == "array") |>
  select(parent.id = child.id) |>
  as_tibble() |>
  inner_join(
    x |> as_tibble(),
    by = "parent.id"
  ) |>
  pull(child.id)

x |>
  filter(level > 7) |>
  mutate(
    tempvar = stri_extract_first_regex(
      str = parent.id,
      pattern = "(\\d+\\.){7}"
    )
  ) |>
  filter(tempvar %in% paste0(temp1, "."))

str_split_i("a.b.c.d.e.f.g.h.i.j", "\\.", -1:3)

stri_extract_first_regex("a.b.c.d.e.f.g.h.i.j", "(\\w+\\.){7}")


qsf_tidy |> json_schema() |> prettify()

