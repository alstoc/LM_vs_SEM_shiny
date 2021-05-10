fluidPage(
    # Information on how to use the app
    fluidRow(
        shinydashboardPlus::box(id = "lm_tutorial", title = "Anleitung",
                                width = 9, collapsible = TRUE,
                                includeMarkdown("content/text_lm_tutorial.Rmd")
        )
    ),
    
    fluidRow(
        # menu with sliders for demo of measurement error with LM
        box(id = "lm_demo_menu", title = "Einstellungen für die Datengenerierung", 
            width = 4,
            
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
        flipBox(id = "lm_demo_output",
                trigger = "click",
                width = 5,
                front = div(
                    style = "padding:10px",
                    h4("Datenpunkte und Regressionslinie"),
                    h5("Klicken für mehr Informationen"),
                    hr(),
                    plotOutput("lmPlot")),
                back = div(
                    style = "padding:10px",
                    h4("Regressionsmodell"),
                    h5("Klicken für Diagramm"),
                    hr(),
                    br(),
                    # Console with regression model
                    verbatimTextOutput("summary")
                )
        ),
    )
)


