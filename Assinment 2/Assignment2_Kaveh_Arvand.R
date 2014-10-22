#load Quandl package to extract data 
library(Quandl)

#Use the authentication code to obtain access to the data
Quandl.auth("6p2sEsU5szSygtTrZ2t-")

#Download the data using the chart's Quandl code and the required range
BitCoinData <- Quandl("BITCOIN/BITSTAMPUSD"
                      ,trim_start="2014-09-21",trim_end="2014-10-20")

#Show the first rows of the data frame
head(BitCoinData)

#Show the size of the data frame
dim(BitCoinData)

#Select the required columns and store in BitCoinData.new
BitCoinData.new<-BitCoinData[,c(1,6:8)]

#Show the column names of BitCoinData.new
names(BitCoinData.new)

#Store BitCoinData.new in a csv file
write.csv(BitCoinData.new,"BitCoinData.csv")

class(BitCoinData.new)
str(BitCoinData.new)
summary(BitCoinData.new)
BitCoinData.new

#load reshape2 package
library(reshape2)

#Melt BitCoinData from wide to long format, without melting Date variable
BitCoinData.m <- melt(BitCoinData.new,id.vars="Date")

#Show the first lines of BitCoinData.m
head(BitCoinData.m)

#load ggplot2 and scales packages
library(ggplot2)
library(scales)

#Define the data frame that is used to generate the plot
ggplot(data=BitCoinData.m, 
       
       #Define the variables that are shown by x and y axes        
       aes(x=Date, y=value ,
           
           #Define how each line graph is categorized          
           group=variable))+ 
  
  #Define a separate color for each line based on its category
  geom_line(aes(color = variable))+ 
  
  #Define labels for x and y axes
  xlab("Date") + ylab("Volume")+
  
  #Set the x axis tick mark breaks on a daily basis
  scale_x_date(breaks = date_breaks("day"))+
  
  #Transform the values of y axis to base 10 logarithmic scale and
  #setezset the y axis tick marks to show exponents
  scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10",math_format(10^.x)))+
  
  #Set the theme of the graph and change the orientation of labels of
  #tickmarks of x-axis
  theme_bw()+theme(axis.text.x= element_text(angle=90, vjust=0.5),
                   legend.title=element_blank())     
