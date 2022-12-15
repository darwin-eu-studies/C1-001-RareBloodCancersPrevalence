# Load packages ------

# to install latest version of IncidencePrevalence
# remotes::install_github("darwin-eu/CDMConnector")
# remotes::install_github("darwin-eu/IncidencePrevalence")

# load r packages
library(SqlRender)
library(CirceR)
library(CDMConnector)
library(IncidencePrevalence)
library(here)
library(DBI)
library(dbplyr)
library(dplyr)
library(readr)
library(log4r)
library(stringr)

# database metadata and connection details -----
# The name/ acronym for the database
db_name<-"...."

# Set output folder location -----
# the path to a folder where the results from this analysis will be saved
output_folder<-here("Results", db_name)

# Database connection details -----
# In this study we also use the DBI package to connect to the database
# set up the dbConnect details below (see https://dbi.r-dbi.org/articles/dbi for more details)
# you may need to install another package for this 
# (although RPostgres is included with renv in case you are using postgres or redshift)
# eg for postgres 
# db <- dbConnect(RPostgres::Postgres(), dbname = server_dbi, 
#                 port = port, host = host, user = user,
#                 password = password)
db <- dbConnect("....")

# The name of the schema that contains the OMOP CDM with patient-level data
cdm_database_schema<-"...."

# The name of the schema that contains the vocabularies 
# (often this will be the same as cdm_database_schema)
vocabulary_database_schema<-cdm_database_schema

# The name of the schema where results tables will be created 
results_database_schema<-"...."

# Name of outcome table in the result table where the outcome cohorts will be stored
# Note, if there is an existing table in your results schema with the same names
# it will be overwritten 
# Also note, this must be lower case
outcome_table_name<-"...."

# create cdm reference ----
cdm <- CDMConnector::cdm_from_con(con = db, 
                                  cdm_schema = cdm_database_schema,
                                  write_schema = results_database_schema)
# check database connection
# running the next line should give you a count of your person table
cdm$person %>% 
  tally()

# Run the study ------
run_as_test<-TRUE
source(here("RunStudy.R"))
# after the study is run you should have a zip folder in your output folder to share
