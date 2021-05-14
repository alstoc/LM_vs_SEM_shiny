fluidPage(
    # Information on how to use the app
    fluidRow(
        shinydashboardPlus::box(id = "lm_tutorial", title = "Anleitung",
                                width = 9, collapsible = TRUE,
                                style = "padding-left:20px; padding-right:40px;",
                                includeHTML("content/text_lm_tutorial.html")
        )
    ),
    
    fluidRow(
        # menu with sliders for demo of measurement error with LM
        shinydashboardPlus::box(id = "lm_demo_menu", title = "Einstellungen für die Datengenerierung", 
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
        box(width = 5,
            title = "Output Regressionsmodell",
            tabsetPanel( 
                tabPanel("Plot", 
                         plotOutput("lmPlot")),
                tabPanel("Summary", verbatimTextOutput("summary"))
                
            ),
            sidebar = boxSidebar(
                id = "lmPlot_sidebar",
                width = 66,
                style = 
                "padding-left:30px;
                padding-right:40px;",
                background = "#F8F8F8",
                br(),
                sliderInput("xlim",
                            "Grenzen der x-Achse: ",
                            min = 0,
                            max = 200,
                            value = c(50, 150),
                            step = 5),
                
                br(),
                
                sliderInput("ylim",
                            "Grenzen der y-Achse: ",
                            min = 0,
                            max = 200,
                            value = c(50, 150),
                            step = 5))
        )

    )
)

