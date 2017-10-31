#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if (length(args) >= 4) {
  START = as.numeric(args[1])
  END = as.numeric(args[2])
  SAVE_PATH = args[3]
  SAVE_DIR = args[4]
} else {
  START = 2001
  END = 2016
  SAVE_PATH = "./"               # path for saving and opening data files
  SAVE_DIR = "cleaned_data"   # name of directory to save the clean data
}

# info to save the clean data
FILENAME = "df"
SAVE_EXT = ".Rdata"

# info to construct the filenames
MONTHS = c("jan", "feb", "mar",
           "apr", "may", "jun",
           "jul", "aug", "sep",
           "oct", "nov", "dec")
EXT = ".txt"
DATA_PATH = './data/'

# cleans the data for a specific year == YEAR
cleanAllMonthsOfYear <- function(YEAR) {
  # start constructing the file path 
  FILES_PATH = paste(DATA_PATH, YEAR, "/VOSClim_GTS_", sep ='')
  
  # data fram variable of YEAR
  df.year <- NULL
  
  # for every month
  for (i in 1:length(MONTHS)) {
    # construct the filename
    filename <- paste(FILES_PATH, MONTHS[i], "_", YEAR, EXT, sep = "")
    
    # read the file
    print(filename)
    current <- readLines(filename)
    
    # temporary dataframe for current month months[i]
    df <- NULL
    
    # for every row in the file
    for (j in 1:length(current)) {
      # get the row, and deparate the columns
      tmp <- current[j]
      subtmp <-
        paste0(substr(tmp, 1, 21), substr(tmp, 69, 73), substr(tmp, 84, 89))
      
      # TODO: supress warnings when converting LAT and LON
      # isolate the Latitude and Longitude values to check if there are in our sub-region ranges
      LAT = as.numeric(substr(tmp, 13, 17))   # slices the row and converts to a number
      LON = as.numeric(substr(tmp, 18, 21))   # slices the row and converts to a number
      
      # checks if LAT and LON are in the range
      if ((LAT %in% 600:2300) && (LON %in% 81:99)) {
        # add to the temporary data frame
        df <- rbind(df, subtmp)
      }
    }
    
    # generate the columns with given sizes
    data.clean.month <-
      read.fwf(textConnection(df), widths = c(4, 2, 2, 4, 5, 4, 1, 4, 2, 4))
    
    # name the columns
    names(data.clean.month) <-
      c("YR", "MO", "DY", "HR", "LAT", "LON", "IT", "AT", "SI", "SST")
    
    # omit all rows with "NA" values in any column
    data.clean.month <- na.omit(data.clean.month)
    
    # add all the temporary data frame of the month to the data frame of the year
    df.year <- rbind(df.year, data.clean.month)
  }
  
  # create the save path for the clean data ans save it
  SAVE_PATH = paste(SAVE_PATH, SAVE_DIR, "/", FILENAME, "_", YEAR, SAVE_EXT, sep = "")
  print(SAVE_PATH)
  save(df.year, file = SAVE_PATH)
}

# cleans all data for years 2001 - 2006
cleanAllData <- function(start, end) {
  for (k in start:end) {
    str_frm = toString(k)          # converts year to a string in preparation to call the function
    cleanAllMonthsOfYear(str_frm)  # calls the function for current year
  }
}

# comment in the line below to clean all data from 2001-2016
cleanAllData(START, END)
