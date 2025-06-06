# tab for all content in doenetid ----

activity_tab <- tabPanel(
  "Analyze activity/content",
  "These tabs provide feedback on the entire activity",
  tabsetPanel(
    tabPanel(
      "Histogram of total scores",
      "Here are the frequencies of the total scores achieved by all students",
      br(),
      br(),
      textOutput("selected_activity"),
      plotOutput("hist_total")
    ),
    tabPanel(
      "Histogram of total scores by version",
      "This page shows a histogram of total score for each version of the activity",
      br(),
      br(),
      plotOutput("hist_total_version")
    ),
    tabPanel(
      "Time plot from first loading, by version",
      "Here are the times until credit was achieved, where time is computed from the time the activity was first loaded, by version.",
      br(),
      br(),
      plotOutput("time_plot_activity_version")
    ),
    tabPanel(
      "Time plots from each student loading, by version",
      "Here are the times until credit was achieved from the time each student first opened their activity",
      br(),
      br(),
      plotOutput("time_plot_person_version")
    )
  )
)

# tab for analysis by problem ----
problem_tab <-
  tabPanel(
    "Analyze Individual Problems",
    "These tabs provide feedback at the problem level",
    tabsetPanel(
      fluidRow(
        column(4, selectInput("page_select", "Page", choices = "Please wait")),
        column(
          4,
          selectInput("component_select", "Component", choices = "Please wait")
        ),
        column(4, checkboxInput(
          "include_right", "Include correct answer?"
        ))
      ),
      tabPanel(
        "Component Analysis",
        "This plot shows a representation of the top 10 submitted answers to a selected component on a selected page. Use the menu to the left to filter based on activity.",
        br(),
        br(),
        #plotOutput("all_answers_plot"),
        # height = "1250px"
        #plotOutput("wrong_plot"),
        plotOutput("component_plot"),
        DT::DTOutput("component_table")
      ),
      tabPanel("Version Comparison",
               tabsetPanel(
                 type = "tabs",
                 tabPanel("Problem Averages", plotOutput("problem_avgs_version"))
               )),
      tabPanel("Text tab",
               br(),
               br(),
               DT::DTOutput("all_answers_text")),
      # radar graph - not working now
      # tabPanel(
      #   "Radar graph",
      #   "This is a radar graph of progress across all problems - note this is a work in progress",
      #   br(),
      #   br(),
      #   plotOutput("radar_graph")
      # ),
      tabPanel(
        "Question-Specific Data",
        "This set of graphs shows the distribution of submissions for a specific question, as well as the distribution of how many students solved or attempted the question. At the bottom of the page is a graph displaying student scores vs number of submissions.",
        fluidRow(
          textInput("subm_q", "Input the Name of a Question for Specific Data"),
          column(12, plotOutput("q_submissions")),
          column(12, plotOutput("q_pie")),
          column(12, plotOutput("score_dot"))
        )
      ),
      tabPanel("Histogram by Problem", plotOutput("hist_prob")),
      tabPanel(
        "Submissions Per Problem",
        "This graph shows the average number of submissions per question. Averages are calculated across all attempts and versions of the assignment.",
        plotOutput("hist_submissions", height = "1250px")
      ),
      tabPanel(
        "Submissions vs Attempts and Versions",
        "This set of graphs shows the number of submissions per question, stratified by version number and attempt number. You may choose to display either cumulative submissions or average submissions per question.",
        fluidRow(
          selectInput(
            "MeanVar",
            "Display statistics by cumulative submissions or average submissions per student?",
            c("Cumulative" = "cm",
              "Mean" = "mean")
          ),
          column(12, plotOutput("hist_subm_attempt")),
          column(12, plotOutput("hist_subm_version"))
        )
      )#,
      # tabPanel("Time per Question",
      #          fluidRow(
      #            column(12, plotOutput("time_to_question_av")),
      #            column(12, plotOutput("time_to_question"))
      #          ))
    )
  )

# tab for analyzing datasets ----
data_tab <-
  tabPanel(
    "View Data",
    "These tabs provide views of the data in various formats",
    tabsetPanel(
      tabPanel(
        "Brief Summary",
        textOutput("num_students"),
        textOutput("num_pages"),
        textOutput("num_doenetIds"),
        textOutput("num_versions")
      ),
      tabPanel("Raw Data (events)", DT::DTOutput("events_dt")),
      tabPanel("Cleaned data", DT::DTOutput("cleaned_dt")),
      tabPanel("Summary data",
               DT::dataTableOutput("summary_data_dt"))
    )
  )

new_tab <-
  tabPanel(
    "Diagnostics",
    "This shows the total number of attempts per problem among those who achieved at least a 90% on the problem, with the mean number of attempts given by the red line.",
    tabsetPanel(
      tabPanel("Num attempts to 100%, by item",
               br(),
               plotOutput("tries_to_100")),
      tabPanel(
        "Difficult answer blanks",
        br(),
        DT::dataTableOutput("problem_spots")
      )
    )
  )
