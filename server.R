library(dplyr)

### Here we are loading variables and datasets which will be visible across all sessions.
### The server needs to be rebooted to update those variables



function(input, output, session) {
  
  
  ### Age ~ Barrio
  ### Todo, add in external file
  output$barrio_age_per_year_barplot <- renderPlot({
    
    tmp <- df_bse_summary %>%
      filter(year==input$year) %>%
      mutate(barrio = factor(barrio, levels = barrio[order(mean)]))
      
    
    ggplot(tmp, aes(x=barrio, y=mean)) + 
      geom_bar(stat="identity", position="dodge") +
      coord_flip() +
      labs(x="", y="Edad media", title=paste("Año ", input$year, sep="")) +
      theme_linedraw()
    
  })

  
  output$barrio_age_evolution <- renderPlot({
    
    tmp <- df_bse_summary %>%
      filter(year==input$year) %>%
      mutate(barrio = factor(barrio, levels = barrio[order(mean)]))
    
    
    ggplot(df_bse_summary, aes(x=year, y=mean, group=barrio, colour=barrio)) + 
      geom_point() +
      geom_line() +
      labs(x="Año", y="Edad media")
    
  })  
  
  
  output$barrio_age_absolute_evolution <- renderPlot({
    
    tmp <- df_bse_summary %>%
      group_by(barrio) %>%
      summarise(change = max(mean[year==max(year)]) - max(mean[year==min(year)])) %>%
      ungroup() %>%
      mutate(barrio = factor(barrio, levels = barrio[order(change)]))
    
    
    ggplot(tmp, aes(x=barrio, y=change)) + 
      geom_bar(stat="identity", position="dodge") +
        coord_flip() +
      labs(x="", y="Edad media")
    
  }) 
  
  
  output$barrio_age_density <- renderPlot({
    
    ### TODO: By sex as in here: https://rpubs.com/walkerke/pyramids_ggplot2
    

    tmp <- df_bse_pyramid  %>%
      filter(year==input$year_detalle_barrio & barrio == input$barrio_detalle)
    
    ggplot(data=tmp) +
      geom_bar(aes(age_category,n,group=sex,fill=sex), stat = "identity",subset(tmp,tmp$sex=="M")) +
      geom_bar(aes(age_category,-n,group=sex,fill=sex), stat = "identity",subset(tmp,tmp$sex=="H")) +
      coord_flip() +
      labs(x="Edad", y="Numero de personas", title=paste(input$barrio_detalle, "\nAño ", input$year_detalle_barrio, sep=""), fill="Sexo") +
      theme_bw()
    
  })
  
  

}

