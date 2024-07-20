
###############################################################
#                       MBA ANALYSIS                          # 
###############################################################

library(tidyverse)
library(readxl)
library(knitr)
library(ggplot2)
library(lubridate)
library(arules)
library(arulesViz)
library(plyr)

###############################################################

## Data preprocessing and exploring


retail<-read_excel("C:/Users/LENOVO/Desktop/Group_2/Online Retail.xlsx")

# check the missing value and remove all the rows which contain missing value

colSums(is.na(retail))
retail <- retail[complete.cases(retail), ]
colSums(is.na(retail))


retail <- retail %>% mutate(Description = as.factor(Description))
retail <- retail %>% mutate(Country = as.factor(Country))
retail$Date <- as.Date(retail$InvoiceDate)
retail$Time <- format(retail$InvoiceDate,"%H:%M:%S")
retail$InvoiceNo <- as.numeric(as.character(retail$InvoiceNo))

glimpse(retail)
str(retail)

#---------------------------------------------------------
# What time do people often purchase online ?
# In order to find the answer to this question,
# we need to extract "hour" from the time column.


retail$Time <- as.factor(retail$Time)
a <- hms(as.character(retail$Time))
retail$Time = hour(a)
retail %>% 
  ggplot(aes(x=Time)) + 
  geom_histogram(stat="count",fill="indianred")


# There is a clear effect of hour of day on order volume.
# Most orders happened between 11:00-15:00.
#---------------------------------------------------------

#---------------------------------------------------------
# How many items each customer buy?
# People mostly purchase less than 10 items 
# (less than 10 items in each invoice). 
# Those negative numbers should be returns. 


detach("package:plyr", unload=TRUE) 
retail %>% 
  group_by(InvoiceNo) %>% 
  summarize(n_items = mean(Quantity)) %>%
  ggplot(aes(x=n_items))+
  geom_histogram(fill="indianred", bins = 100000) + 
  geom_rug()+
  coord_cartesian(xlim=c(0,80))

# People mostly purchase less than 10 items 
# (less than 10 items in each invoice). 
# Those negative numbers should be returns. 
#---------------------------------------------------------

#---------------------------------------------------------
# Top 10 best sellers ???


tmp <- retail %>% 
  group_by(StockCode, Description) %>% 
  summarize(count = n()) %>% 
  arrange(desc(count))
tmp <- head(tmp, n=10)
tmp
tmp %>% 
  ggplot(aes(x=reorder(Description,count), y=count))+
  geom_bar(stat="identity",fill="indian red")+
  coord_flip()
#---------------------------------------------------------


#---------------------------------------------------------
# Association rules for online retailer
# Before using any rule mining algorithm, 
# we need to transform data from the data frame format 
# into transactions such that we have all the items 
# bought together in one row. 

retail_sorted <- retail[order(retail$CustomerID),]
library(plyr)
itemList <- ddply(retail,c("CustomerID","Date"), 
                  function(df1)paste(df1$Description, collapse = ","))


# The function ddply() accepts a data frame, 
# splits it into pieces based on one or more factors, 
# computes on the pieces, then returns the results 
# as a data frame. We use "," to separate different items. 
#---------------------------------------------------------

#---------------------------------------------------------
# We only need item transactions, so, 
# remove customerID and Date columns.


itemList$CustomerID <- NULL
itemList$Date <- NULL
colnames(itemList) <- c("items")

#---------------------------------------------------------

#---------------------------------------------------------
# Write the data from to a csv file and check whether 
# our transaction format is correct. 

write.csv(itemList,"market_basket.csv", quote = FALSE, row.names = TRUE)
getwd()

# Perfect! Now we have our transaction dataset shows the 
# matrix of items being bought together. 
# We don't actually see how often they are bought together, 
# we don't see rules either. But we are going to find out. 
#---------------------------------------------------------

#---------------------------------------------------------
# Let's have a closer look how many 
# transaction we have and what they are.

basket_data <- read.transactions('market_basket.csv', format = 'basket', sep=',')
basket_data

#---------------------------------------------------------

#---------------------------------------------------------
# DATA IS TOO COMPLEX SO FOR THIS ANALYSIS WE ARE SELECTING
# ONLY 2000 TRANSACTION 

tr <- basket_data[1:2000,]
tr
summary(tr)

# The most frequent items is POSTAGE - 849
#---------------------------------------------------------

##########################################################
# We use the Apriori algorithm in arules library 
# to mine frequent itemsets and association rules. 
# The algorithm employs level-wise search for frequent itemsets.
##########################################################

#---------------------------------------------------------
# Create some rules

rules <- apriori(tr)
summary(rules)

# 0 rules bcoz apriori algorithm takes default value for 
# confidence and suport 
# there is no rule in our dataset which has a support of 
# at lest 10% and confidence of at least 80%
#---------------------------------------------------------


#---------------------------------------------------------
# We pass supp=0.01 and conf=0.8 to return all the rules have a 
# support of at least 1% and confidence of at least 80%. 

rules<- apriori(tr,parameter = list(minlen=1,maxlen=3,supp=0.01, conf=0.8)) 

# now we have 149 rules so first wll sort all the rules by lift value
# and then will inspect only first 40 rules 

rules <- sort(rules, by='lift', decreasing = FALSE)
summary(rules)
inspect(rules[1:40])
#---------------------------------------------------------

#---------------------------------------------------------

rules <- apriori(tr,parameter=list(minlen=1, maxlen=3,supp=0.01, conf=0.8),
                 appearance=list(rhs=c("POSTAGE"),default="lhs"))
summary(rules)
inspect(rules)

# Round to 3 digits 
quality(rules)<-round(quality(rules),digits = 3)
inspect(rules)

# sort by lift
rules.sorted<-sort(rules, by="lift")
inspect(rules.sorted)


# finding redundancy
# subset.matrix <- is.subset(rules,rules)
# sparse = FALSE
subset.matrix<-is.subset(rules,rules,sparse=FALSE)
subset.matrix[lower.tri(subset.matrix,diag=TRUE)]<- NA
redundant <- colSums(subset.matrix,na.rm = TRUE) >=1
which(redundant)

#removing redundant rules
rules.pruned<-rules.sorted[!redundant]
rules.pruned<-sort(rules.pruned,by="lift")
inspect(rules.pruned)


#graps and charts And plot these top 10 rules.
library(arulesViz)
plot(rules.pruned[1:10])
plot(rules.pruned[1:10],method="grouped")
plot(rules.pruned[1:10],method="graph",control=list(type="items"))
plot(rules.pruned[1:10],method="graph", interactive = TRUE)
#################################################################################################################








