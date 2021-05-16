fluidPage(
    # Information on how to use the app
    fluidRow(
        shinydashboardPlus::box(id = "lm_tutorial", title = "Anleitung",
                                width = 10, collapsible = TRUE,
                                style = "padding-left:20px; padding-right:40px;",
                                includeHTML("www/text_lm_tutorial.html")
        )
    ),
    
    fluidRow(
        # menu with sliders for demo of measurement error with LM
        shinydashboardPlus::box(id = "lm_demo_menu", title = "Einstellungen für die Datengenerierung", 
            width = 4,
            
            helpText("Anmerkung: Je kleiner die Reliabilität,",
                     "desto grösser die Messfehler."),
            
            br(),
            
            shinyWidgets::sliderTextInput("intro_rel_x",
                                          "Reliabilität der UV: ",
                                          choices = rel_err$reliability,
                                          selected = 1.0,
                                          grid = TRUE,
                                          hide_min_max = TRUE),

            
            shinyWidgets::sliderTextInput("intro_rel_y",
                                          "Reliabilität der AV: ",
                                          choices = rel_err$reliability,
                                          selected = 1.0,
                                          grid = TRUE,
                                          hide_min_max = TRUE),
            

            
            shinyWidgets::sliderTextInput("intro_nobs",
                                          "Stichprobengrösse: ",
                                          choices = c(50, 100, 250, 500, 1000),
                                          selected = 250,
                                          grid = TRUE,
                                          hide_min_max = TRUE),

            br(),
            
            actionButton("intro_settingsOK", "Daten generieren!", class = "btn-block"),
            
            br(),
            br()
        ),
        
        # plot of linear regression and data
        box(width = 6,
            title = "Output Regressionsmodell",
            tabsetPanel( 
                tabPanel("Plot", 
                         plotOutput("intro_plot")),
                tabPanel("Summary", verbatimTextOutput("intro_summary"))
                
            ),
            sidebar = boxSidebar(
                id = "intro_plot_sidebar",
                width = 66,
                style = 
                "padding-left:30px;
                padding-right:40px;",
                background = "#F8F8F8",
                br(),
                sliderInput("intro_xlim",
                            "Grenzen der x-Achse: ",
                            min = 0,
                            max = 200,
                            value = c(50, 150),
                            step = 5),
                
                br(),
                
                sliderInput("intro_ylim",
                            "Grenzen der y-Achse: ",
                            min = 0,
                            max = 200,
                            value = c(50, 150),
                            step = 5))
        )

    )
)

