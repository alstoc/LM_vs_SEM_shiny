load("./data/sim_res_study_1.Rda")

# Create table containing error variance and corresponding reliability
rel_err  <- tibble(reliability = c(0.5, 0.7, 0.8, 0.9, 0.95, 1.0),
                   #error_var = c(1, 0.428571, 0.25, 0.111111, 0.052632),
                   error_var = c(225, 96.428571, 56.25, 25, 11.842105, 0))