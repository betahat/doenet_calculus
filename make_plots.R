# =============================GENERAL PLOTS=====================================
# This is a plot that shows time to credit for each problem

# This displays a histogram of overall scores on the activity
# bins = nrow(distinct())

output$hist_total <- renderPlot({
  summary_data() %>%
    group_by(userId, pageNumber) %>%
    summarize(total = max(pageCreditAchieved, na.rm = TRUE)) %>%
    ggplot(aes(x = total)) +
    geom_histogram() +
    labs(x = "Total Points", y = "Number of Students", title = "Total Scores on Assignment, By Page") +
  facet_wrap( ~ pageNumber)
})

output$time_plot_a <- renderPlot({
  cleaned() %>%
    filter(!is.na(itemCreditAchieved)) %>%
    ggplot(aes(y = itemCreditAchieved, x = time, color = userId)) +
    geom_step() +
    theme(legend.position = "none") +
    facet_wrap(~ pageNumber) +
    labs(x = "Time", y = "Total Credit on Page") +
    xlim(input$maxtime[1], input$maxtime[2])
})
# This is the time plot from the start (start point in time is always 0)
output$time_plot_s <- renderPlot({
  cleaned() %>%
    filter(!is.na(itemCreditAchieved)) %>%
    ggplot(aes(y = itemCreditAchieved, x = time, color = userId)) +
    geom_step() +
    theme(legend.position = "none") +
    facet_wrap(~ pageNumber) +
    labs(x = "Time", y = "Total Credit on Page") +
    xlim(0, input$maxtime[2])
})

# This displays a series of histograms for scores on each problem on each page
output$hist_prob <- renderPlot(
  summary_data() %>%
    filter(!is.na(itemCreditAchieved)) %>%
    group_by(userId, pageNumber, item) %>%
    slice_tail(n = 1) %>%
    ungroup() %>%
    ggplot(aes(x = itemCreditAchieved)) +
    geom_histogram() +
    facet_grid(pageNumber ~ item) +
    labs(x = "Score on Problem", y = "Count", title = "Breakdown by Problem")
)
# # This displays a histogram of overall scores on the activity
# # bins = nrow(distinct())
#output$hist_total <- renderPlot({
#   shiny::validate(
#     need(
#       summary_data(),
#       "Sorry, there is no data for your requested combination.
#                       Please change your input selections"
#     )
#   )
#   
  # summary_data() %>%
  #   group_by(userId, pageNumber) %>%
  #   summarize(total = max(pageCreditAchieved, na.rm = TRUE)) %>%
  #   ggplot(aes(x = total)) +
  #   geom_histogram() +
  #   labs(x = "Total Points", y = "Number of Students", title = "Total Scores on Assignment, By Page")
  #facet_wrap( ~ pageNumber)
#})

# ========================ATTEMPT BASED PLOTS====================================
# This displays a plot of average submissions per question
output$hist_submissions <- renderPlot({
  submitted_data <- cleaned() %>% filter(verb == "submitted")
  totals <-
    as.data.frame.table(table(submitted_data$componentName) / n_distinct(events()$userId, na.rm = TRUE))
  ggplot(totals, aes(x = Var1, y = Freq)) +
    geom_bar(stat = "identity") +
    scale_y_continuous(breaks = pretty_breaks()) +
    labs(x = "Question", y = "Submissions", title = "Average Number of Submissions per Question (All Attempts)") +
    coord_flip()
})

# This displays a plot of how the submissions are distributed across attempts
output$hist_subm_attempt <- renderPlot({
  submitted_data <- cleaned() %>% filter(verb == "submitted")
  if (input$MeanVar == "cm") {
    #cumulative submissions per question
    ggplot(submitted_data,
           aes(x = componentName, fill = attemptNumber)) +
      geom_bar(position = "dodge") +
      scale_y_continuous(breaks = pretty_breaks()) +
      labs(x = "Question", y = "Number of Submissions", title = "Number of Submissions Across Attempts") +
      guides(fill = guide_legend(title = "Attempt Number"))
  } else {
    #average submissions per question
    totals <-
      table(submitted_data$componentName,
            submitted_data$attemptNumber) %>% as.data.frame.table()
    colnames(totals) <- c("Question", "AttemptN", "Submissions")
    for (i in 1:max(submitted_data$attemptNumber)) {
      #divide cumulative submissions by the number of students submitting in each attempt number
      subData <- submitted_data %>% filter(attemptNumber == i)
      totals[totals$AttemptN == i, 3] <-
        totals[totals$AttemptN == i, 3] / n_distinct(subData$userId, na.rm = TRUE)
    }
    ggplot(totals, aes(x = Question, y = Submissions, fill = AttemptN)) +
      geom_bar(stat = "identity", position = "dodge") +
      scale_y_continuous(breaks = pretty_breaks()) +
      labs(x = "Question", y = "Submissions", title = "Average Number of Submissions Across Attempts") +
      guides(fill = guide_legend(title = "Attempt Number"))
  }
})

# This displays a plot of how the submissions are distributed across versions
output$hist_subm_version <- renderPlot({
  submitted_data <- cleaned() %>% filter(verb == "submitted")
  if (input$MeanVar == "cm") {
    #cumulative submissions
    ggplot(submitted_data, aes(x = componentName, fill = as.factor(version_num))) +
      geom_bar(position = "dodge") +
      scale_y_continuous(breaks = pretty_breaks()) +
      labs(x = "Question", y = "Number of Submissions", title = "Number of Submissions Across Versions") +
      guides(fill = guide_legend(title = "Version Number"))
  } else {
    #average submissions per version
    totals <-
      table(submitted_data$componentName,
            submitted_data$version_num) %>% as.data.frame.table()
    colnames(totals) <- c("Question", "VersionN", "Submissions")
    for (i in unique(submitted_data$version_num)) {
      subData <- submitted_data %>% filter(version_num == i)
      totals[totals$VersionN == i, 3] <-
        totals[totals$VersionN == i, 3] / n_distinct(subData$userId, na.rm = TRUE)
    }
    ggplot(totals, aes(x = Question, y = Submissions, fill = VersionN)) +
      geom_bar(stat = "identity", position = "dodge") +
      scale_y_continuous(breaks = pretty_breaks()) +
      labs(x = "Question", y = "Submissions", title = "Average Number of Submissions Across Versions") +
      guides(fill = guide_legend(title = "Version Number"))
  }
})

# ========================QUESTION SPECIFIC PLOTS====================================
# This displays a plot of the submission percentiles for a specific question
output$q_submissions <- renderPlot({
  q_data <-
    cleaned() %>% filter(verb == "submitted", componentName == input$subm_q)
  n_subm_by_id <- table(q_data$userId) %>% as.data.frame()
  ggplot(n_subm_by_id, aes(x = Freq)) +
    geom_bar(stat = "count") +
    scale_y_continuous(breaks = pretty_breaks()) +
    labs(x = "Number of Submissions", y = "Number of Students", title = "Distribution of Submissions")
})

# This displays a pie chart of how many students submitted, solved, and did not attempt a problem
output$q_pie <- renderPlot({
  q_data <-
    cleaned() %>% filter(verb == "submitted", componentName == input$subm_q)
  subm_by_id <-
    table(q_data$userId, q_data$creditAchieved) %>% as.data.frame()
  solv <-
    nrow(subm_by_id[subm_by_id$Var2 == 1 & subm_by_id$Freq > 0,])
  sub <- n_distinct(subm_by_id$Var1) - solv
  not_att <-
    n_distinct(events()$userId, na.rm = TRUE) - solv - sub
  results <-
    data.frame(
      Legend = c("solved", "unsolved", "not attempted"),
      num = c(solv, sub, not_att)
    )
  ggplot(results, aes(x = "", y = num, fill = Legend)) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar("y", start = 0) +
    labs(x = "", y = "", title = "Number of Students Solving This Question")
})

# This displays a dot plot of student scores vs number of submissions on a question
output$score_dot <- renderPlot({
  q_data <-
    cleaned() %>% filter(verb == "submitted", componentName == input$subm_q)
  subm_by_id <- table(q_data$userId) %>% as.data.frame()
  for (i in 1:nrow(subm_by_id)) {
    id <- subm_by_id[i, 1]
    max_score <-
      max((q_data[q_data$userId == id,])$creditAchieved)
    subm_by_id[i, 3] <- max_score
  }
  ggplot(subm_by_id, aes(x = as.factor(Freq), y = V3)) +
    geom_dotplot(binaxis = "y", stackdir = "center") +
    labs(x = "Number of Submissions", y = "Highest Score", title = "Number of Student Submissions vs Score")
})

# ====================COMPONENT PLOTS===================================

num_pages <- reactive({cleaned() %>% pull_pages()})

observe({
  updateSelectInput(
    session = session,
    inputId = "component_select",
    choices = component_data() %>% filter(pageNumber == input$page_select) %>% pull_components()
  )
})



output$component_plot <- renderPlot({
  component_data() %>%
    filter(creditAchieved < input$include_right + 1) %>%
    filter(pageNumber == input$page_select) %>%
    filter(componentName == as.character(input$component_select)) %>%
    slice_max(n, n = 10) %>%
    mutate(responseText = str_replace_all(responseText, '\\"', '')) %>% 
    mutate(responseText = str_replace_all(responseText, 'c\\(', '\\(')) %>% 
    ggplot(aes(
      x = fct_rev(fct_infreq(responseText, n)),
      y = n,
      fill = as.factor(creditAchieved)
    )) +
    geom_col() +
    labs(x = "Submission", y = "Frequency", fill = "Credit") +
    coord_flip() +
    scale_x_discrete(
      labels = function(x)
        str_wrap(x, width = 50)
    )
})

# summary_data() %>%
#   filter(!is.na(response)) %>%
#   group_by(item) %>%
#   ggplot(aes(
#     x = as.factor(response),
#     y = n,
#     fill = as.factor(response)
#   )) +
#   geom_col() +
#   facet_wrap( ~ item, scales = "free") +
#   labs(x = "Answer", y = "Frequency", fill = "Answer")

output$all_answers_text <- DT::renderDT({
  cleaned() %>%
    filter(verb == "submitted" | verb == "answered") %>%
    group_by(userId) %>%
    slice(n()) %>%
    ungroup() %>%
    select(response)
})



# ================VERSION COMPARISON PLOTS=====================
# This one just does a bar graph of average score for each question
output$problem_avgs_version <- renderPlot({
  summary_data() %>%
    group_by(userId, pageNumber, item) %>%
    filter(!is.na(itemCreditAchieved)) %>%
    slice_max(itemCreditAchieved, n = 1) %>%
    ungroup() %>%
    ggplot(aes(
      x = as.factor(item),
      y = avg,
      fill = as.factor(version_num)
    )) +
    geom_col(position = "dodge") +
    labs(
      x = "Problem",
      y = "Average score",
      title = "Average score by Problem by Version for Each Page",
      fill = "Version"
    ) +
    # guides(fill=guide_legend(title="Version")) +
    ylim(c(0, 1)) +
    #facet_wrap( ~ pageNumber, labeller=label_bquote(.(levels(as.factor(summary_data$pageNumber)))))
    facet_wrap(~ pageNumber, labeller = label_bquote(Page ~ .(pageNumber)))
})
# This is time plots faceted by version for person version of graph
output$time_plot_person_version <- renderPlot({
  cleaned() %>%
    filter(!is.na(pageCreditAchieved)) %>%
    ggplot(aes(y = pageCreditAchieved, x = time_person, color = userId)) +
    geom_step() +
    theme(legend.position = "none") +
    facet_grid(version_num ~ pageNumber) +
    labs(x = "Time since person loaded page", y = "Total Credit on Page") #+
    #xlim(input$maxtime[1], input$maxtime[2])
})
# Timeplot from start, again, faceted by version
output$time_plot_activity_version <- renderPlot({
  cleaned() %>%
    filter(!is.na(pageCreditAchieved)) %>%
    ggplot(aes(y = pageCreditAchieved, x = time_activity, color = userId)) +
    geom_step() +
    theme(legend.position = "none") +
    facet_grid(version_num ~ pageNumber) +
    labs(x = "Time since page was first loaded (by anyone)", y = "Total Credit on Page") #+
    #xlim(0, input$maxtime[2])
})
# histogram of total scores faceted by version
# bins = nrow(distinct(summary_data() , score))
output$hist_total_version <- renderPlot({
  summary_data() %>%
    group_by(userId, version_num, pageNumber) %>%
    summarize(total = max(pageCreditAchieved, na.rm = TRUE)) %>%
    ggplot(aes(x = total)) +
    geom_histogram() +
    labs(x = "Total Points", y = "Number of Students", title = "Total Scores on Assignment (Columns are version, rows are page number") +
    facet_grid(pageNumber ~ version_num)
})

#====================TIME TO QUESTION PLOTS===================
#Average time per question
output$time_to_question_av <- renderPlot({
  cleaned() %>%
    mutate(answer_num = coalesce(answerAncestor, componentName)) %>%
    group_by(userId) %>%
    mutate(time_dif = coalesce(as.numeric(c(NA, diff(
      time
    ))), as.numeric(time))) %>%
    group_by(userId, pageNumber, answer_num) %>%
    summarise(time = sum(time_dif)) %>%
    ungroup() %>%
    ggplot(aes(y = time, x = answer_num)) +
    geom_bar(stat = "summary", fun = "mean") +
    theme(legend.position = "none",
          axis.text.x = element_text(angle = 45, hjust = 1)) +
    facet_wrap(~ pageNumber) +
    labs(x = "Question", y = "Time", title = "Average Time per Question")
})
#Accumolative time per question by userId
output$time_to_question <- renderPlot({
  cleaned() %>%
    mutate(answer_num = coalesce(answerAncestor, componentName)) %>%
    group_by(userId) %>%
    mutate(time_dif = coalesce(as.numeric(c(NA, diff(
      time
    ))), as.numeric(time))) %>%
    group_by(userId, pageNumber, answer_num) %>%
    summarise(time = sum(time_dif)) %>%
    ungroup() %>%
    ggplot(aes(
      y = time,
      x = answer_num,
      group = userId,
      color = userId
    )) +
    geom_step() +
    theme(legend.position = "none",
          axis.text.x = element_text(angle = 45, hjust = 1)) +
    facet_wrap(~ pageNumber) +
    labs(x = "Question", y = "Time", title = "Time to Question")
})


# ================Attempts to 100=======================================

avgs <- reactive({summary_data() %>%
  group_by(item, pageNumber, userId) %>%
  filter(max(itemCreditAchieved) >= 0.9) %>%
  count() %>%
  ungroup() %>% 
  select(-userId) %>%
  group_by(item, pageNumber) %>%
  summarise(avg = mean(n))})

output$tries_to_100 <- renderPlot({
summary_data() %>%
  group_by(item, pageNumber, userId) %>%
  filter(max(itemCreditAchieved) >= 0.9) %>%
  count() %>%
  select(-userId) %>%
  ggplot(aes(x = n, group = interaction(pageNumber, item))) +
  geom_histogram() +
  facet_grid(pageNumber ~ item, labeller = label_both) +
  geom_vline(data = avgs(), aes(xintercept = avg), color = "red")}, height = 1200)


# ================RADAR GRAPH=======================================

output$radar_graph <- renderPlot({
  summary_data() %>%
    select(userId, item, pageNumber, itemCreditAchieved) %>%
    filter(!is.na(item)) %>%
    group_by(userId, pageNumber, item) %>%
    slice_max(itemCreditAchieved, n = 1) %>%
    distinct() %>%
    pivot_wider(names_from = c(item, pageNumber),
                values_from = itemCreditAchieved) %>%
    ggradar()
})