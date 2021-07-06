#create column vector for register employee Numbers
M1 <- matrix(data = 101:150, nrow = 50, ncol = 1)
M1


#column vector for Creating Gender Distribution among the columns
M2 <- matrix(rbinom(50*1,1,0.5),50,1)

#assign Male for 1 in M2
M2[M2 == 1] <- "Male"

#assign Female for 0 in M2
M2[M2 == 0] <- "Female"
M2

#Assign departments randomly according to given probabilities
M3 <- matrix(sample(c("Sales", "Accounts", "HR"), size=50, replace=TRUE, prob=c(.50,.25,.25)),50,1)
M3




#copy M3 vector to M4
M4 <- M3

#Get random salary values for Sales division with given mean & standard diviation
Msales <- round(rnorm(n=sum(M3 == "Sales"), mean=15000, sd=1250))
Msales

#replace Sales strings with random salary values in Msales vector
M4[M4 == "Sales"] <- sample(Msales) 

#get random salary values for Accounts division within given min and max values
Maccounts <- round(seq(from = 15000, to = 20000, length.out = sum(M3 == "Accounts")))
Maccounts

#replace Accounts strings with random salary values in Maccounts vector
M4[M4 == "Accounts"] <- sample(Maccounts)

#get random salary values for HR division with given mean & standard diviation
Mhr <- round(rnorm(n=sum(M3 == "HR"), mean=25000, sd=2500))
Mhr

#replace HR strings with random salary values in Mhr vector
M4[M4 == "HR"] <- sample(Mhr)

#convert M4 from string to numeric vector
M4 <- matrix(apply(M4, 1,as.numeric),50,1)
M4




#combine 4 column vectors into a data frame
df <- data.frame(col1 = M1, col2 = M2, col3 = M3, col4 = M4)

#rename data frame columns
colnames(df) <- c("EmpNo", "Gender", "Department", "Salary")
df




#get first 6 observations
head(df)

#get first 6 observations
tail(df)

#summary of the data frame
summary(df)

summary(df$Gender)
summary(df$Salary)

df
plot(df$EmpNo,df$Salary,xlab="Employee",ylab = "Salary",main = "Employess Salary Distribution")

