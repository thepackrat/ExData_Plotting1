# Exploratory Data Analysis
# Assignment 1
#
# plot4.R
#
# Reads the household power consumption data and creates a combined
# showing, active and reactive power, sub-monitoring levels and
# voltage.  the three sub-metering levels.
#
# We assume that the base data household_power_consumption.txt already
# exists in the current directory.


# read in data.
# Checking manually with grep, 1/2/2007 starts on line 66638 while
# 2/2/2007 ends on line 69517. We can use this as the data is static.

setClass("dmyDate")
setAs("character","dmyDate", function(from) as.Date(from, format="%d/%m/%Y") )

firstline <- 66638
lastline <- 69517

# As we are skipping input lines, we would otherwise miss the headers unless
# we get them with a second read.
powerheaders <- read.table("household_power_consumption.txt",
                           header=TRUE,
                           sep=";",
                           na.strings=c("?"),
                           colClasses=c("Date", NA, NA, NA, NA,
                               NA, NA, NA, NA),
                           nrows=2)

powerdata <- read.table("household_power_consumption.txt",
                        header=FALSE,
                        sep=";",
                        na.strings=c("?"),
                        colClasses=c("dmyDate", NA, NA, NA, NA,
                            NA, NA, NA, NA),
                        skip=firstline-1,  # don't count first line.
                        nrows=(lastline - firstline + 1))

colnames(powerdata) <- colnames(powerheaders)

# set up the PNG output file device.
png(filename="plot4.png",
    width=480, height=480, units="px",
    bg="white")

# create 2x2 matrix of plots.
par(mfrow=c(2,2))
# used for custom axes later.
width <- dim(powerdata)[[1]]


### top left plot
plot(powerdata$Global_active_power,
     type="l",
     ylab="Global Active Power",
     xlab=NA,
     xaxt="n")
# custom X axis.
axis(1, labels=c("Thu", "Fri", "Sat"), at=c(0,width/2,width))


### top right plot
plot(powerdata$Voltage,
     type="l",
     ylab="Voltage",
     xlab="datetime",
     xaxt="n")
# custom X axis.
axis(1, labels=c("Thu", "Fri", "Sat"), at=c(0,width/2,width))


### bottom left plot
plot(powerdata$Sub_metering_1,
     type="l", col="black",
     ylab="Energy sub metering",
     xlab=NA,
     xaxt="n")

# add legend in the top right.
legend("topright",
       c('Sub_metering_1', "Sub_metering_2", "Sub_metering_3"),
       lw=1,
       col=c("black", "red", "blue"))

# add points to the graph for the other two time series (setting
# colours)
points(powerdata$Sub_metering_2,
     type="l", col="red")

points(powerdata$Sub_metering_3,
       type="l", col="blue")

# custom X axis.
width <- dim(powerdata)[[1]]
axis(1, labels=c("Thu", "Fri", "Sat"), at=c(0,width/2,width))


### bottom right plot
plot(powerdata$Global_reactive_power,
     type="l",
     ylab="Global_reactive_power",
     xlab="datetime",
     xaxt="n")
# custom X axis.
axis(1, labels=c("Thu", "Fri", "Sat"), at=c(0,width/2,width))


# write out the plot.
dev.off()
