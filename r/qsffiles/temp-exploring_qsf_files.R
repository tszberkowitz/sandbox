
options(useFancyQuotes = FALSE)

library(tidyverse)
library(jsonlite)
library(tidyjson)
library(stringi)

datafolder <- "C:/Users/Ted/Documents/Code/R/QualtricsTools-master/data/Sample Surveys"

qsf_string <- readLines(file.path(datafolder, "Better Sample Survey", "Better_Sample_Survey.qsf"), warn = FALSE)

# qsf_string |>
#   prettify() |>
#   writeLines(con = file.path(datafolder, "Better Sample Survey", "Better_Sample_Survey_prettified.qsf"))

qsf <- fromJSON(qsf_string, simplifyVector = FALSE, flatten = FALSE)

# length(qsf)
# glimpse(qsf, max.level = 2)

survey_elements <- qsf[["SurveyElements"]]
# glimpse(survey_elements, max.level = 2)
# 
# glimpse(qsf["SurveyElements"], max.level = 2)

nonpayload <- survey_elements |>
  lapply(\(x) {x$Payload <- NULL; x}) |>
  bind_rows()

names(survey_elements) <- nonpayload[["PrimaryAttribute"]]
# glimpse(survey_elements, max.level = 2)


survey_blocks <- survey_elements[["Survey Blocks"]]

survey_questions <- survey_elements[nonpayload |> filter(Element == "SQ") |> pull(PrimaryAttribute)]
# length(survey_questions)
# glimpse(survey_questions, max.level = 2)

payloads <- survey_elements |>
  lapply(\(x) {x[["Payload"]]})
# length(payloads)
# glimpse(payloads, max.level = 2)

survey_question_payloads <- survey_questions |> lapply(\(x) {x[["Payload"]]})
# glimpse(survey_question_payloads, max.level = 2)
# 
# # lapply(survey_question_payloads, \(x) {is.list(x) && (length(x) > 0L)})
# lapply(survey_question_payloads, \(x) {sapply(x, \(y) {is.list(y) && (length(y) > 0L)})})

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
  bind_rows()

# sqp_nonlists <- survey_question_payloads |>
#   as.data.frame()

sqp_nonlists |> pull(QuestionText)

sqp_lists <- survey_question_payloads |>
  lapply(\(x) {x[names(which(!safe_to_extract))] %>% `[`(which(!is.na(names(.))))})

length(sqp_lists)
glimpse(sqp_lists, max.level = 2)

glimpse(sqp_lists[[12]], max.level = 1)
names(sqp_lists[[12]])

lapply(sqp_meta, which)
glimpse(sqp_lists[[6]], max.level = 1)
sqp_lists[[6]][["ChoiceDataExportTags"]]


sqp_lists |>
  lapply(\(x) {x[["Choices"]]})

sqp_lists |>
  lapply(\(x) {x[["Choices"]] %>% lapply(\(y) {bind_cols(n = names(y), d = y[["Display"]])})})

sqp_lists |>
  lapply(\(x) {x[["Choices"]]}) |>
  lapply(\(x) {coalesce(names(x), NA_character_)})

sqp_lists |>
  lapply(\(x) {x[["Choices"]]}) |>
  lapply(\(x) {bind_cols(n = names(x), d = unlist(x, recursive = FALSE)[["Display"]])})


sqp_lists |>
  lapply(\(x) {x[["Choices"]] |> lapply(\(y) {y[["Display"]]})})
  # lapply(\(x) {x[["Choices"]] |> lapply(\(y) {bind_rows(y[["Display"]])})})
  # lapply(\(x) {x[["Choices"]] |> lapply(\(y) {y[["Display"]] %>%
  #     bind_cols(n = names(.), d = unlist(.))})})

sqp_lists |>
  lapply(\(x) {x[["Choices"]] |> lapply(\(y) {y[["Display"]] %>% ifelse(length(.) > 0L, ., NA)})})
sqp_lists |>
  lapply(\(x) {x[["Choices"]] |> lapply(\(y) {length(y[["Display"]])})})

sqp_lists |>
  lapply(\(x) {x[["Choices"]] |> lapply(\(y) {unlist(y[["Display"]], recursive = FALSE)})})
sqp_lists |>
  lapply(\(x) {x[["Choices"]] |> sapply(\(y) {unlist(y[["Display"]])})})

sqp_lists |>
  lapply(\(x) {x[["Choices"]] |> sapply(\(y) {y[["Display"]]})})

sqp_lists |>
  lapply(\(x) {x[["Choices"]] |> sapply(\(y) {y[["Display"]] %>% ifelse(length(.) > 0L, ., NA_character_)})})


