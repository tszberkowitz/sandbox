
options(useFancyQuotes = FALSE)

library(tidyverse)
library(jsonlite)
library(tidyjson)
library(stringi)

setwd("C:/Users/Ted/Documents/GitHub/sandbox/r/qsffiles/QualtricsTools-master/data")

# datafolder <- "C:/Users/Ted/Documents/Code/R/QualtricsTools-master/data/Sample Surveys"
# qsf_string <- readLines(file.path(datafolder, "Better Sample Survey", "Better_Sample_Survey.qsf"), warn = FALSE)
# qsf_string <- readLines("./Sample Surveys/Better Sample Survey/Better_Sample_Survey.qsf", warn = FALSE)
# qsf_string <- readLines("./Long_Exhaustive_Sample_Survey.qsf", warn = FALSE)
qsf_string <- readLines("./Sample Surveys/Many Different Question Types/Sample_Survey.qsf", warn = FALSE)

# qsf_string |>
#   prettify() |>
#   writeLines(con = file.path(datafolder, "Better Sample Survey", "Better_Sample_Survey_prettified.qsf"))
# writeLines(prettify(qsf_string), "./Sample Surveys/Many Different Question Types/Sample_Survey_prettified.json")

qsf <- fromJSON(qsf_string, simplifyVector = FALSE, flatten = FALSE)

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






