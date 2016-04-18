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

# Setup 2x2 plot view 
par(mfrow=c(2,2))

#Plot Upper Left
plot(powerdata_sub$datetime,powerdata_sub$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)",
     col= "black")

#plot Upper Right
plot(powerdata_sub$datetime,powerdata_sub$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage",
     col= "black")

#plot Lower Left
##Note: Legend was not rendering properly on Mac. 
plot(powerdata_sub$datetime,powerdata_sub$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energey sub metering",
     col= "black")
lines(powerdata_sub$datetime,powerdata_sub$Sub_metering_2 ,col='red') 
lines(powerdata_sub$datetime,powerdata_sub$Sub_metering_3 ,col='blue') 
legend("topright", 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black","blue","red"),
       lty = 1) 

#plot Lower Right
plot(powerdata_sub$datetime,powerdata_sub$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power",
     col= "black")

# Save to a PNG, default size is 480x480
dev.copy(png, file = "Plot4.png") 
dev.off() 

#Rest plot
par(mfrow=c(1,1))