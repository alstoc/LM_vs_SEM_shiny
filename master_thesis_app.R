#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
if(!require(pacman))install.packages("pacman")

pacman::p_load(
    shiny,
    shinyWidgets,
    shinydashboard,
    shinydashboardPlus,
    dashboardthemes,
    ggplot2,
    tidyverse,
    DT,
    icon,
    knitr
)

# Import global variables and functions
source("./global.R")


# Define UI for application ----
ui <- shinydashboardPlus::dashboardPage(
    
    # header
    dashboardHeader(title = "LM vs. SEM", 
                    titleWidth = 350),
    
    # sidebar
    dashboardSidebar(width = 350,
        # Remove the sidebar toggle element
        tags$script(JS(
            "document.getElementsByClassName('sidebar-toggle')[0].style.visibility = 'hidden';"
            )),  
        sidebarMenu(
            menuItem("Intro", icon = icon("home"), startExpanded = TRUE,
                     menuSubItem("Einleitung", tabName = "intro", selected = TRUE),
                     menuSubItem("Theoretische Grundlagen", tabName = "intro_theory"),
                     menuSubItem("Messfehler bei Einfachregression", tabName = "intro_app_LM")),
            menuItem("Studie 1", tabName = "study_1", 
                     icon = icon("th"), selected = FALSE)
        ),
        minified = TRUE, 
        collapsed = FALSE),
    
    # body
    dashboardBody(
        
        # set theme
        shinyDashboardThemes("grey_light"),
        
        tabItems(
            # Intro tab content
            tabItem(tabName = "intro",
                    source("tabs/tab_intro.R", 
                           local = TRUE, encoding = "utf-8")[1]
            ),
            
            # Theory tab content
            tabItem(tabName = "intro_theory",
                    source("tabs/tab_intro_theory.R", 
                           local = TRUE, encoding = "utf-8")[1]
            ),
            
            # Intro LM tab content
            tabItem(tabName = "intro_app_LM",
                    source("tabs/tab_intro_app_LM.R", 
                           local = TRUE, encoding = "utf-8")[1]
            ),
            
            
            # Study 1 tab content
            tabItem(tabName = "study_1",
                    source("tabs/tab_study_1.R", 
                           local = TRUE, encoding = "utf-8")[1]
            )
        )
    )
    
) 

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # Generate latent variables
    xi <- eventReactive(input$settingsOK, {
        rnorm(input$nobs, 100, 15)
    },
    ignoreNULL = FALSE)
    
    eta <- reactive({
        xi() + rnorm(input$nobs, 0, 15)
    })
    
    # Error variances
    delta_var <- eventReactive(input$settingsOK, {
        rel_err %>% 
            dplyr::filter(reliability == input$rel_x) %>% 
            dplyr::select(error_var) %>% 
            as.numeric()
    },
    ignoreNULL = FALSE)
    
    epsilon_var <- eventReactive(input$settingsOK, {
        rel_err %>% 
            dplyr::filter(reliability == input$rel_y) %>% 
            dplyr::select(error_var) %>% 
            as.numeric()
    },
    ignoreNULL = FALSE)
    
    # Generate data for x and y
    df <- eventReactive(input$settingsOK, {
        # Generate measurement errors and indicators
        x <- xi() + rnorm(input$nobs, 0, sqrt(delta_var()))
        y <- eta() + rnorm(input$nobs, 0, sqrt(epsilon_var()))
        # Return data frame
        return(data.frame(x= x, y = y))
    }, 
    ignoreNULL = FALSE)
    
    # Linear regression model
    lin_reg <- reactiveValues(res = NA, coefs = NA, CI = NA, true_coefs = NA)
    observeEvent(input$settingsOK, {
        lin_reg$res <- lm(y ~ x, data = df())
        lin_reg$coefs <- lin_reg$res$coefficients
        lin_reg$true_coefs <- lm(eta() ~ xi()) %>% 
            coef()
        lin_reg$CI <- lin_reg$res %>%
            predict(interval = "confidence", level = 0.95)
    },
    ignoreNULL = FALSE)
    
    # Create output plot
    output$lmPlot <- renderPlot({
        # Plot data and regression line
        ggplot(df(), aes(x, y)) +
            geom_point(size = 2) +
            geom_abline(intercept = lin_reg$true_coefs[1], 
                        slope = lin_reg$true_coefs[2],
                        colour = "grey",
                        size = 1,
                        alpha = 0.8,
                        linetype = "dashed") +
            geom_abline(intercept = lin_reg$coefs[1], 
                        slope = lin_reg$coefs[2],
                        colour = "red",
                        size = 1) +
            geom_ribbon(aes(ymin = lin_reg$CI[, "lwr"],
                            ymax = lin_reg$CI[, "upr"]),
                        alpha = 0.3) +
            xlim(input$xlim) +
            ylim(input$ylim) +
            labs(x = "Extraversion",
                 y = "Emotionale Intelligenz") +
            theme_minimal() +
            theme(plot.title = element_text(size = 18),
                  axis.title = element_text(size = 16),
                  axis.text = element_text(size = 12))
    })
    
    # Create output text
    output$summary <- renderPrint({
        summary(lin_reg$res)
    })
    
    # Create output table
    output$table <- 
        DT::renderDataTable(df(),
                            options = 
                                list(pageLength = 10,
                                     dom = "tpl",
                                     columnDefs = list(list(
                                         className = 'dt-center',
                                         targets = "_all"))
                                     ),
                            rownames = FALSE,
                            selection = "none")
}

# Run the application 
shinyApp(ui = ui, server = server)
