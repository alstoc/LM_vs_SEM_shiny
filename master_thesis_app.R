#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# shiny specific
library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(dashboardthemes)
# ggplot
library(ggplot2)
library(ggthemes)
library(RColorBrewer)
# tidyverse
library(tidyverse)
# data table
library(DT)

# Import global variables and functions
source("./global.R")

# Define UI for application 
ui <- shinydashboardPlus::dashboardPage(
    
    # header ----
    dashboardHeader(title = "LM vs. SEM", 
                    titleWidth = 350),
    
    # sidebar ----
    dashboardSidebar(width = 350,
        sidebarMenu(
            menuItem("Intro", icon = icon("home"), startExpanded = TRUE,
                     menuSubItem("Einleitung", tabName = "intro", selected = TRUE),
                     menuSubItem("Theoretische Grundlagen", tabName = "intro_theory"),
                     menuSubItem("Messfehler bei Einfachregression", tabName = "intro_app_LM")),
            menuItem("Studie 1", icon = icon("dice-one"), 
                     menuSubItem("Design", tabName = "study_1_design"),
                     menuSubItem("Ergebnisse", tabName = "study_1_results")),
            menuItem("Studie 2", icon = icon("dice-two"), 
                     menuSubItem("Design", tabName = "study_2_design"),
                     menuSubItem("Ergebnisse", tabName = "study_2_results"))
        ),
        minified = FALSE, 
        collapsed = FALSE),
    
    # body ----
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
            
            # Study 1 design tab content
            tabItem(tabName = "study_1_design",
                    source("tabs/tab_study_1_design.R", 
                           local = TRUE, encoding = "utf-8")[1]
            ),
            
            # Study 1 results tab content
            tabItem(tabName = "study_1_results",
                    source("tabs/tab_study_1_results.R", 
                           local = TRUE, encoding = "utf-8")[1]
            ),
            
            # Study 2 design tab content
            tabItem(tabName = "study_2_design",
                    source("tabs/tab_study_2_design.R", 
                           local = TRUE, encoding = "utf-8")[1]
            ),
            
            # Study 2 results tab content
            tabItem(tabName = "study_2_results",
                    source("tabs/tab_study_2_results.R", 
                           local = TRUE, encoding = "utf-8")[1]
            )
        )
    )
    
) 

# Define server logic required to present output
server <- function(input, output, session) {
    
    # tab_intro_theory ----
    # Create PDF output
    output$theory_pdfview <- renderUI({
      tags$iframe(style="height:90vh; width:100%", 
                  scrolling = "no",
                  src="LM_und_SEM_theorie.pdf",
                  id = "pdf_iframe")
    })
  
  
    # tab_intro_app ----
  
    # Generate latent variables
    xi <- eventReactive(input$intro_settingsOK, {
        rnorm(input$intro_nobs, 100, 15)
    },
    ignoreNULL = FALSE)
    
    eta <- reactive({
        xi() + rnorm(input$intro_nobs, 0, 15)
    })
    
    # Error variances
    delta_var <- eventReactive(input$intro_settingsOK, {
        rel_err %>% 
            dplyr::filter(reliability == input$intro_rel_x) %>% 
            dplyr::select(error_var) %>% 
            as.numeric()
    },
    ignoreNULL = FALSE)
    
    epsilon_var <- eventReactive(input$intro_settingsOK, {
        rel_err %>% 
            dplyr::filter(reliability == input$intro_rel_y) %>% 
            dplyr::select(error_var) %>% 
            as.numeric()
    },
    ignoreNULL = FALSE)
    
    # Generate data for x and y
    df <- eventReactive(input$intro_settingsOK, {
        # Generate measurement errors and indicators
        x <- xi() + rnorm(input$intro_nobs, 0, sqrt(delta_var()))
        y <- eta() + rnorm(input$intro_nobs, 0, sqrt(epsilon_var()))
        # Return data frame
        return(data.frame(x= x, y = y))
    }, 
    ignoreNULL = FALSE)
    
    # Linear regression model
    lin_reg <- reactiveValues(res = NA, coefs = NA, CI = NA, true_coefs = NA)
    observeEvent(input$intro_settingsOK, {
        lin_reg$res <- lm(y ~ x, data = df())
        lin_reg$coefs <- lin_reg$res$coefficients
        lin_reg$true_coefs <- lm(eta() ~ xi()) %>% 
            coef()
        lin_reg$CI <- lin_reg$res %>%
            predict(interval = "confidence", level = 0.95)
    },
    ignoreNULL = FALSE)
    
    # Create output plot
    output$intro_plot <- renderPlot({
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
            xlim(input$intro_xlim) +
            ylim(input$intro_ylim) +
            labs(x = "Extraversion",
                 y = "Emotionale Intelligenz") +
            theme_minimal() +
            theme(plot.title = element_text(size = 18),
                  axis.title = element_text(size = 16, face = "bold"),
                  axis.text = element_text(size = 12),
                  aspect.ratio = 9/16)
    })
    
    # Create output text
    output$intro_summary <- renderPrint({
        summary(lin_reg$res)
    })
    
    # Create output table (DEACTIVATED)
    output$intro_table <- 
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
    
    # tab_study_1_design ----
    # Create PDF output
    output$study_1_pdfview <- renderUI({
      tags$iframe(style="height:90vh; width:100%", 
                  scrolling = "no",
                  src="studie_1_design.pdf",
                  id = "pdf_iframe")
    })
    
    # tab_study_1_results ----
    # Select data for user selected treatment only
    sim_res_selected <- eventReactive(input$study_1_settingsOK, {
        sim_res %>% 
            filter(rel_x == input$study_1_rel_x,
                   rel_y == input$study_1_rel_y,
                   nobs == input$study_1_nobs,
                   nind == input$study_1_nind)
    }, ignoreNULL = FALSE)
    
    # Plots
    output$study_1_plot_b1_est <- renderPlot({
        ggplot(sim_res_selected(), 
               aes(x = method, 
                   y = b1_est,
                   fill = method)) +
        geom_boxplot(outlier.colour = "grey69",
                     size = 0.7,
                     notch = TRUE) +
        stat_summary(aes(group = method),
                     fun = mean, 
                     geom = "point", 
                     size = 2, 
                     colour = "black",
                     alpha = 0.7,
                     position = position_dodge(width = 0.75),
                     shape = 4,
                     stroke = 2,
                     show.legend = FALSE) +
        geom_hline(yintercept = 1, linetype = "dashed", color = "black") +
        labs(x = "Methode", 
             y = expression(paste(hat(beta)[1])),
             fill = "Methode") +
        theme_fruits() +
        scale_fill_brewer(palette = "Dark2") +
        theme(legend.key.size = unit(1, "cm"),
              axis.text.x = element_text(size = 14),
              aspect.ratio = 9/16) +
        coord_cartesian(ylim = c(input$study_1_ylim[1], input$study_1_ylim[2]))
    }, bg="transparent")
    
    output$study_1_plot_b1_bias <- renderPlot({
      ggplot(sim_res_selected(), 
             aes(x = method, 
                 y = bias_b1,
                 fill = method)) +
        geom_boxplot(outlier.colour = "grey69",
                     size = 0.7,
                     notch = TRUE) +
        stat_summary(aes(group = method),
                     fun = mean, 
                     geom = "point", 
                     size = 2, 
                     colour = "black",
                     alpha = 0.7,
                     position = position_dodge(width = 0.75),
                     shape = 4,
                     stroke = 2,
                     show.legend = FALSE) +
        labs(x = "Methode", 
             y = expression(paste("Bias von ", hat(beta)[1])),
             fill = "Methode") +
        theme_fruits() +
        scale_fill_brewer(palette = "Dark2") +
        theme(legend.key.size = unit(1, "cm"),
              axis.text.x = element_text(size = 14),
              aspect.ratio = 9/16) +
        coord_cartesian(ylim = c(input$study_1_ylim[1], input$study_1_ylim[2]))
    }, bg="transparent")
    
    output$study_1_plot_se <- renderPlot({
      ggplot(sim_res_selected(), 
             aes(x = method, 
                 y = b1_SE,
                 fill = method)) +
        geom_boxplot(outlier.colour = "grey69",
                     size = 0.7,
                     notch = TRUE) +
        stat_summary(aes(group = method),
                     fun = mean, 
                     geom = "point", 
                     size = 2, 
                     colour = "black",
                     alpha = 0.7,
                     position = position_dodge(width = 0.75),
                     shape = 4,
                     stroke = 2,
                     show.legend = FALSE) +
        labs(x = "Methode", 
             y = expression(paste("SE(",hat(beta)[1], ")")),
             fill = "Methode") +
        theme_fruits() +
        scale_fill_brewer(palette = "Dark2") +
        theme(legend.key.size = unit(1, "cm"),
              axis.text.x = element_text(size = 14),
              aspect.ratio = 9/16) +
        coord_cartesian(ylim = c(input$study_1_ylim[1], input$study_1_ylim[2]))
    }, bg="transparent")
    
    # Table
    output$study_1_table <- renderTable({
        table_output <- data.frame(LM = rep(NA, 4), SEM = rep(NA, 4))
        rownames(table_output) <- c("Relatives Bias", 
                                    "Power", 
                                    "Power (Alternative Berechnung)",
                                    "Irrtumshäufigkeit 95%-KI")
        # Relative Bias
        table_output[1, 1] <- sim_res_selected() %>% 
            filter(method == "LM") %>% 
            select(se_acc_treatment) %>% 
            distinct() %>% 
            round(digits = 2)
        table_output[1, 2] <- sim_res_selected() %>% 
          filter(method == "SEM") %>% 
          select(se_acc_treatment) %>% 
          distinct() %>% 
          round(digits = 2)
        # Power
        table_output[2, 1] <- sim_res_selected() %>% 
          filter(method == "LM") %>% 
          select(power) %>% 
          distinct() %>% 
          round(digits = 2)
        table_output[2, 2] <- sim_res_selected() %>% 
          filter(method == "SEM") %>% 
          select(power) %>% 
          distinct() %>% 
          round(digits = 2)
        # Power (alternative calculation)
        table_output[3, 1] <- sim_res_selected() %>% 
          filter(method == "LM") %>% 
          select(power_alt) %>% 
          distinct() %>% 
          round(digits = 2)
        table_output[3, 2] <- sim_res_selected() %>% 
          filter(method == "SEM") %>% 
          select(power_alt) %>% 
          distinct() %>% 
          round(digits = 2)
        # 95% CI error rate
        table_output[4, 1] <- sim_res_selected() %>% 
          filter(method == "LM") %>% 
          select(oob_prcnt ) %>% 
          distinct() %>% 
          round(digits = 2) %>% 
          paste0(" %")
        table_output[4, 2] <- sim_res_selected() %>% 
          filter(method == "SEM") %>% 
          select(oob_prcnt ) %>% 
          distinct() %>% 
          round(digits = 2) %>% 
          paste0(" %")
        return(table_output)
    }, rownames = TRUE)
    
    # tab_study_2_design ----
    output$study_2_pdfview <- renderUI({
      tags$iframe(style="height:90vh; width:100%", 
                  scrolling = "no",
                  src="studie_2_design.pdf",
                  id = "pdf_iframe")
    })
    
    # tab_study_2_results ----
    # Select data for user selected treatment only
    sim_res_2_selected <- eventReactive(input$study_2_settingsOK, {
      sim_res_2 %>% 
        filter(lambda_x == input$study_2_lambda_x,
               lambda_y == input$study_2_lambda_y,
               dv == input$study_2_dv,
               ev == input$study_2_ev)
    }, ignoreNULL = FALSE)
    # Plots
    output$study_2_plot_b1_est <- renderPlot({
        ggplot(sim_res_2_selected(), 
               aes(x = method, 
                   y = b1_est,
                   fill = method)) +
            geom_boxplot(outlier.colour = "grey69",
                         size = 0.7,
                         notch = TRUE) +
            stat_summary(aes(group = method),
                         fun = mean, 
                         geom = "point", 
                         size = 2, 
                         colour = "black",
                         alpha = 0.7,
                         position = position_dodge(width = 0.75),
                         shape = 4,
                         stroke = 2,
                         show.legend = FALSE) +
            geom_hline(yintercept = 1, linetype = "dashed", color = "black") +
            labs(x = "Methode", 
                 y = expression(paste(hat(beta)[1])),
                 fill = "Methode") +
            theme_fruits() +
            scale_fill_brewer(palette = "Dark2") +
            theme(legend.key.size = unit(1, "cm"),
                  axis.text.x = element_text(size = 14),
                  aspect.ratio = 9/16) +
            coord_cartesian(ylim = c(input$study_2_ylim[1], input$study_2_ylim[2]))
    }, bg="transparent")
    
    output$study_2_plot_b1_bias <- renderPlot({
        ggplot(sim_res_2_selected(), 
               aes(x = method, 
                   y = bias_b1,
                   fill = method)) +
            geom_boxplot(outlier.colour = "grey69",
                         size = 0.7,
                         notch = TRUE) +
            stat_summary(aes(group = method),
                         fun = mean, 
                         geom = "point", 
                         size = 2, 
                         colour = "black",
                         alpha = 0.7,
                         position = position_dodge(width = 0.75),
                         shape = 4,
                         stroke = 2,
                         show.legend = FALSE) +
            labs(x = "Methode", 
                 y = expression(paste("Bias von ", hat(beta)[1])),
                 fill = "Methode") +
            theme_fruits() +
            scale_fill_brewer(palette = "Dark2") +
            theme(legend.key.size = unit(1, "cm"),
                  axis.text.x = element_text(size = 14),
                  aspect.ratio = 9/16) +
            coord_cartesian(ylim = c(input$study_2_ylim[1], input$study_2_ylim[2]))
    }, bg="transparent")
    
    output$study_2_plot_se <- renderPlot({
        ggplot(sim_res_2_selected(), 
               aes(x = method, 
                   y = b1_SE,
                   fill = method)) +
            geom_boxplot(outlier.colour = "grey69",
                         size = 0.7,
                         notch = TRUE) +
            stat_summary(aes(group = method),
                         fun = mean, 
                         geom = "point", 
                         size = 2, 
                         colour = "black",
                         alpha = 0.7,
                         position = position_dodge(width = 0.75),
                         shape = 4,
                         stroke = 2,
                         show.legend = FALSE) +
            labs(x = "Methode", 
                 y = expression(paste("SE(",hat(beta)[1], ")")),
                 fill = "Methode") +
            theme_fruits() +
            scale_fill_brewer(palette = "Dark2") +
            theme(legend.key.size = unit(1, "cm"),
                  axis.text.x = element_text(size = 14),
                  aspect.ratio = 9/16) +
            coord_cartesian(ylim = c(input$study_2_ylim[1], input$study_2_ylim[2]))
    }, bg="transparent")
    
    # Table
    output$study_2_table <- renderTable({
        table_output <- data.frame(LM = rep(NA, 3), SEM = rep(NA, 3))
        rownames(table_output) <- c("Relatives Bias", 
                                    "Power",
                                    "Irrtumshäufigkeit 95%-KI")
        # Relative Bias
        table_output[1, 1] <- sim_res_2_selected() %>% 
            filter(method == "LM") %>% 
            select(se_acc_treatment) %>% 
            distinct() %>% 
            round(digits = 2)
        table_output[1, 2] <- sim_res_2_selected() %>% 
            filter(method == "SEM") %>% 
            select(se_acc_treatment) %>% 
            distinct() %>% 
            round(digits = 2)
        # Power
        table_output[2, 1] <- sim_res_2_selected() %>% 
            filter(method == "LM") %>% 
            select(power) %>% 
            distinct() %>% 
            round(digits = 2)
        table_output[2, 2] <- sim_res_2_selected() %>% 
            filter(method == "SEM") %>% 
            select(power) %>% 
            distinct() %>% 
            round(digits = 2)
        # 95% CI error rate
        table_output[3, 1] <- sim_res_2_selected() %>% 
            filter(method == "LM") %>% 
            select(oob_prcnt ) %>% 
            distinct() %>% 
            round(digits = 2) %>% 
            paste0(" %")
        table_output[3, 2] <- sim_res_2_selected() %>% 
            filter(method == "SEM") %>% 
            select(oob_prcnt ) %>% 
            distinct() %>% 
            round(digits = 2) %>% 
            paste0(" %")
        return(table_output)
    }, rownames = TRUE)
    
}

# Run the application 
shinyApp(ui = ui, server = server)
