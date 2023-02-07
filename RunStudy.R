# create directory if it does not already exist ----
if (!file.exists(output_folder)) {
  dir.create(output_folder, recursive = TRUE)
}
# start log ----
log_file <- paste0(output_folder, "/log.txt")
logger <- create.logger()
logfile(logger) <- log_file
level(logger) <- "INFO"
# tables --- 
table_outcome <- paste0(table_prefix, "_outcome")
table_dpop_sex <- paste0(table_prefix, "_dpop_sex")
table_ph <- paste0(table_prefix, "_dpop_ph")
table_age <- paste0(table_prefix, "_dpop_age")
table_point_prev <- paste0(table_prefix, "_point_prev")
table_period_prev <- paste0(table_prefix, "_period_prev")
# instantiate outcome cohorts ----
info(logger, "INSTANTIATE OUTCOME COHORTS")
outcome_cohorts <- readCohortSet(here(
  "outcomeCohorts"
))
info(logger, "- getting outcomes")
cdm <- generateCohortSet(cdm, outcome_cohorts,
  cohortTableName = table_outcome,
  overwrite = TRUE
)
# get denominator cohorts -----
info(logger, "GETTING DENOMINATOR COHORTS")
info(logger, "- getting denominator - primary and sex")
cdm$denominator_primary_sex <- generateDenominatorCohortSet(
  cdm = cdm,
  tablePrefix = table_dpop_sex,
  startDate = as.Date("2010-01-01"),
  sex = c("Male", "Female", "Both"),
  daysPriorHistory = 365,
  verbose = TRUE
)
  info(logger, "- getting denominator - prior history")
  cdm$denominator_prior_history <- generateDenominatorCohortSet(
    cdm = cdm,
    tablePrefix = table_ph,
    startDate = as.Date("2010-01-01"),
    daysPriorHistory = c(0, 1095),
    verbose = TRUE
  )
  info(logger, "- getting denominator - age_gr")
  cdm$denominator_age_gr <- generateDenominatorCohortSet(
    cdm = cdm,
    tablePrefix = table_age,
    startDate = as.Date("2010-01-01"),
    ageGroup = list(
      # age_gr_1
      c(0, 9), c(10, 19), c(20, 29), c(30, 39), c(40, 49),
      c(50, 59), c(60, 69), c(70, 79), c(80, 89),
      c(90, 99), c(100, 150),
      # age_gr_2
      c(0, 44), c(45, 64), c(65, 150)
    ),
    daysPriorHistory = 365,
    verbose = TRUE
  )

# estimate prevalence -----
denominators <- c(
    "denominator_primary_sex",
    "denominator_age_gr",
    "denominator_prior_history"
  )
prevalence_estimates <- list()
for (i in seq_along(denominators)) {
  info(logger, paste0("- getting point prevalence for ", denominators[[i]]))
  prevalence_estimates[[paste0(
    "point_prevalence_",
    denominators[[i]]
  )]] <- estimatePointPrevalence(
    cdm = cdm,
    tablePrefix = table_point_prev,
    denominatorTable = denominators[[i]],
    outcomeTable = table_outcome,
    outcomeCohortId = outcome_cohorts$cohortId,
    outcomeCohortName = outcome_cohorts$cohortName,
    interval = c("years"),
    verbose = TRUE
  )

  info(logger, paste0("- getting period prevalence for ", denominators[[i]]))
  prevalence_estimates[[paste0(
    "period_prevalence_",
    denominators[[i]]
  )]] <- estimatePeriodPrevalence(
    cdm = cdm,
    tablePrefix = table_period_prev,
    denominatorTable = denominators[[i]],
    outcomeTable = table_outcome, 
    outcomeCohortId = outcome_cohorts$cohortId,
    outcomeCohortName = outcome_cohorts$cohortName,
    completeDatabaseIntervals = TRUE,
    fullContribution = c(TRUE, FALSE),
    interval = c("years"),
    verbose = TRUE
  )
}
# gather results and export -----
info(logger, "GATHERING RESULTS")
study_resuls <- gatherIncidencePrevalenceResults(cdm,
                                                 resultList = prevalence_estimates,
                                                 databaseName = db_name
)
info(logger, "ZIPPING RESULTS")
exportIncidencePrevalenceResults(
  result = study_resuls,
  zipName = paste0(c(db_name, 
                     "C1_001_Results", 
                     format(Sys.Date(), format="%Y%m%d")),
                   collapse = "_"),
  outputFolder = output_folder
)

print("-- Thank you for running the study!")
print("-- If all has worked, there should now be a zip folder with your results in the output folder to share")
