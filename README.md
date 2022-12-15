# C1-001: Rare Blood Cancers  

<img src="https://img.shields.io/badge/Study%20Status-Started-blue.svg" alt="Study Status: Started">

- Analytics use case(s): **-**
- Study type: Off-the-shelf; prevalence
- Tags: **-**
- Study lead: Edward Burn, Marti Catala
- Study start date: **-**
- Study end date: **-**
- Protocol: **-**
- Publications: **-**
- Results explorer: **-**

## Instructions to run
1) Download this entire repository (you can download as a zip folder using Code -> Download ZIP, or you can use GitHub Desktop). 
2) Open the project <i>RareBloodCancersPrevalence.Rproj</i> in RStudio (when inside the project, you will see its name on the top-right of your RStudio session)
3) Open the CodeToRun.R file - this is the only file you should need to interact with. 
- Install the latest versions of IncidencePrevalence and CDMConnector (by uncommenting and running lines 4 and 5).
- Add your database specific parameters (name of database, schema name with OMOP data, schema name to write results, table name stem for results to be saved in the result schema).
- Create a connection to the via CDMConnector (see https://odyosg.github.io/CDMConnector/articles/DBI_connection_examples.html for connection examples).
- Choose whether to run as a test (TRUE/ FALSE - if TRUE we'll run the analysis for one denominator cohort and one outcome to quickly get an idea if the full analysis code should run without a problem).
- Run the source analysis line which will start the analysis. Once completed, the results should be in your output folder.
