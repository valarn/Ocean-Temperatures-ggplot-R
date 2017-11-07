# MA415 Project #2: Data Cleaning

## About the project: 

### Goal:
data reading, cleaning, and organizing project in R. 

### Data Source:
We are focusing on maritime temperature data – air temperature and sea surface temperature. We are
collecting data worldwide. Two sources of data have been identified – the NOAA buoy system
http://www.ndbc.noaa.gov/ that reports a set of local weather readings on an hourly basis. The NOAA
coverage is comprehensive in the US and includes coverage in the Atlantic and Pacific Oceans. NOAA
coverage is not worldwide, however. In order to find data that in parts of the world not covered by
NOAA, we are using data from the Voluntary Observing Ships (VOS) program http://www.vos.noaa.gov .

### Outcome:
The outcome of this project should be a dataset that is ready for analysis and a report or presentation
that discusses the sources for the data and how it has been handled during preparation for analysis. 


## Prerequisites:
Make sure you install the following packages 
- ggplot2
- ggrepel 


## How to run:

### Manual
1- Download the data text files from the source http://www.vos.noaa.gov. Save the data in a directory, call it `data`

2- Create the directory to save the cleaned data, call it `cleaned_data`

3- Open `cleaning_script.R` and run the script


### Script (bash only)
1- Open the Terminal

2- Clone this repository or download it as a .zip and extract all the files

2- Navigate to the repository directory

3- Copy the command `./run START END` and hit Enter. Replace `START` and `END` with the year numbers you want to clean (it will clean the years from START to END inclusive). If you want to clean the data for one year, just the same value for both. 

After running the script (manually or using the script), the cleaned data will be saved in `cleaned_data`. 
