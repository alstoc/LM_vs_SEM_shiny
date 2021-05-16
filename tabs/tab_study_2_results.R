fluidPage(
  # Information on how to use the app
  fluidRow(
    shinydashboardPlus::box(id = "study_2_tutorial", title = "Information",
                            width = 10, collapsible = TRUE,
                            style = "padding-left:20px; padding-right:40px;",
                            withMathJax(includeHTML("www/text_study_2_tutorial.html"))
    )
  ),
  
  fluidRow(
    # menu with sliders for demo of measurement error with LM
    shinydashboardPlus::box(id = "study_2_menu", title = "Versuchsbedingung", 
                            width = 4,
                            
                            h4(HTML("Indikatoren von &xi;:")),
                            
                            br(),
                            
                            radioButtons("study_2_lambda_x",
                                         HTML("Spannweite Faktorladungen R(&lambda;<sub>x</sub>): "),
                                         choiceNames = c("klein", "gross"),
                                         choiceValues = c("small", "big"),
                                         selected = "small",
                                         inline = TRUE),
                            
                            br(),
                            
                            radioButtons("study_2_dv",
                                         HTML(
                                             "Spannweite Fehlervarianz 
                                             R(&sigma;<sup>2</sup><sub>&delta;</sub>): "
                                         ),
                                         choiceNames = c("klein", "gross"),
                                         choiceValues = c("small", "big"),
                                         selected = "small",
                                         inline = TRUE),
                            
                            br(),
                            
                            h4(HTML("Indikatoren von &eta;:")),
                            
                            br(),
                            
                            radioButtons("study_2_lambda_y",
                                         HTML("Spannweite Faktorladungen R(&lambda;<sub>y</sub>): "),
                                         choiceNames = c("klein", "gross"),
                                         choiceValues = c("small", "big"),
                                         selected = "small",
                                         inline = TRUE),
                            
                            br(),
                            
                            radioButtons("study_2_ev",
                                         HTML(
                                             "Spannweite Fehlervarianz 
                                             R(&sigma;<sup>2</sup><sub>&epsilon;</sub>): "
                                         ),
                                         choiceNames = c("klein", "gross"),
                                         choiceValues = c("small", "big"),
                                         selected = "small",
                                         inline = TRUE),
                            
                            br(),
                            
                            actionButton("study_2_settingsOK", "Übernehmen", class = "btn-block"),
                            
                            br(),
                            br()
    ),
    
    # plot of linear regression and data
    box(width = 6,
        title = "Ergebnisse",
        tabsetPanel( 
          tabPanel("Regressionskoeffizient", 
                   plotOutput("study_2_plot_b1_est")),
          tabPanel("Bias", 
                   plotOutput("study_2_plot_b1_bias")),
          tabPanel("Standardfehler", 
                   plotOutput("study_2_plot_se")),
          tabPanel("Weitere Kennzahlen", 
                   br(),
                   tableOutput("study_2_table"),
                   br())

        ),
        dropdownMenu = boxDropdown(
          style = "padding:20px;",
          numericRangeInput("study_2_ylim",
                           label = "Grenzen der y-Achse: ",
                           value = c(-0.05, 1.55),
                           separator = " bis ")
        )
    )
  )
)

