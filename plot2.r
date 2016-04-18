library(dplyr)

## Acquire Data from source and load data elements:
if (!file.exists("rawdata")){
        fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileurl, "power_consumption.zip")
        unzip("power_consumption.zip", exdir= "./rawdata")## Now all files are in ./rawdata/
        ## Remove unneeded variables
        rm(fileurl)
}

## Read in power consumption Data
## Note that in this dataset missing values are coded as `?` and deliminated with the ";" character
## 

#check if the data set already exists
if(!exists("powerdata_sub")) {
        ## Get all the data
        powerdata <-read.delim("./rawdata/household_power_consumption.txt", sep = ";", header =TRUE, na.strings = "?")
        
        ## Fix date/time stamp and place in new column
        powerdata$datetime <-as.POSIXct(strptime(paste(powerdata$Date, powerdata$Time), "%d/%m/%Y %H:%M:%S"))
        
        ## filter to only the 2 days we care about, 2/1/2007 - 2/2/2007
        powerdata_sub <- filter(powerdata, datetime >= as.POSIXct("2007-02-01 00:00:00"), datetime <= as.POSIXct("2007-02-02 23:59:59"))
}

# Plot  and style accordingly. 
plot(powerdata_sub$datetime,powerdata_sub$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)",
     col= "black")

# Save to a PNG, default size is 480x480
dev.copy(png, file = "Plot2.png") 
dev.off() 
