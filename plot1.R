# Exploratory Data Analysis
# Assignment 1
#
# plot1.R
#
# Reads the household power consumption data and creates the required
# graph.
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
png(filename="plot1.png",
    width=480, height=480, units="px",
    bg="white")

hist(powerdata$Global_active_power,
     col="red",
     main="Global Active Power",
     xlab="Global Active Power (Kilowatts)")

# write out the plot.
dev.off()
