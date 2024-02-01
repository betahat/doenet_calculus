# events <- reactive({
#   if (input$activity_select == "All") {
#     events_full()
#   }
#   else{
#     events_full() %>% filter(doenetId == input$activity_select)
#   }
# })

#output$act <- renderText(input$activity_select)

#events <- reactive({events_full()}
# if (input$activity_select == "All") {
#   if (input$version_select == "All") {
#     events_full()
#   }
#   else{
#     events_full() %>% filter(version == input$version_select)
#   }
# }
#   if (input$version_select == "All") {
#     events_full() %>% filter(doenetId == input$activity_select)
#   }
#   else{
#     events_full() %>% filter(version == input$version_select) %>% filter(doenetId == input$activity_select)
#   }
# }
#)