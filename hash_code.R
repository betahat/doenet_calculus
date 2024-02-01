# this is the hash method
#
#
# # Takes the string of url and splices it to return a list of strings
#   getQueryText <- reactive({
#   query <- getQueryString()
#   queryText <- paste(names(query), query, sep = "=", collapse = ", ")
#   return(queryText)
# })
#
# # Takes in a list of strings and splices it to return a list of doenet id
# extract_ids_code3 <- function(queryText) {
#   if (is.null(queryText)) {
#     return(character())
#   } else {
#     url_1 <- gsub("&code=.*", "", queryText)
#     url_2 <- sub("https://doenet.shinyapps.io/analyzer/\\?", "", url_1)
#     url_3 <- sub("data=", "&data=", url_2)
#     ids <- strsplit(url_3, "&data=")[[1]][-1]
#     return(ids)
#   }
# }
#
# # Stores a list of doenet ids and returns a data frame of doenet ids
# hashmap_ids <- function(ids) {
#   if (length(ids) > 0) {
#     course_ids <- paste("Course ID", seq_along(ids))
#     hashmap <- data.frame(course_id = ids, course_id_display = course_ids, stringsAsFactors = FALSE)
#   } else {
#     hashmap <- data.frame(course_id = character(), course_id_display = character(), stringsAsFactors = FALSE)
#   }
#   return(hashmap)
# }
#
# # Takes in a data frame of doenet ids and returns a data frame of the doenet
# # ids
# extract_values <- function(hashmap) {
#   values_list <- data.frame(course_id = hashmap$course_id)
#   return(values_list)
# }
#
# # Takes in a data frame of doenet ids and returns a list of api calls for the
# # json file of the doenet id
# df_original_json <- function(hashmap) {
#   values_list <- extract_values(hashmap)
#   df_list <- list()
#
#   for (value in values_list) {
#     url <- paste0(
#       "https://www.doenet.org/api/getEventData.php?doenetId[]=",
#       value,
#       "&code=",
#       getQueryString()[["code"]]
#     )
#
#     data <- stream_in(file(url))
#
#     # Check if 'data' is not NULL before proceeding
#     if (!is.null(data)) {
#       df_list[[value]] <- data
#     }
#   }
#
#   return(df_list)
# }
#
# # Takes in a list of api calls and returns a data frame with the api call and
# # the course number
# hashmap_df_json <- function(df_list, ids) {
#   if (length(ids) > 0) {
#     course_ids <- paste("Course ID", seq_along(ids))
#     hashmap <- data.frame(json_data = df_list, selected_display = course_ids)
#   } else {
#     hashmap <- list()
#   }
#
#   return(hashmap)  # Corrected the return statement to return hashmap
# }
# #Observe block to update dropdown choices
# observe({
#   queryText <- isolate(getQueryText())
#   ids <- extract_ids_code3(queryText)
#   hashmap <- hashmap_ids(ids)
#
#   updateSelectizeInput(session, "dropdown", choices = hashmap$course_id_display)
# })
# # Create a reactive value to store the loaded data
# df <- reactive({
#   withProgress(message = "Doenet analyzer is loading your data,
#                please be wait patiently.", {
#                  selected_display <- input$dropdown
#                  b <- extract_values(hashmap_ids(extract_ids_code3(getQueryText())))
#                  c <- df_original_json(b)
#                  d <- extract_ids_code3(getQueryText())
#                  hashmap <- hashmap_df_json(c, d)  # Call df_list() as a reactive expression
#                  selected_id <- hashmap[[selected_display]]
#
#                  if (is.null(selected_id)) {
#                    # Load default dataset when no option is selected
#                    default_url <- paste0(
#                      "https://www.doenet.org/api/getEventData.php?doenetId[]=",
#                      getQueryString()[["data"]], # this is the web version
#                      "&code=",
#                      getQueryString()[["code"]]
#                    )
#                    data <- stream_in(file(default_url))
#                  } else {
#                    # Load data based on selected option
#                    selected_url <- paste0(
#                      "https://www.doenet.org/api/getEventData.php?doenetId[]=",
#                      selected_id,
#                      "&code=",
#                      getQueryString()[["code"]]
#                    )
#                    data <- stream_in(file(selected_url))
#                  }
#
#                  return(data)
#                })
# })