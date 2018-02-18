

library(markdown)
library(ggplot2)

navbarPage("Open Data Pamplona",
           navbarMenu("Edad",
             tabPanel("Edad media",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("year", label = h3("Select year"), 
                                      choices = years, 
                                      selected = max(years))
                        ),
                        mainPanel(
                          plotOutput("barrio_age_per_year_barplot")
                        )
                      )
             ),
             
             
             tabPanel("Evolucion",
                      
                        mainPanel(
                          plotOutput("barrio_age_evolution")
                        ),
                      
                      mainPanel(
                        plotOutput("barrio_age_absolute_evolution")
                      )
                      
             ),
             
             
             tabPanel("Detalle barrio",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("barrio_detalle", label = h3("Select barrio"),
                                      choices = barrios,
                                      selected = barrios[1]),
                          
                          hr(),
                          
                          selectInput("year_detalle_barrio", label = h3("Select year"), 
                                      choices = years, 
                                      selected = max(years))
                         

                        ),
                        mainPanel(
                          plotOutput("barrio_age_density")
                        )
                      )
             )
           )


)

