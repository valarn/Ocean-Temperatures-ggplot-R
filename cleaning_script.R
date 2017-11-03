#!/usr/bin/env Rscript
require(maps)
require(mapdata)
library(ggplot2)
library(ggrepel)
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
  EDA.year = NULL
  # for every month
  for (i in 1:length(MONTHS)) {
    # construct the filename
    filename <- paste(FILES_PATH, MONTHS[i], "_", YEAR, EXT, sep = "")
    
    # read the file
    print(filename)
    current <- readLines(filename)
    
    # temporary dataframe for current month months[i]
    df <- NULL
    EDA.Month = NULL
    total_sea_temp = 0
    total_air_temp = 0
    total_rows = 0
    # for every row in the file
    for (j in 1:length(current)) {
      # get the row, and deparate the columns
      tmp <- current[j]
      subtmp <- paste0("SubEast10", "Ship", "tm", substr(tmp, 1, 21), substr(tmp, 86, 89), substr(tmp, 70, 73))

      # isolate the Latitude and Longitude values to check if there are in our sub-region ranges
      # since as.numeric() gives warnings if it finds NA, we need to temporarily suprress warnings
      # source: https://stackoverflow.com/questions/16194212/how-to-suppress-warnings-globally-in-an-r-script
      oldw <- getOption("warn")
      options(warn = -1)
      LAT = as.numeric(substr(tmp, 13, 17))   # slices the row and converts to a number
      LON = as.numeric(substr(tmp, 18, 21))
      HOUR = as.numeric(substr(tmp, 9, 12))
      temp_air = as.numeric(substr(tmp, 70, 73))
      temp_sea = as.numeric(substr(tmp, 86, 89))
      options(warn = oldw)
 
      # checks if LAT and LON are in the range 
      # also checks if time when data is collected (hour) is within 6 hours of noon 
      # FIX: --> error in feb 2010 w/ && (HOUR %in% 600:1800)
      if ((LAT %in% 600:2000) && (LON %in% 80:100)) {
        # add to the temporary data frame
          if (HOUR == 1200) {
            substr(subtmp, 14, 15) <- "+0"
            df <- rbind(df, subtmp)
          }
          else if ((HOUR %in% 600:1199)) {
            substr(subtmp, 14, 15) <- paste0("-", toString(1200-HOUR))
            df <- rbind(df, subtmp)
          }
         else if ((HOUR %in% 1201:1800)) {
          substr(subtmp, 14, 15) <- paste0("+", toString(HOUR-1200))
          df <- rbind(df, subtmp)
         }
          else {
            substr(subtmp, 14, 15) <- "A "
            df <- rbind(df, subtmp)
          }

	total_air_temp = sum(total_air_temp, temp_air, na.rm = TRUE)
        total_sea_temp = sum(total_sea_temp, temp_sea, na.rm = TRUE)
        total_rows = total_rows + 1
      }
    }
    # averege tem of each month 
    total_rows = total_rows*10
    AVE.AIR.TEMP = total_air_temp/total_rows
    AVE.SEA.TEMP = total_sea_temp/total_rows
    EDA.MONTH = cbind(MONTHS[i], AVE.SEA.TEMP, AVE.AIR.TEMP)
    EDA.year = rbind(EDA.year, EDA.MONTH)

    # generate the columns with given sizes
    data.clean.month <-
      read.fwf(textConnection(df), widths = c(9, 4, 2, 12, 5, 4, 4, 4))
    
    # name the columns
    names(data.clean.month) <-
      c("REGION","TYP","DIFF", "LOCALTIME", "LAT", "LON", "SST", "AT")
  
    # omit all rows with "NA" values in any column
    data.clean.month <- na.omit(data.clean.month)
    
    #(Formatting) Fix Range of lat and AT and SST
    if (nrow(data.clean.month) >= 1) {
      for(i in 1:nrow(data.clean.month)){
        data.clean.month$AT[i] <- toString(as.numeric(data.clean.month$AT[i])/10)
        data.clean.month$SST[i] <- toString(as.numeric(data.clean.month$SST[i])/10)
        data.clean.month$LAT[i] <- toString(floor(as.numeric(data.clean.month$LAT[i])/100))
      }
    }
    
    # add all the temporary data frame of the month to the data frame of the year
    df.year <- rbind(df.year, data.clean.month)

  }
  
  #removing the quantile in AT
  #removing the quantile in SST
  df.year.with.extremes = df.year
  
  A = quantile(as.numeric(df.year$SST), prob = c(0.99))
  B = quantile(as.numeric(df.year$SST), prob = c(0.01))
  x = quantile(as.numeric(df.year$AT), prob = c(0.99))
  y = quantile(as.numeric(df.year$AT), prob = c(0.01))
  
  df.year = df.year[df.year$AT < x,]
  df.year = df.year[df.year$AT > y,]
  df.year = df.year[df.year$SST < A,]
  df.year = df.year[df.year$SST > B,]
  
  #global map
  global <- map_data("world")
  ggplot() + geom_polygon(data = global, aes(x=long, y = lat, group = group)) +
    coord_fixed(1.3)
  
  #add borders
  ggplot() +
    geom_polygon(data = global, aes(x=long, y = lat, group = group), fill = NA, color = "red") +
    coord_fixed(1.3)
  
  #fill in 
  gg1 <- ggplot() +
    geom_polygon(data = global, aes(x=long, y = lat, group = group), fill = "green", color = "black") +
    coord_fixed(1.3)
  gg1
  
  #specific latitude/longitude (of year)
  df2 <- data.frame(
    long = as.numeric(df.year$LON),
    lat = as.numeric(df.year$LAT),
    stringsAsFactors = FALSE
  )
  
  #xlim and ylim can be manipulated to zoom in or out of the map
  final <-  gg1 +
    geom_point(data=df2, aes(long, lat), colour="red", size=1) +
    ggtitle(paste("Subcontinent East", YEAR, sep=" ")) +
    geom_text_repel(data=df2, aes(long, lat, label="")) + xlim(60,110) + ylim(0,40)

  ggsave(paste("map", YEAR, ".png", sep=""))

  # create the save path for the clean data ans save it
  SAVE_PATH_ALL = paste(SAVE_PATH, SAVE_DIR, "/", FILENAME, "_", YEAR, SAVE_EXT, sep = "")
  print(SAVE_PATH)
  save(df.year, file = SAVE_PATH_ALL)
  final

  names(EDA.year) = c("month","ave.sea.temp","ave.air.temp")
  SAVE_PATH_AVE = paste(SAVE_PATH, SAVE_DIR, "/", "ave_temp", "_", YEAR, SAVE_EXT, sep = "")
  print(SAVE_PATH)
  save(EDA.year, file = SAVE_PATH_AVE)

  SAVE_PATH_EXTEREMES = paste(SAVE_PATH, SAVE_DIR, "/", "data_with_extremes", "_", YEAR, SAVE_EXT, sep = "")
  print(SAVE_PATH_EXTEREMES)
  save(df.year.with.extremes, file = SAVE_PATH_EXTEREMES)

}


# cleans all data for years 2001 - 2016
cleanAllData <- function(start, end) {
  for (k in start:end) {
    str_frm = toString(k)          # converts year to a string in preparation to call the function
    cleanAllMonthsOfYear(str_frm)  # calls the function for current year
  }
}

# comment in the line below to clean all data from 2001-2016
cleanAllData(START, END)
