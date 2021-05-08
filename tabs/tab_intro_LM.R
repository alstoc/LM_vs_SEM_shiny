fluidPage(
    fluidRow(
        # menu with sliders for demo of measurement error with LM
        box(id = "lm_demo_menu", title = "Parameter für die Datengenerierung", 
            status = "primary", width = 4,
            
            br(),
            br(),
            
            shinyWidgets::sliderTextInput("rel_x",
                                          "Reliabilität der UV: ",
                                          choices = rel_err$reliability,
                                          selected = 1.0,
                                          grid = TRUE,
                                          hide_min_max = TRUE),
            
            br(),
            
            shinyWidgets::sliderTextInput("rel_y",
                                          "Reliabilität der AV: ",
                                          choices = rel_err$reliability,
                                          selected = 1.0,
                                          grid = TRUE,
                                          hide_min_max = TRUE),
            
            br(),
            
            shinyWidgets::sliderTextInput("nobs",
                                          "Stichprobengrösse: ",
                                          choices = c(50, 100, 250, 500, 1000),
                                          selected = 250,
                                          grid = TRUE,
                                          hide_min_max = TRUE),
            
            br(),
            
            actionButton("settingsOK", "Daten generieren!", class = "btn-block"),
            
            br(),
            br()
        ),
        
        # plot of linear regression and data
        box(id = "lm_demo_output", title = "Output", width = 5,
            
            plotOutput("lmPlot"),
            
            br()
        ),
    ),
    
    fluidRow(
        
        # table with generated raw data
        box(title = "Daten", width = 4,
            
            DT::dataTableOutput("table")
        ),
        
        # Terminal with regression model
        box(title = "Regressionsmodell", width = 5,
            
            verbatimTextOutput("summary")
        )
    )
)


