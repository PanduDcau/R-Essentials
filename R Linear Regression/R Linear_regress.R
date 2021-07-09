
# 1)Loading the package and dataset
library(MASS)
attach(birthwt)

# 2)analysing the dataset
View(birthwt)


# 3)Analysing qualitative variables
par(mfrow=c(2,3))
barplot(smoke)
barplot(race)
barplot(ui)

# 4)Analysing quantitative variables
plot(age)
plot(lwt)
plot(ptl)

# 5)Descriptive analysis
#age
mean(age)
sd(age)
var(age)
mode(age)
median(age)

#lwt
mean(lwt)
sd(lwt)
var(lwt)
mode(lwt)
median(lwt)

#ptl
mean(ptl)
sd(ptl)
var(ptl)
mode(ptl)
median(ptl)

# 6)Relation between age and bwt
plot(age,bwt)
cor(age~bwt)
fit<- lm(age~bwt)
summary(fit)

# 7)Set the seed

set.seed(17001994)


# 8) Create a new sample dataset

smoking<- birthwt[birthwt$smoke==1,]
y <- smoking[sample(nrow(smoking),25),]
y

non_smoking<- birthwt[birthwt$smoke==0,]
b <- non_smoking[sample(nrow(non_smoking),25),]
b

birthwt_sample <- rbind(y,b)
birthwt_sample


# 9)finding mean and standard deviation
m1 <- mean(birthwt_sample$bwt[birthwt_sample$smoke==0])
s1 <- sd(birthwt_sample$bwt[birthwt_sample$smoke==0])

m2 <- mean(birthwt_sample$bwt[birthwt_sample$smoke==1])
s2 <- sd(birthwt_sample$bwt[birthwt_sample$smoke==1])


# 10)analysing above data
n1 <- 25
n2 <- 25

sp <- sqrt(((n1-1)*s1^2 + (n2-1)*s2^2)/(n1+n2-2))
t <- (m1-m2)/(sp*sqrt((1/n1)+(1/n2)))
pt(t,n1+n2-2)

# 11)Simple Linear Regression model to predict the birth weight
attach(birthwt)
fit<-lm(bwt~lwt)
fit
summary(fit)