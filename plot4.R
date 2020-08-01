getwd()
library(dplyr)

##---Construcción del Data Frame-------

rawdata <- read.table("household_power_consumption.txt", sep=";", header = T,
                      stringsAsFactors = F,dec=",")
str(rawdata)

##Union de fecha y hora en una nueva variable
rawdata$Date <- as.Date.character(rawdata$Date, format = "%d/%m/%Y")
datetime <- paste(rawdata$Date,  rawdata$Time)
rawdata$DateTime <- as.POSIXct(datetime)

## Convirtiendo datos a numericos
rawdata$Global_active_power <- as.numeric(rawdata$Global_active_power)
rawdata$Global_reactive_power <- as.numeric(rawdata$Global_reactive_power)
rawdata$Voltage <- as.numeric(rawdata$Voltage)
rawdata$Global_intensity <- as.numeric(rawdata$Global_intensity)
rawdata$Sub_metering_1 <- as.numeric(rawdata$Sub_metering_1)
rawdata$Sub_metering_2 <- as.numeric(rawdata$Sub_metering_2)
rawdata$Sub_metering_3 <- as.numeric(rawdata$Sub_metering_3)

## Transformación a tible de dplyr
data <- tbl_df(rawdata)
## Selección de variable DateTime, se excluye variable "Date" y variable "Time"
data_full <- data %>% select("DateTime",3:9) 

## Filtro por fechas
datafeb <- data_full %>% filter(DateTime >= "2007-02-01 00:00:00" & DateTime <= "2007-02-02 23:59:00")
datafeb

rm(rawdata)
rm(datetime)


##------- PLOT 4 -------

png("plot4.png", width = 480, height = 480, units = "px")

par(mfrow=c(2,2))

plot(datafeb$DateTime, datafeb$Global_active_power, type="l",
     xlab = "",
     ylab = "Global Active Power")
plot(datafeb$DateTime, datafeb$Voltage, type="l",
     ylab="Voltage",
     xlab="datetime")
plot(datafeb$DateTime, datafeb$Sub_metering_1, type="l", 
     xlab="",ylab="Energy sub metering")
lines(datafeb$DateTime, datafeb$Sub_metering_2, col="red")
lines(datafeb$DateTime, datafeb$Sub_metering_3, col="blue")
legend("topright", lty=1, col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
plot(datafeb$DateTime, datafeb$Global_reactive_power, type="l",
     xlab="datetime")

dev.off()
