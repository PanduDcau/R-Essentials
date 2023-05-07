# load the required libraries
library(dplyr)
library(ggplot2)
library(scales)

# read the data from the CSV file
data <- read.csv("C:/GlassdoorGenderPayGap.csv")

# summarize the data by gender
gender_summary <- data %>%
  group_by(Gender) %>%
  summarize(
    n = n(),
    mean_base_pay = mean(BasePay),
    median_base_pay = median(BasePay),
    sd_base_pay = sd(BasePay),
    min_base_pay = min(BasePay),
    max_base_pay = max(BasePay)
  )

# print the summary statistics
print(gender_summary)

# create a boxplot of base pay by gender
ggplot(data, aes(x = Gender, y = BasePay)) +
  geom_boxplot(fill = "lightblue") +
  labs(x = "Gender", y = "Base Pay") +
  scale_y_continuous(labels = dollar_format(scale = 0.0001)) +
  ggtitle("Base Pay by Gender") +
  theme_bw()



# load the required libraries
library(dplyr)
library(ggplot2)
library(scales)

# read the data from the CSV file
data <- read.csv("C:/GlassdoorGenderPayGap.csv")

# define a function to generate bootstrap samples
bootstrap <- function(data) {
  sample_data <- sample_n(data, size = nrow(data), replace = TRUE)
  mean_diff <- mean(sample_data$BasePay[sample_data$Gender == "Male"]) - mean(sample_data$BasePay[sample_data$Gender == "Female"])
  return(mean_diff)
}

# generate 10,000 bootstrap samples
set.seed(123)
bootstrap_samples <- replicate(10000, bootstrap(data))

# calculate the 95% confidence interval
ci <- quantile(bootstrap_samples, c(0.025, 0.975))

# plot the bootstrap distribution
ggplot(data.frame(bootstrap_samples), aes(x = bootstrap_samples)) +
  geom_density(fill = "lightblue", alpha = 0.5) +
  geom_vline(xintercept = ci[1], linetype = "dashed", color = "red") +
  geom_vline(xintercept = ci[2], linetype = "dashed", color = "red") +
  labs(x = "Difference in Mean Base Pay (Male - Female)", y = "Density") +
  ggtitle("Bootstrap Distribution of Difference in Mean Base Pay") +
  theme_bw()

# define a function to calculate the difference in mean base pay
diff_mean_base_pay <- function(df) {
  mean(df$BasePay[df$Gender == "Male"]) - mean(df$BasePay[df$Gender == "Female"])
}

# calculate the observed difference in mean base pay
observed_diff <- diff_mean_base_pay(data)

# generate 10,000 random permutations of the gender variable
set.seed(123)
perm_diffs <- replicate(10000, {
  perm_data <- data %>%
    mutate(Gender = sample(Gender))
  diff_mean_base_pay(perm_data)
})

# calculate the p-value
p_value <- mean(abs(perm_diffs) >= abs(observed_diff))
print(p_value)

# plot the randomization distribution
ggplot() +
  geom_histogram(aes(x = perm_diffs), bins = 30, fill = "lightblue", color = "black") +
  geom_vline(xintercept = observed_diff, color = "red", linetype = "dashed") +
  labs(x = "Difference in Mean Base Pay", y = "Frequency") +
  ggtitle("Randomization Distribution") +
  theme_bw()
