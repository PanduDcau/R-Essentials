rm(list = ls()) 

## load packages (including pacman) with pacman
pacman::p_load(pacman, psych,tidyverse, gmodels,caret,ROCR, rpart, rpart.plot)

setwd('C:\\Users\\Jeewanthi Gamage\\Desktop\\R')
heart_failure_data = read.csv("heart_failure_clinical_records_dataset.csv")

#import the dataset
#heart_failure_data <- read.csv("heart_failure_clinical_records_dataset.csv")

head(heart_failure_data)
view(heart_failure_data)
glimpse(heart_failure_data)
summary(heart_failure_data)
str(heart_failure_data)

## Convert numeric variable to factors
Heart_factors <- c("DEATH_EVENT", "anaemia", "diabetes", "high_blood_pressure","sex","smoking")
heart_failure_data[Heart_factors] <- lapply(heart_failure_data[Heart_factors], as.factor) 
str(heart_failure_data)
glimpse(heart_failure_data)


##### Data exploration and descriptive statistics #####


# Summary for numerical variables
numeric_vars <- heart_failure_data %>%
  select_if(is.numeric) 
describe(numeric_vars)


#boxplot grid
Heart_numeric<-c("age","creatinine_phosphokinase","ejection_fraction","platelets","serum_creatinine" ,"serum_sodium","time")
plot_list <- list()
for (variable in Heart_numeric) {
  plot <- ggplot(heart_failure_data, aes(x = DEATH_EVENT, y = get(variable))) +
    geom_boxplot(fill = "lightblue") +
    labs(x = "DEATH_EVENT", y = variable) +
    ggtitle(paste("Boxplot of", variable, "by DEATH_EVENT"))
  
  plot_list[[variable]] <- plot
}

gridExtra::grid.arrange(grobs = plot_list, ncol = 2)


#bar graph grid of factors
plot_list2 <- list()

for (var_name in Heart_factors) {
  plot <- ggplot(data = heart_failure_data, aes(x = .data[[var_name]], fill = .data[[var_name]])) +
    geom_bar() +
    labs(title = var_name) +
    theme_minimal()
  plot_list2[[var_name]] <- plot
}

gridExtra::grid.arrange(grobs = plot_list2, ncol = 2)

## heart failure on the basis of sex is insignificant 
deathbysex <- xtabs(~DEATH_EVENT + sex,  data=heart_failure_data)
print(deathbysex) 
summary(deathbysex) 

#According to the chi-square test results p-value( 0.9405) greater than 0.05. So we cannot reject the null hypothesis.

#### Density plots by the dependent variable

plot1 <- ggplot(data = heart_failure_data, aes(x = age, fill = DEATH_EVENT)) +
  geom_density(alpha = 0.3) +
  labs(title = "Density Plot of Age by Death event") +
  xlab("Age") +
  ylab("Density") +
  theme_minimal()

plot1

# t-test for numeric variables
t.test(heart_failure_data$age~heart_failure_data$DEATH_EVENT,mu=0,alternative="two.sided",conf.level=0.95, var.equal=TRUE)
t.test(heart_failure_data$creatinine_phosphokinase~heart_failure_data$DEATH_EVENT,mu=0,alternative="two.sided",conf.level=0.95, var.equal=TRUE)
t.test(heart_failure_data$ejection_fraction~heart_failure_data$DEATH_EVENT,mu=0,alternative="two.sided",conf.level=0.95, var.equal=TRUE)
t.test(heart_failure_data$platelets~heart_failure_data$DEATH_EVENT,mu=0,alternative="two.sided",conf.level=0.95, var.equal=TRUE)
t.test(heart_failure_data$serum_creatinine~heart_failure_data$DEATH_EVENT,mu=0,alternative="two.sided",conf.level=0.95, var.equal=TRUE)
t.test(heart_failure_data$serum_sodium~heart_failure_data$DEATH_EVENT,mu=0,alternative="two.sided",conf.level=0.95, var.equal=TRUE)
t.test(heart_failure_data$time~heart_failure_data$DEATH_EVENT,mu=0,alternative="two.sided",conf.level=0.95, var.equal=TRUE)


#chisquare test for other variables 
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$anaemia)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$smoking)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$high_blood_pressure)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$serum_creatinine)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$diabetes)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$DEATH_EVENT)

###  classification using logistic regression 

# Setting seed and splitting the data into training and testing module 

set.seed(1500)
train_ind <- heart_failure_data$DEATH_EVENT %>%
  createDataPartition(p = 0.70, list = FALSE) 

Heart_train <- heart_failure_data[train_ind, ]
Heart_test <- heart_failure_data[-train_ind, ]

# RUNNING Logistic regression model - 1

reg_model1<-glm(DEATH_EVENT~ age + anaemia + high_blood_pressure + serum_sodium + smoking, family=binomial, data=Heart_train)
summary(reg_model1)

deviance(reg_model1)
null_deviance= reg_model1[["null.deviance"]]

# RUNNING Logistic regression model - 2
reg_model2<-glm(DEATH_EVENT~ serum_creatinine + ejection_fraction + time + platelets , family=binomial, data=Heart_train)
summary(reg_model2)

deviance(reg_model2)


# mcfadden testing 
McFaddenModel2= 1-deviance(reg_model2)/null_deviance
McFaddenModel2


# prediction
prediction <-predict(reg_model2, Heart_test, type="response")
Heart_test <- mutate(Heart_test, prediction = prediction)

#confusion matrix
Heart_test$Classification<-as.factor(ifelse(Heart_test$prediction>0.5,1,0)) 

Conf_Matrix <- confusionMatrix(data = Heart_test$Classification,       
                            reference = Heart_test$DEATH_EVENT,
                            positive = "1")
Conf_Matrix

# ROC plotting and AUC calculation

predROCR <- prediction(prediction, Heart_test$DEATH_EVENT)
perfROCR <- performance(predROCR, "tpr", "fpr")
plot(perfROCR, colorize = TRUE) + abline(0,1)
performance(predROCR, "auc")@y.values


###  classification using Decision tree

Tree_model <- rpart(formula = DEATH_EVENT ~ age + serum_creatinine + ejection_fraction + time,
                        data = Heart_train, 
                        method =  "class")

rpart.plot(x = Tree_model, yesno = 2, type = 0, extra = 0)

# Generate predicted classes 
Tree_prediction <- predict(object = Tree_model,  
                               newdata = Heart_test,   
                               type = "class")  

# confusion matrix for the test set
Conf_Matrix_tree<-confusionMatrix(data = Tree_prediction,       
                reference = Heart_test$DEATH_EVENT)  

Conf_Matrix_tree

###################################################

# Training a gini-based model
Tree_model_gini <- rpart(formula =  DEATH_EVENT ~ .,
                             data = Heart_train,
                             method =  "class",
                             parms = list(split = "gini"))

rpart.plot(x = Tree_model_gini, yesno = 2, type = 0, extra = 0)

Tree_prediction_gini <- predict(object = Tree_model_gini,  
                                    newdata = Heart_test,   
                                    type = "class")

# Calculating confusion matrix 
cmat_gini <- confusionMatrix(data = Tree_prediction_gini,       
                             reference = Heart_test$DEATH_EVENT)
cmat_gini

###################################################

#Training information-based model
Tree_model_information <-rpart(formula =  DEATH_EVENT ~ .,
                               data = Heart_train,
                               method =  "class",
                               parms = list(split = "information"))


rpart.plot(x = Tree_model_information, yesno = 2, type = 0, extra = 0)

Tree_prediction_information <- predict(object = Tree_model_information,  
                                           newdata = Heart_test,   
                                           type = "class")

# Calculating the confusion matrix 
cmat_information <- confusionMatrix(data = Tree_prediction_information,       
                                    reference =  Heart_test$DEATH_EVENT)
cmat_information

###comparing the models
cmat_gini$overall["Accuracy"]
cmat_information$overall["Accuracy"]



