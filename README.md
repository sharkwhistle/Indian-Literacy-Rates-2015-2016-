# Indian-Literacy-Rates-2015-2016-
This analysis was carried out to determine if there was a noticeable correlation between literacy rates (overall, as well as Male and Female literacy) on the State level in India. The data used was a 2015-2016 Statewise Secondary Education Assessment from the Indian Ministry of Human Resource Development (DISE). 
There are myriad variables represented within the data set, but this analysis only focuses more specifically on Urban Population. I ran a linear regression model on the data, and after determining that there was no real linear relationship between the independent variables (male literacy rate, female literacy rate, discrepancy between male and female literacy rates, and sex ratio), I decided to fit a support vector regression model on the training data. While this did reveal some correlation between Urban Population and overall literacy rates, it did not ncessarily point to Urban Population being a real determining factor in overall literacy rates.
To get a clearer picture this analysis would have to be carried out on a district level by individual states. The data set also does not account for literacy initiatives and outside factors which might affect literacy rate results. Two such examples would be the effect of standardization of the Malayalam alphabet in Kerala (Kerala currently has the highest literacy rate in India), and the success of recent literacy initiatives carried out in Tripura state, neither of which are accounted for in the data.

# Requirements #

*(For plotting)*
* ggplot2

*(For geomapping state data)*
* sp
* RColorBrewer
* rgeos
* maptools
* gpclib
* dplyr
* plyr

*(For splitting test/training data)*
* caTools

*(For SVR model)*
* e1071

