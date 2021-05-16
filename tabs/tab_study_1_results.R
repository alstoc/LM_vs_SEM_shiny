fluidPage(
  # Information on how to use the app
  fluidRow(
    shinydashboardPlus::box(id = "study_1_tutorial", title = "Information",
                            width = 10, collapsible = TRUE,
                            style = "padding-left:20px; padding-right:40px;",
                            includeHTML("www/text_study_1_tutorial.html")
    )
  ),
  
  fluidRow(
    # menu with sliders for demo of measurement error with LM
    shinydashboardPlus::box(id = "study_1_menu", title = "Versuchsbedingung", 
                            width = 4,
                            
                            br(),
                            br(),
                            
                            shinyWidgets::sliderTextInput("study_1_rel_x",
                                                          "Reliabilität der UV: ",
                                                          choices = rel_err$reliability,
                                                          selected = 0.95,
                                                          grid = TRUE,
                                                          hide_min_max = TRUE),
                            
                            br(),
                            
                            shinyWidgets::sliderTextInput("study_1_rel_y",
                                                          "Reliabilität der AV: ",
                                                          choices = rel_err$reliability,
                                                          selected = 0.95,
                                                          grid = TRUE,
                                                          hide_min_max = TRUE),
                            
                            br(),
                            
                            shinyWidgets::sliderTextInput("study_1_nobs",
                                                          "Stichprobengrösse: ",
                                                          choices = c(50, 100, 250, 500, 1000),
                                                          selected = 250,
                                                          grid = TRUE,
                                                          hide_min_max = TRUE),
                            
                            br(),
                            
                            radioButtons("study_1_nind",
                                         "Anzahl Indikatoren pro Faktor: ",
                                         choices = c(3, 5),
                                         selected = 3,
                                         inline = TRUE
                            ),
                            
                            br(),
                            
                            actionButton("study_1_settingsOK", "Übernehmen", class = "btn-block"),
                            
                            br(),
                            br()
    ),
    
    # plot of linear regression and data
    box(width = 6,
        title = "Ergebnisse",
        tabsetPanel( 
          tabPanel("Regressionskoeffizient", 
                   plotOutput("study_1_plot_b1_est")),
          tabPanel("Bias", 
                   plotOutput("study_1_plot_b1_bias")),
          tabPanel("Standardfehler", 
                   plotOutput("study_1_plot_se")),
          tabPanel("Weitere Kennzahlen", 
                   br(),
                   tableOutput("study_1_table"),
                   br())

        ),
        dropdownMenu = boxDropdown(
          style = "padding:20px;",
          numericRangeInput("study_1_ylim",
                           label = "Grenzen der y-Achse: ",
                           value = c(-0.05, 1.55),
                           separator = " bis ")
        )
    )
  )
)

