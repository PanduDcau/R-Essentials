rm(list = ls()) 

## load packages (including pacman) with pacman
##pacman::p_load(pacman, psych,tidyverse, gmodels,caret,ROCR, rpart, rpart.plot)getwd()
setwd('C:\\Users\\Jeewanthi Gamage\\Desktop\\Assignment')
heart_failure_data = read.csv("Assign.csv")


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

#chisquare test for each variable 
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$age)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$anaemia)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$smoking)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$high_blood_pressure)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$ejection_fraction)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$creatinine_phosphokinase)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$serum_creatinine)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$time)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$platelets)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$diabetes)
chisq.test(heart_failure_data$DEATH_EVENT, heart_failure_data$serum_sodium)
###  classification using logistic regression 

# create training and testing datasets

set.seed(1234)
train_ind <- heart_failure_data$DEATH_EVENT %>%
  createDataPartition(p = 0.70, list = FALSE) 

Heart_train <- heart_failure_data[train_ind, ]
Heart_test <- heart_failure_data[-train_ind, ]

#Built the Regression Model

reg_model1<-glm(DEATH_EVENT~ age + serum_sodium + serum_creatinine + sex, family=binomial, data=Heart_train)
summary(reg_model1)

reg_model2<-glm(DEATH_EVENT~ age + serum_sodium + serum_creatinine + creatinine_phosphokinase + smoking, family=binomial, data=Heart_train)
summary(reg_model2)

reg_model3<-glm(DEATH_EVENT~ age + serum_creatinine + ejection_fraction + serum_sodium + time, family=binomial, data=Heart_train)
summary(reg_model3)

deviance(reg_model1)
deviance(reg_model2)
deviance(reg_model3)

null_deviance= reg_model2[["null.deviance"]]
#mcfadden's 
McFaddenModel3= 1-deviance(reg_model3)/null_deviance
McFaddenModel3


# prediction
prediction <-predict(reg_model3, Heart_test, type="response")
Heart_test <- mutate(Heart_test, prediction = prediction)

#confusion matrix
Heart_test$Classification<-as.factor(ifelse(Heart_test$prediction>0.5,1,0)) 

Conf_Matrix <- confusionMatrix(data = Heart_test$Classification,       
                            reference = Heart_test$DEATH_EVENT,
                            positive = "1")
Conf_Matrix

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

# Train a gini-based model
Tree_model_gini <- rpart(formula =  DEATH_EVENT ~ .,
                             data = Heart_train,
                             method =  "class",
                             parms = list(split = "gini"))

rpart.plot(x = Tree_model_gini, yesno = 2, type = 0, extra = 0)

Tree_prediction_gini <- predict(object = Tree_model_gini,  
                                    newdata = Heart_test,   
                                    type = "class")

# Calculate the confusion matrix 
cmat_gini <- confusionMatrix(data = Tree_prediction_gini,       
                             reference = Heart_test$DEATH_EVENT)
cmat_gini

###################################################

#Train a information-based model
Tree_model_information <-rpart(formula =  DEATH_EVENT ~ .,
                               data = Heart_train,
                               method =  "class",
                               parms = list(split = "information"))


rpart.plot(x = Tree_model_information, yesno = 2, type = 0, extra = 0)

Tree_prediction_information <- predict(object = Tree_model_information,  
                                           newdata = Heart_test,   
                                           type = "class")

# Calculate the confusion matrix 
cmat_information <- confusionMatrix(data = Tree_prediction_information,       
                                    reference =  Heart_test$DEATH_EVENT)
cmat_information

###compare the models
cmat_gini$overall["Accuracy"]
cmat_information$overall["Accuracy"]

