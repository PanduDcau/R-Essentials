#Ratio estimator
# Load necessary libraries
library(ggplot2)

#import the dataset
Dataset <- read.csv("finalWork.csv")

head(Dataset)
view(Dataset)
summary(Dataset)

#set significance level
alpha = 0.025

#assign population size and sample size
pop_size = 18055
sam_size = length(Dataset$FAM_INC)

#calculate sample means
y_mean = mean(Dataset$FAM_EXP_WAT)
x_mean = mean(Dataset$FAM_INC)

#calculate sample ratio
yx_ratio = y_mean / x_mean

#calculate sum of squares
y_sq_sum = sum(Dataset$FAM_EXP_WAT^2)
x_sq_sum = sum(Dataset$FAM_INC^2)
yx_sum = sum(Dataset$FAM_EXP_WAT * Dataset$FAM_INC) 

#calculate standard error of sample ratio considering finite population correction factor
cor_fac = 1-(sam_size/pop_size)
den = sam_size*(sam_size-1)*x_mean^2
yx_cov = y_sq_sum-(2*yx_ratio*yx_sum)+(yx_ratio^2*x_sq_sum)
yx_ratio_sd = sqrt((cor_fac / den) * yx_cov)

#calculate standard error of sample ratio ignoring finite population correction factor
den = sam_size*(sam_size-1)*x_mean^2
yx_cov = y_sq_sum-(2*yx_ratio*yx_sum)+(yx_ratio^2*x_sq_sum)
yx_ratio_sd = sqrt((1 / den) * yx_cov)

#find critical value using t table
t_value = qt(alpha,sam_size-1,lower.tail = FALSE)

#find margin of error for sample mean
yx_ratio_margin = yx_ratio_sd * t_value

#find lower tail for confidence interval of population mean
yx_ratio_lower = yx_ratio - yx_ratio_margin

#find upper tail for confidence interval of population mean
yx_ratio_upper = yx_ratio + yx_ratio_margin

#print confidence interval of population mean
print(yx_ratio_lower)
print(yx_ratio_upper)


# Create a data frame for plotting
confidence_data <- data.frame(
  Estimate = c(yx_ratio),
  Lower = c(yx_ratio_lower),
  Upper = c(yx_ratio_upper)
)

# Plotting
ggplot(confidence_data, aes(x = 1, y = Estimate)) + 
  geom_point() + 
  geom_errorbar(aes(ymin = Lower, ymax = Upper), width = 0.1) +
  labs(title = "Confidence Interval for the Ratio of Family Expenditure on Water to Family Income",
       x = "",
       y = "Ratio Estimate") +
  theme_minimal() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.x=element_blank())

# Optionally, you might want to save the plot
ggsave("confidence_interval_plot.png", width = 8, height = 6)

# Calculate the correlation in between two Variables
#
correlation <- cor(Dataset$FAM_EXP_WAT, Dataset$FAM_INC)
print(paste("Correlation between Family Expenditure on Water and Family Income:", correlation))

# Plotting the relationship with a linear regression line
ggplot(Dataset, aes(x = FAM_INC, y = FAM_EXP_WAT)) + 
  geom_point(alpha = 0.5) +  # Alpha for transparency to see density of points
  geom_smooth(method = "lm", color = "blue") +  # Add linear regression line
  labs(title = "Relationship between Family Expenditure on Water and Family Income",
       x = "Family Income",
       y = "Family Expenditure on Water") +
  theme_minimal()

# Optionally, save the plot
ggsave("correlation_plot.png", width = 8, height = 6)