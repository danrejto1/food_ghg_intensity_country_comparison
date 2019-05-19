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
library(readr)
library(dplyr)
library(ggplot2)

df <- read_csv( file = "emission_intensities.csv")
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
      pd <- filter(df, Area %in% input$countries,
                   Item == input$item)
      
      plot_ly(data = pd, x=~Area, y=~Value, type = "bar", color=I("#0D4459"))  %>% 
         layout(title = paste0("Comparison of Greenhouse Gas Emissions for \n", input$item),
                xaxis = list(
                   title = ""),
                yaxis = list(
                   title = "kg CO2eq/kg product"),
                annotations = 
                   list(x = -.05, y = 0, text = "@DanRejto \nData: FAOSTAT", 
                        showarrow = F, xref='paper', yref='paper', 
                        xanchor='right', yanchor='auto', xshift=0, yshift=0, textangle=-90,
                        font=list(size=8, color="black"))
                )
      
            # df %>% 
      #    filter(Area %in% input$countries,
      #           Item == input$item) %>%   
      #    ggplot() +
      #    geom_col(aes(x = Area, y=Value), fill = "#0D4459")+
      #    labs(x="", y="kg CO2eq/kg product",
      #         title = paste0("Comparison of Greenhouse Gas Emissions for ", input$item),
      #         caption = "Created by @DanRejto \nData: FAOSTAT")+
      #    theme_minimal() 

   })
}

# Run the application 
shinyApp(ui = ui, server = server)

