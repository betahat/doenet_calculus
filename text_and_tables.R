did_list <- list("Discrete dynamical system introductory" = "_ToZ1Ot0vL3eRyuai4Bkkd",
                 "Discrete SIR" = "_y0BphcxIBc8bGvu6h530S",
                 "Solving linear discrete dynamical systems" = "_jQ9rqGZT5BCigajT4edf2",
                 "Doubling time and half life" = "_TmezKxEvQC54q0FY76wNA",
                 "Discrete equilibria" = "_9i0F7Lxhu7a569jxjXh1T",
                 "Graphing discrete equilibria" = "_cbG4Ps1Drj1F7QwOKg57t",
                 "Cobwebbing graphical solution" = "_YE8fkD06KCc4KBCpODuey",
                 "Cobwebbing graphical solution v2" = "_QaPAiFHhef31GEgnlGhB8",
                 "Discrete equilibria stability idea" = "_aaOe40kiyAVFVoM4HoVlr",
                 "Approximating nonlinear" = "_NsIAZGIds2KUoNftTGMAb",
                 "Derivative intuition" = "_TETkqoYS3slQaDwjqkMrX",
                 "Derivative from limit" = "_Lbt421RDxuB910MHskhjX",
                 "Derivatives of polynomials" = "_vqoTnapQjv1DcEpEA5EeO",
                 "Derivatives of exponentials, logarithms, and products" = "_CCJZuqDxojyG9FduwOVjl",
                 "Quotient and chain rule" = "_bnpevFQrYseYIiIOLbe9b",
                 "Linear approximation" = "_JqQkfDHVOLbNLs16YN1dE",
                 "Stability from cobwebbing" = "_h8yHBRoSIjnUvMcrjd9n7",
                 "Stability of equiulibria" = "_7HRW969pdrvTOGMxdtERl",
                 "The derivative and graphing" = "_yLCe1tTBH4eUOBG6kvqXB",
                 "Maximization and minimization" = "_9J5GcZeqVJouJdzMQSutu",
                 "Introduction to pure-time DE" = "_2TjlDHaDTJKlrGdw0qE7d",
                 "Pure-time DE graphical solution" = "_xunHfweN1bCtk9eBf2Suv",
                 "Forward Euler pure-time DE" = "_J6f1XPRMDoEESXDqkUcjW",
                 "Pure-time DE integration" = "_JqsTFTUyBnvjh4rBA2waT",
                 "Riemann sums" = "_W5P1PaXTCNqtubBUQUIn5",
                 "The fundamental theorem of calculus" = "_qVImzX9jyVllguIxJshTN",
                 "Applications of integration" = "_TXwWfJrWQ9ESMUhqOfhDQ",
                 "Single linear equations" = "_2nhQDVYPoNNkEloePhyp1",
                 "Introduction to solving autonomous DEs graphically" = "_hm2WnqAwCWWFys3m837wW",
                 "Introduction to solving autonomous DEs graphically v2" = "_W62EZR77Ym08GjFsun1tS",
                 "Solving autonomous DEs graphically" = "_RWQClWRRSkxABJcUgiw41",
                 "Exponential growth and decay" = "_PQx6WFmgldi3l6n0YwCq3",
                 "Stability of equiulibria" = "_a9mN3glSuxaUBdCq4bQVF",
                 "Forward euler" = "_jPTAPBsb3Q216mdvaMlmc",
                 "Bifurcation diagram" = "_SNZTreWyuwnFdyhpHwkX3",
                 "Infection disease without immunity" = "_1FcREzqoaTeNW9AiIGPZ4"
)
dict <- data.frame(doenetName = names(did_list), doenetId = all_doenet_ids)

output$problem_spots <- 
  DT::renderDT(
    cleaned() %>% 
      filter(!is.na(itemCreditAchieved)) %>% 
      group_by(userId, doenetId, pageNumber, componentName) %>% 
      count() %>% 
      ungroup() %>% 
      arrange(desc(n)) %>% 
      group_by(doenetId, pageNumber, componentName) %>% 
      summarize(n = mean(n)) %>% 
      ungroup() %>% 
      group_by(doenetId, pageNumber) %>% 
      #slice_max(n, n = 1) %>% 
      arrange(desc(n)) %>% 
      left_join(dict) %>% 
      select(n, doenetName, pageNumber, componentName, doenetId)
  )



# =========================DATA TABLES===========================================
# creates tables of each of the data versions to view/troubleshoot in a tab
output$events_dt <-
  DT::renderDT(events())
output$cleaned_dt <-
  DT::renderDT(cleaned())
output$summary_data_dt <-
  DT::renderDT(summary_data())

# =======================SUMMARY TEXT============================================
# creates an output text detailing how many students in the data set
output$num_students <-
  renderText(paste0(
    "There is/are ",
    n_distinct(events()$userId, na.rm = TRUE),
    " student(s)"
  ))
# creates an output text detailing how many versions are present in the set
output$num_versions <-
  renderText(paste0("There are ", versions()))

# creates an output text detailing how many different doenet experiments
# are represented in this set.
output$num_doenetIds <-
  renderText(paste0(
    "There is/are ",
    n_distinct(events()$doenetId, na.rm = TRUE),
    " doenetId(s)"
  ))
# creates an output text detailing how many pages are included in this dataset
output$num_pages <-
  renderText(paste0(
    "There is/are ",
    n_distinct(summary_data()$pageNumber, na.rm = TRUE),
    " page(s)"
  ))


output$component_table <- renderDT({
  component_data() %>%
    filter(creditAchieved < input$include_right + 1) %>%
    filter(pageNumber == input$page_select) %>%
    filter(componentName == as.character(input$component_select)) %>%
    select(responseText, n, creditAchieved) %>% 
    mutate(responseText = str_replace_all(responseText, '\\"', '')) %>% 
    mutate(responseText = str_replace_all(responseText, 'c\\(', '\\(')) %>% 
    arrange(desc(n))
})

