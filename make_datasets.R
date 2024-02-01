load(file = "events.rda")
load(file = "cleaned.rda")

events <- reactive({
  events_tmp
})
cleaned_all <- reactive({
  cleaned_all_tmp
})

# events <- events_tmp
# cleaned_all <- cleaned_all_tmp
# summary_data <- summarize_events(cleaned_all)

cleaned <- reactive({
  if (input$activity_select == "All") {
    cleaned_all()
  }
  else{
    #cleaned_all() %>% version_filter(input$activity_select)
    cleaned_all() %>% filter(doenetId == input$activity_select)
  }
})

summary_data <- reactive({
  summarize_events(cleaned())
})


# Input from date slider determines which dates are included in the set.
# cleaned_versions <- reactive({
#   #req(events())
#   withProgress(message = 'Analyzing Data', {
#     clean_events(events(), input$time_slider[1], input$time_slider[2])
#     #clean_events(events())
#   })
# })

# events <- reactive({
#   if (length(paste(query())) == 1) {
#     events_full()
#   }
#   else if (input$activity_select == "All") {
#     events_full()
#   }
# })

# These next two lines pull data directly from events (before it is cleaned)
# that is crucial to determining the date and version selection on the sidebar.
# As a rule we have typically tried to avoid working on events directly, but
# because this determines how we clean we have made an exception.
dates <- reactive(pull_dates(events()))
versions <- reactive(pull_versions(events()))


component_data <- reactive({
  cleaned() %>%
    filter(verb == "submitted" |
             verb == "answered" |
             verb == "selected") %>% # selected are choice inputs
    select(userId,
           response,
           responseText,
           item,
           componentName,
           pageNumber,
           creditAchieved) %>%
    filter(!is.na(componentName)) %>%
    filter(responseText != "NULL") %>%
    filter(responseText != "＿") %>%
    group_by(pageNumber, item, componentName, creditAchieved) %>%
    count(responseText) %>%
    filter(n != 1) %>%
    ungroup() %>%
    mutate(responseText = as.character(responseText))
})