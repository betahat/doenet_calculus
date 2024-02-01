library(shiny)
library(tidyverse)
library(jsonlite)
library(anytime)
library(scales)
library(DT)
library(rstudioapi)
library(memoise)
library(ggradar) # devtools::install_github("ricardo-bion/ggradar")

shinyServer(function(input, output, session) {
  source("./functions.R")
  
  # ==========PRE CLEANING INPUTS==========================
  
  # ==========================GETTING DATA===================
  # What this code is doing is pulling in the data
  # getQueryString() is a function that takes a query string and turns it into
  # a list, which allows us to find the "data" item of that list.
  # By default it pulls the query string from the app environment (?)
  # renderText turns it that list into a string and then checks if it is null
  # This is a check to make sure we are in fact looking for data that exists
  
  # Stream_in unpacks the json file we get from the URL into a 1 by 3 dataframe
  # First element is a boolean that tells if it was successful or not
  # Second element is a message (typically empty right now)
  # Third is the list that contains the event log
  # df contains this 1 by 3 frame at the end of this block
  # Install and load the 'promises' package
  
  source("./setup.R", local = TRUE)
  
  # ====================PROCESSING DATA=========
  # This block pulls out the events log, which is a dataframe, within a
  # 1 element list within a 1 by 3 dataframe. So df is the frame,
  # events is an named column of df, which contains one element, which is a
  # dataframe containing the events log, which we are then assigning to a local
  # variable called events. Note the difference between the events column of df
  # and our local events object (even though they are essentially the same data)
  
  # if there is no data in the url, it uses a default base dataset
  
  # this has been removed since we don't need to worry about this case, and it doesn't fix the error anyhow
  # events <- reactive({
  #   if('data' %in% names(getQueryString())){
  #     events <- {df()$events[[1]]}
  #   } else {
  #     events <- read.csv("base.csv")
  #   }})
  
  # Takes our events and cleans them up and adds some helpful columns
  # See file functions.R for more information.
  
  # A note on how data is currently structured:
  # There are four working sets:
  # cleaned_versions -> all the way cleaned except including data from all versions
  #                    of the activity (needed for version comparison)
  # summary_data_versions -> summary of the cleaned_version set by problem
  #                         needed to do version by version by problem comparisons
  # cleaned -> the true cleaned data, which is cleaned filtered to look at the
  #             selected version. This is used for all non-cross-version plots.
  #             For more on this filter system, please consult functions.R
  # summary_data -> summary data by problem from cleaned, only looking at one version.
  #                 Used to do problem by problem work when not looking across versions.
  
  source("./make_datasets.R", local = TRUE)
  
  # This outputs the version selection and the date slider for the UI
  # output$version_select <- renderUI({
  #   selectInput("version_selected", "Version: ", c(1:versions()))
  # })
  

  
  # =========================DOWNLOADING DATA======================================
  # This gives allows the user to download the data shown in a csv file for their
  # own purposes
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("events-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(events(), file)
    }
  )
  
  source("./text_and_tables.R", local = TRUE)
  
  source("./make_plots.R", local = TRUE)
  
})
