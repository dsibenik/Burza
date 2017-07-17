#!/usr/bin/Rscript

################################################################################
### author: Davor Sibenik
#           dsibenik@live.com
#

################################################################################
###libraries:
#activate <- function( name ){
#  if( any(grepl(name, installed.packages())) ){
#    library(name, character.only=TRUE)
#  }
#  else{
#    install.packages(name)
#    library(name, character.only=TRUE)
#  }
#}
#activate("readxl")


################################################################################
### function declaration:

specify_decimal <- function(x, k){
	format(round(x, k), nsmall=k)
}

get_data <- function(name){
  #casts data in a specific form

  data <- read.csv( paste("./data/",name,".csv", sep="") )
  data <- data[ c(1,5) ]
  data <- data[ nrow(data):1, ]
  data$Last <- sub("\\.", "", data$Last)
  data$Last <- as.numeric(sub(",", ".", data$Last) )
  data <- data.frame(data$Date, data$Last )
  colnames(data) <- c("Date", "Close")

  return(data)
}

returns_mon <- function( name ){

  data <- get_data(name)

  data$Date <- as.Date(data$Date, "%d.%m.%Y")
  data$Date <- format(data$Date, "%m/%Y")

  data <- data[ !is.na(data$Close), ]
  data <- data[ !duplicated(data$Date, fromLast=TRUE), ]

  returns_mon <- data.frame( 0, 0 )
  colnames(returns_mon) <- c("Date", "Value")
  if( nrow(data) == 0 )
    return( returns_mon )

  close <- data$Close
  date <- data$Date
  date <- date[-1]

  returns_mon <- numeric( length(close)-1 )
  for( i in 1:(length(close)-1)){
    returns_mon[i] <- close[i+1]/close[i]-1
  }

  returns_mon <- data.frame( date, returns_mon )
  colnames(returns_mon) <- c("Date", "Value")
  return( returns_mon )
}


returns_kov <- function( names ){
  #calculates covariance matrix

  n <- length(names)
  kov_mat <- matrix( numeric(n*n), nrow=n, dimnames=list(names, names) )
  for( i in 1:n )
    for( j in i:n ){
      kov_mat[i,j] <- cov( returns_mon(names[i])$Value, returns_mon(names[j])$Value )
      kov_mat[j,i] <- kov_mat[i,j]
    }

  return(kov_mat)
}


returns_kor <- function( names ){
  #calculates correlation matrix

  n <- length(names)
  kor_mat <- matrix( numeric(n*n), nrow=n, dimnames=list(names, names) )
  for( i in 1:n )
    for( j in i:n ){
      kor_mat[i,j] <- cor( returns_mon(names[i])$Value, returns_mon(names[j])$Value )
      kor_mat[j,i] <- kor_mat[i,j]
    }

  return(kor_mat)
}


################################################################################
###calculation:

names <- read.table("list_work.txt", sep="")
names <- as.vector(names[,1])

n <- length(names)

#calculate returns:
returns <- data.frame( Name = character(n), Mean = numeric(n), StdDev=numeric(n) )

#calculate individual return statistics:
for( i in 1:length(names) ){
  returns[i,]$Mean <- specify_decimal(mean( returns_mon(names[i])$Value ), 4)
  returns[i,]$StdDev <- specify_decimal(sd( returns_mon(names[i])$Value ),4)
}
returns[,1] <- names
write.table(returns, file="output.txt",sep=",", row.names=FALSE)

#calculate covariation matrix:
#kov_mat <- returns_kov( names )
#kov_mat


#calculate correlation matrix:
#kor_mat <- returns_kor( c("kras","ledo","podr") )
#kor_mat


#simulate portfolio with different weights:
#portfolio_sim <- matrix( numeric(), ncol=5)
#colnames(portfolio_sim) <- c( "w1", "w2", "w3", "ex. return", "sd")
#for( w1 in seq(1,0,-0.2) )
#  for( w2 in (1-seq(w1, 1, 0.2)) ){
#    w3 <- 1-w1-w2
#    weight <- c(w1,w2,w3)
#    expected_return <- sum( weight*returns_stat[,1] )
#
#    tmp <- crossprod( weight*returns_stat[,2] )
#    tmp2 <- w1*w2*kov_mat["kras","ledo"]+w1*w3*kov_mat["kras","podr"]+w2*w3*kov_mat["ledo","podr"]
#    sd_portfolio <- sqrt(tmp+2*tmp2)
#    portfolio_sim <- rbind( portfolio_sim, c( weight, expected_return, sd_portfolio) )
#  }
#portfolio_sim


#simulatuion with maximum exptected returns:
#portfolio_sim[ portfolio_sim[,4] == max(portfolio_sim[,4]) ]


#simulation with minimum sd:
#portfolio_sim[ portfolio_sim[,5] == min(portfolio_sim[,5]) ]

#plot(portfolio_sim[,"sd"], portfolio_sim[,"ex. return"], xlab="Std. devijacija", ylab="Ocekivani povrat")
