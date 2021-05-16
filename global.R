load("./data/sim_res_study_1.Rda")
load("./data/sim_res_study_2.Rda")


# Create table containing error variance and corresponding reliability
rel_err  <- tibble(reliability = c(0.5, 0.7, 0.8, 0.9, 0.95, 1.0),
                   #error_var = c(1, 0.428571, 0.25, 0.111111, 0.052632),
                   error_var = c(225, 96.428571, 56.25, 25, 11.842105, 0))

# Create custom ggplot theme
theme_fruits <- function() {
    font <- "sans"   #assign font family up front
    
    theme_fivethirtyeight() +    #replace elements we want to change
    
    theme(
      
        # panel elements
        rect = element_rect(fill = "#F8F8F8"),
        panel.background = element_rect(fill = "#F8F8F8"),
        
        # plot elements
        plot.title = element_text(
            family = font,
            size = 30,
            face = "bold"),
        plot.subtitle = element_text(
            family = font,
            size = 20),
        plot.caption = element_text(
            family = font,
            size = 12),
        
        
        # axis elements
        axis.title = element_text(
            family = font,
            size=20,
            face = "bold"),
        axis.text.x = element_text(
            family = font,
            size = 12),
        axis.text.y = element_text(
            family = font,
            size = 12),
        
        # legend elements
        legend.title = element_text(
            family = font,
            size = 20,
            face = "bold"),
        legend.text = element_text(
            family = font,
            size = 18),
        legend.position = "right",
        legend.direction = "vertical",
        
        # other elements
        aspect.ratio = 1,
    )
}