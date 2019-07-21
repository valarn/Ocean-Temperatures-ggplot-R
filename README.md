# Ocean Temperature Subcontinent East region

## About the project: 

### Goal:
data reading, cleaning, and organizing project in R. 

### Data Source:
The outcome of this project are datasets that are ready for analysis and this report which discusses the sources for the data and how it has been handled during preparation for analysis. 
We are focusing on maritime temperature data – air temperature and sea surface temperature. We are collecting and cleaning data from the Subcontinent East region. Two sources of data have been identified – the NOAA buoy system http://www.ndbc.noaa.gov/ that reports a set of local weather readings on an hourly basis. The NOAA coverage is comprehensive in the US and includes coverage in the Atlantic and Pacific Oceans. However, the NOAA coverage is not worldwide. In order to find data in our region: Subcontinent East, we are using data from the Voluntary Observing Ships (VOS) program http://www.vos.noaa.gov.

### Outcome:
The outcome of this project should be a dataset that is ready for analysis and a report or presentation
that discusses the sources for the data and how it has been handled during preparation for analysis. 
The repository contains the following: 
- `cleaning_script.R`: the cleaning script we used to clean our data, and generate the maps and eda data
- Writeup: the report of how we collected, cleaned, and presented the data. It also includes the EDA of the data, and an appendix with all the graphs and maps we generated. 
- `cleaned_data`: the directory where all the cleaned data for years 2001-2016 are
- `eda_data`: the directory where all the data we formatted and used for the EDA are
- `maps`: the directory that contains the maps we generated per year in png format
- `data`: contains all the raw data files, separated into sub-directory per year
- `Data_Analysis.Rmd`: the R markdown we used for our EDA, which we included in the Writeup as well
- `Data_Analysis.pdf`: for unformatted analysis of data (all the plots). For a clean version, please see `Writeup.pdf`
- `run.sh`: the bash script used to download the data and run the R script to clean the data and save them
- `scripts`: a directory where helper scripts for `run.sh` reside

 
## Prerequisites:
Make sure you install the following packages 
- ggplot2
- ggrepel 

## How to run:

### Manual
- Download the data text files from the source http://www.vos.noaa.gov. Save the data in a directory, call it `data`

- Create the directory to save the cleaned data, call it `cleaned_data`

- Open `cleaning_script.R` and run the script


### Script (bash only)
- Open the Terminal

- Clone this repository or download it as a .zip and extract all the files

- Navigate to the repository directory

- Copy the command `./run START END` and hit Enter. Replace `START` and `END` with the year numbers you want to clean (it will clean the years from START to END inclusive). If you want to clean the data for one year, just the same value for both. 

After running the script (manually or using the script), the cleaned data will be saved in `cleaned_data`. 
