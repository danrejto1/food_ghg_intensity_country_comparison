#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(dplyr)
library(ggplot2)

df <- read.csv( file = "emission_intensities.csv")
items <- unique(df$Item)
countries <- unique(df$Area)

# Define UI for application that draws bar plot
ui <- fluidPage(
   
   # Application title
   titlePanel("Comparison of Greenhouse Gas Intensity of Foods"),
   
   # Sidebar
      sidebarPanel(
        selectInput(inputId = "countries", 
                    label = "Select Countries",
                    choices = c(countries), 
                    selected = c("United States of America","China"),
                    multiple = TRUE),
        selectInput(inputId = "item", 
                    label = "Select Food",
                    choices = c(items), 
                    selected = "Meat, cattle",
                    multiple = FALSE) #only allow 1 item
        ),
   
   #Main panel with bar plot
   mainPanel(plotlyOutput(outputId = "plot")
             )
   )


# Define server logic required to draw plot
server <- function(input, output) {

  
   output$plot <- renderPlotly({
      df %>% 
         filter(Area %in% input$countries,
                Item == input$item) %>%   
         ggplot() +
         geom_col(aes(x = Area, y=Value), fill = "#0D4459")+
         labs(x="", y="kg CO2eq/kg product",
              title = paste0("Comparison of Greenhouse Gas Emissions for ", input$item))+
         theme_minimal() 

   })
}

# Run the application 
shinyApp(ui = ui, server = server)

