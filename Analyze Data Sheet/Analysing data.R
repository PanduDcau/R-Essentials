install.packages("ISLR") #installing the package

library(ISLR) #using the package
attach(Credit) #accessing the dataset
 
View(Credit) #shows the table

#descriptive analysis of dataset

#analyse data using histogram and boxplot
boxplot(Rating)
hist(Income)

summary(Cards)


#creating a separate table from the dataset
table(Gender)

barplot(table(Gender))
barplot(table(Cards))

#compare Balance with other variables


plot(Income,Balance)
#measures the strenght of the elationship between the variables
cor.test(Income,Balance) #0.4636  --- positive correlation


#compare gender and balance
plot(Gender,Balance)  #-----boxplot----(compare between quantitative variable and categorical variable)
 #or
boxplot(Balance~Gender)


boxplot(Balance~Cards)


#find the bast simple linear regression model to predicts the balance

cor(Balance,Income)
cor(Balance,Limit)
cor(Balance,Rating)
cor(Balance,Age)
cor(Balance,Education)
cor(Balance,Cards)

#linear model
fit <- lm(Balance~Rating)
summary(fit)

fit2 <- lm(Balance~Limit)
summary(fit2)

plot(Rating,resid(fit))   #compare two data models

fit.rstd <- rstandard(fit)
qqnorm(fit.rstd)
qqline(fit.rstd)

lm(Balance~Rating)

