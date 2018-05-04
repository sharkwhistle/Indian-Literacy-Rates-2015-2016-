# Secondary Education in India by State 2015-2016

dataset <- read.csv('2015_16_Statewise_Secondary.csv', stringsAsFactors = FALSE)
summary(dataset)

# Fixing mislabelled state data for "MADHYA PRADESH"
dataset$statname[23] <- 'Madhya Pradesh'

# Create new dataframe excluding Telangana due to NA values
dataset <- dataset[-nrow(dataset),]

# Trim trailing whitespace from "statname" column for mapping purposes
trim.trailing <- function (x) sub("\\s+$", "", x)
dataset$statname <- trim.trailing(dataset$statname)
str(dataset)
tail(dataset)
# Subset of data frame including the discrepancy between Male and Female Literacy rates
# as well as urban population by State (For purposes of Regression Modeling)
lit_rate <- dataset[,c(3,5:6,11:13)]
lit_rate$lit_disc <- lit_rate$male_literacy_rate - lit_rate$female_literacy_rate
head(lit_rate)

library(ggplot2)
# Literacy Rates compared by state
a <- ggplot(lit_rate, aes(x = reorder(statname, literacy_rate), y = literacy_rate)) +
  geom_bar(stat = 'identity', fill = 'steelblue')

a + coord_flip() +
  geom_text(aes(label = literacy_rate), hjust = 1.2, size = 3.5) +
  theme_minimal() +
  ggtitle('Overall Literacy Rate by State') +
  xlab('States') +
  ylab('Literacy Rate %')

# Female vs Male Literacy Rate by State
b <- ggplot(lit_rate, aes(x = reorder(statname, male_literacy_rate))) +
  geom_bar(aes(y = male_literacy_rate), stat = 'identity', position = 'identity', 
           alpha = 0.3, fill = 'lightblue', colour = 'lightblue4') +
  geom_bar(aes(y = female_literacy_rate), stat = 'identity', position = 'identity', 
           alpha = 0.8, fill = 'pink', colour = 'red')

b + coord_flip() +
  geom_text(aes(label = female_literacy_rate, y = female_literacy_rate), hjust = 1.5, size = 3.5) +
  theme_minimal() +
  geom_text(aes(label = male_literacy_rate, y = male_literacy_rate), hjust = 1.2, size = 3.5) +
  theme_minimal() +
  ggtitle('Female vs Male Literacy Rate by State') +
  xlab('States') +
  ylab('Literacy Rate %')

# Discrepancy Between Male and Female Literacy Rate by State
c <- ggplot(lit_rate, aes(x = reorder(statname, lit_disc))) +
  geom_bar(aes(y = lit_disc), stat = 'identity', position = 'identity',
           fill = 'steelblue')
c +
  coord_flip() +
  geom_text(aes(label = lit_disc, y = lit_disc), hjust = 1, size = 3.5) +
  theme_minimal() +
  ggtitle('Discrepancy Between Male and Female Literacy Rate') +
  xlab('States') +
  ylab('Discrepancy %')

# Install packages for spatial data mapping
library(sp)
library(RColorBrewer)
library(rgeos)
library(maptools)
library(gpclib)
library(dplyr)
library(plyr)

# Importing map of India for data mapping
india <- readRDS('IND_adm1.rds')
india <- fortify(india, region = "NAME_1")

# Male Literacy Rate by State/Region 
ggplot() + geom_map(data = lit_rate, aes(map_id = statname, fill = male_literacy_rate), 
                    map = india) + expand_limits(x = india$long, y = india$lat) +
  ggtitle("Male Literacy Rate by State (2015-2016)") +
  labs(fill = "Literacy Rate %")
  
# Female Literacy Rate by State/Region 
ggplot() + geom_map(data = lit_rate, aes(map_id = statname, fill = female_literacy_rate), 
                    map = india) + expand_limits(x = india$long, y = india$lat) +
  ggtitle("Female Literacy Rate by State (2015-2016)") +
  labs(fill = "Literacy Rate %")

# Discrepancy Between Male and Female Literacy Rate by State/Region
ggplot() + geom_map(data = lit_rate, aes(map_id = statname, fill = lit_disc), 
                    map = india) + expand_limits(x = india$long, y = india$lat) +
  ggtitle("Discrepancy Between Male and Female Literacy Rate by State (2015-2016)") +
  labs(fill = "Discrepancy %")

# Urpan Population by State/Region
ggplot() + geom_map(data = lit_rate, aes(map_id = statname, fill = urban_population), 
                    map = india) + expand_limits(x = india$long, y = india$lat) +
  ggtitle("Urban Population by State (2015-2016)") +
  labs(fill = "Urban Population")

# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(lit_rate$literacy_rate, SplitRatio = 2/3)
training_set = subset(lit_rate - statname, split == TRUE)
test_set = subset(lit_rate - statname, split == FALSE)

# Feature Scaling
training_set$statname <- NULL # Removing 'statname' column for purposes of feature scaling
test_set$statname <- NULL # Removing 'statname' column for purposes of feature scaling
training_set = scale(training_set)
test_set = scale(test_set)

training_set <- as.data.frame(training_set)
test_set <- as.data.frame(test_set)

# Fitting Regression Model for Literacy Rate
regressor = lm(formula = literacy_rate ~ urban_population,
               data = lit_rate)
summary(regressor)

# Visualizing Linear Regression (Urban Population/Literacy Rate)
ggplot() +
  geom_point(aes(x = lit_rate$urban_population, y = lit_rate$literacy_rate),
             colour = 'red') +
  geom_line(aes(x = lit_rate$urban_population, y = predict(regressor, newdata = lit_rate)),
            colour = 'blue') +
  ggtitle('Literacy Rate vs Urban Population (Regression Model)') +
  xlab('Urban Population %') +
  ylab('Literacy Rate')

# From the above model it is difficult to assess if overall Literacy Rates has any real 
# correlation with urban population, as urban population varies greatly from state to state.
# It is therfor necessary to conduct a more in depth analysis on s State Level to 
# determine if Urban Population can be seen as a determining factor in recorded
# Literacy Rates.

