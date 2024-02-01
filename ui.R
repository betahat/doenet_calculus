# enableBookmarking(store = "url")

source("tabs.R")

shinyUI(fluidPage(
  titlePanel("Doenet Data Analyzer"),
  sidebarLayout(
    sidebarPanel(
      width = 3,
      actionButton("update", "Update Data", icon = icon("sync")), # probably not needed
      downloadButton("downloadData", "Download Data"), # maybe not needed?? or move to data tab?
      conditionalPanel(
        condition = "true",
        #condition = "true",
        selectInput("activity_select",
                  "Select an activity:",
                  choices = "Please wait"
                  )),

      selectInput("version_select",
                  "Select a version:",
                  choices = "Please wait")
    ),
    mainPanel(
      tabsetPanel(type = "pills",
                  activity_tab,
                  problem_tab,
                  data_tab,
                  new_tab)
    )
  )
))
