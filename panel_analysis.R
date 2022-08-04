#Load packages
library(pglm)

#Load in data
Stayhome <- read.csv("all_useful_data.csv",header=TRUE)

#Declare our data to be a panel data set
Stayhome.p <- pdata.frame(Stayhome,index=c("State","date"))

#Run a panel model

#Random effects
randomeff <- pglm(under_lockdown ~ deaths + GDP_per_Capita + unemployment_claims + Party + Region, data=Stayhome.p, family = binomial('probit'),model="random")
summary(randomeff)

