#### Name: Prep Data for shiny app
#### Author: Dan Rejto
#### Date: 5/18/19

library(dplyr)
library(readr)
library(ggplot2)

#download most recent emissions intensity database - no functioning API as of writing code
download.file(destfile = "data.zip", url = 'http://fenixservices.fao.org/faostat/static/bulkdownloads/Environment_Emissions_intensities_E_All_Data_(Normalized).zip')
unzip(zipfile = "data.zip")

#unzips to Environment_Emissions_intensities_E_All_Data_(Normalized).csv
df <- read_csv(file = "Environment_Emissions_intensities_E_All_Data_(Normalized).csv")

#explore data
str(df)
max(df$Year)

items <- unique(df$Item)
countries <- unique(df$Area)
utf8::utf8_valid(countries) #shows that 2 countries are not in UTF-8 encoding

#set paramaters for filtering entire dataset
e <- "Emissions intensity" #element
y <- max(df$Year) #year
countries <- countries[utf8::utf8_valid(countries)==T] #only utf-8 valid countries
 
#filter data for use in shiny app
df <- df %>% 
  filter(Year == y,
         Element == e,
         Area %in% countries)

#save filtered data
write_csv(x = df, path = "ghg_intensity_comparison/emission_intensities.csv")

#set parameters for example comparison
c1 <- "Japan"   #coutnry 1
c2 <- "United States of America"  #country 2
i <- "Cereals excluding rice" #item

# example comparison filter to parameters selected
comp <- df %>% 
  filter(Area %in% c(c1, c2), 
         Year == y,
         Item == i,
         Element == e) %>% 
  select(Area, Item, Element, Year, Unit, Value)

#example graph comparison
ggplot(comp)+
  geom_col(aes(x = Area, y=Value), fill = "#0D4459")+
  labs(x="", y="kg CO2eq/kg product",
       title = paste0("Comparison of Greenhouse Gas Emissions for ", i))+
  theme_minimal()