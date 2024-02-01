all_doenet_ids <- c(
  "_ToZ1Ot0vL3eRyuai4Bkkd",
  "_y0BphcxIBc8bGvu6h530S",
  "_jQ9rqGZT5BCigajT4edf2",
  "_TmezKxEvQC54q0FY76wNA",
  "_9i0F7Lxhu7a569jxjXh1T",
  "_cbG4Ps1Drj1F7QwOKg57t",
  "_YE8fkD06KCc4KBCpODuey",
  "_QaPAiFHhef31GEgnlGhB8",
  "_aaOe40kiyAVFVoM4HoVlr",
  "_NsIAZGIds2KUoNftTGMAb", # dig into by answer blank
  "_TETkqoYS3slQaDwjqkMrX",
  "_Lbt421RDxuB910MHskhjX",
  "_vqoTnapQjv1DcEpEA5EeO",
  "_CCJZuqDxojyG9FduwOVjl",
  "_bnpevFQrYseYIiIOLbe9b",
  "_JqQkfDHVOLbNLs16YN1dE", # dig into by answer blank
  "_h8yHBRoSIjnUvMcrjd9n7", # look this up for the 90% people are stopping
  "_7HRW969pdrvTOGMxdtERl",
  "_yLCe1tTBH4eUOBG6kvqXB",
  "_9J5GcZeqVJouJdzMQSutu",
  "_2TjlDHaDTJKlrGdw0qE7d",
  "_xunHfweN1bCtk9eBf2Suv",
  "_J6f1XPRMDoEESXDqkUcjW",
  "_JqsTFTUyBnvjh4rBA2waT",
  "_W5P1PaXTCNqtubBUQUIn5",
  "_qVImzX9jyVllguIxJshTN",
  "_TXwWfJrWQ9ESMUhqOfhDQ",
  "_2nhQDVYPoNNkEloePhyp1",
  "_hm2WnqAwCWWFys3m837wW",
  "_W62EZR77Ym08GjFsun1tS",
  "_RWQClWRRSkxABJcUgiw41",
  "_PQx6WFmgldi3l6n0YwCq3",
  "_a9mN3glSuxaUBdCq4bQVF",
  "_jPTAPBsb3Q216mdvaMlmc",
  "_SNZTreWyuwnFdyhpHwkX3",
  "_1FcREzqoaTeNW9AiIGPZ4")

query <- reactive({
  getQueryString()
})

#output$num_ids <- renderText(length(paste(query())))
output$num_ids <- renderText(length(all_doenet_ids))

num_versions <- 
  reactive({
    req(events())
    
    pull_versions(events())
    })

selected_activity <- reactive({renderText(as.character(input$activity_select))})

observe({
  updateSelectInput(
    session = session,
    inputId = "activity_select",
    choices = c(
      "All", 
      "Discrete dynamical system introductory" = "_ToZ1Ot0vL3eRyuai4Bkkd",
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
      ),
  )
})

observe({
  updateSelectInput(
    # req(
    #   isTruthy(num_versions())
    # ),
    session = session,
    inputId = "version_select",
    #choices = c("All", 1:num_versions()),
    choices = c("All")
  )
})

observe({
  updateSelectInput(
    session = session,
    inputId = "page_select",
    choices = c(1:num_pages())
  )
})

# observe({
#   updateSelectInput(
#     session = session,
#     inputId = "version_select",
#     choices = c(1:versions())
#     #choices = c("All", 1:versions()),
#   )
# })

# Slider for time in the time plots
# output$time_slider <-
#   renderUI({
#     sliderInput(
#       "maxtime",
#       min = 0,
#       "Maximum time shown:",
#       max = input$maxtime_set,
#       value =  c(500, 10000)
#     )
#   })

# Slider for date
# output$date_slider <-
#   renderUI({
#     sliderInput(
#       "date_range",
#       "Data from: ",
#       min = min(dates()),
#       max = max(dates()),
#       value = c(min(dates()),
#                 max(dates()))
#     )
#   })

# events <- reactive({
#   load_data(query())})

# output$show_pulldown <- reactive({
#   length(unlist(query())) > 1
# })

# outputOptions(output, "show_pulldown", suspendWhenHidden = FALSE)