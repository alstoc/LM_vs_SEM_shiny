fluidPage(
    fluidRow(
        # menu with sliders for demo of measurement error with LM
        shinydashboardPlus::box(id = "intro_box_1",
            status = "primary", width = 8, collapsible = TRUE,
            includeMarkdown("content/text_intro_box_1.Rmd")
        )
        
    ),
    
    fluidRow(
        # menu with sliders for demo of measurement error with LM
        shinydashboardPlus::box(id = "intro_box_2",
            status = "primary", width = 8, collapsible = TRUE,
            includeMarkdown("content/text_intro_box_2.Rmd")
        )
        
    ),
    
)

