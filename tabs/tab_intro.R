fluidPage(
    fluidRow(
        # menu with sliders for demo of measurement error with LM
        shinydashboardPlus::box(id = "intro_box_1", title = "Herzlich willkommen!",
                                style = "padding-left:20px; padding-right:40px;",
                                width = 10, collapsible = TRUE,
                                withMathJax(includeHTML("www/text_intro_box_1.html"))
        )
        
    ),
    
    fluidRow(
        # menu with sliders for demo of measurement error with LM
        shinydashboardPlus::box(id = "intro_box_2", title = "Inhalt der Shiny-App",
                                style = "padding-left:20px; padding-right:40px;",
                                width = 10, collapsible = TRUE,
                                withMathJax(includeHTML("www/text_intro_box_2.html"))
        )
        
    ),
    
)

