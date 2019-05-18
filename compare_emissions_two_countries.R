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

#set paramaters for comparison
c1 <- "Japan"   #coutnry 1
c2 <- "United States of America"  #country 2
y <- 2016  #year
i <- "Cereals excluding rice" #item
e <- "Emissions intensity" #element

#filter to parameters selected
comp <- df %>% 
  filter(Area %in% c(c1, c2), 
         Year == y,
         Item == i,
         Element == e) %>% 
  select(Area, Item, Element, Year, Unit, Value)

#graph comparison
ggplot(comp)+
  geom_col(aes(x = Area, y=Value), fill = "#0D4459")+
  labs(x="", y="kg CO2eq/kg product",
       title = paste0("Comparison of Greenhouse Gas Emissions for ", i))+
  theme_minimal()
