#import libraries
library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(DT)

# Load dataset
df <- read.csv("data/video_games_sales_cleaned.csv")


#Extracts all unique values (first option can select all )
genres <- c("All", unique(df$genre))
platforms <- c("All", unique(df$platform))

#Extracts the minimum and maximum values from the year column
years_range <- range(df$year, na.rm = TRUE)




##############  UI  ###############################################################


ui <- fluidPage(
  
  # for a dark mode 
  theme = shinytheme("darkly"),
  
  # css styling 
  tags$head(tags$style(HTML("
    .header { 
      background: linear-gradient(to right, #0F2027, #203A43, #2C5364); 
      color: #00FFFF; 
      text-align: center; 
      padding: 20px; 
      border-radius: 10px; 
    }
    body {
      background-color: #121212;
      color: #FFFFFF;
    }
    .well {
      background-color: #1E1E1E;
      border: 1px solid #00FFFF;
    }
    h1, h3, h4 {
      color: #00FFFF;
    }
    .btn {
      background-color: #00FFFF;
      color: black;
      font-weight: bold;
    }
    
    /*  Table Styling */
    table.dataTable {
      background-color: #1E1E1E !important;
      color: #FFFFFF !important;
      border: 1px solid #00FFFF !important;
    }
    table.dataTable thead th {
      background-color: #00FFFF !important;
      color: #000000 !important;
      font-weight: bold;
      text-align: center;
      border-bottom: 2px solid #00FFFF;
    }
    table.dataTable tbody tr {
      background-color: #252525 !important;
      color: #FFFFFF !important;
    }
    table.dataTable tbody tr:hover {
      background-color: #333333 !important;
    }
    .dataTables_wrapper {
      color: #FFFFFF !important;
    }
  "))),
  
  #Header section
  div(class = "header", 
      h1("World Game Market Insights: Sales, Trends & Rankings "), 
      p("Discover trends, rankings, and insights from top-selling video games")
  ),
  
  tabsetPanel(
    tabPanel("Sales Trends & Top Game",
             sidebarLayout(
               sidebarPanel(
                 p("Use the filters to refine your search! ",tags$br()),
                 sliderInput("year_trends", "Select Year Range:", min = years_range[1], max = years_range[2], value = years_range, sep = ""),
                 selectInput("genre_trends", "Select Genre:", choices = genres, selected = "All"),
                 selectInput("platform_trends", "Select Platform:", choices = platforms, selected = "All"),
                 img(src = "pic.jpg", width = "100%", height = "auto")
               ),
               mainPanel(
                 fluidRow(
                   h4(HTML("<b>Are you a gamer or a video game enthusiast? Then, you're in for a treat !</b> ")), 
                   
                   p("Discover the world of video games like never before ! Our dataset spans multiple years, regions, 
                     and platforms, offering insights into top-selling games, market trends, and publisher performance. 
                     Whether you're curious about the most popular games, regional sales differences, or industry trends, 
                     this app helps you explore it all. Perfect for gamers, developers, and investors alike unlock the power 
                     of data in the gaming industry!",tags$br(),tags$br()),
                   
                   column(6, wellPanel(h4(strong("Best-Selling Game 🏆")), textOutput("best_game"))),
                   column(6, wellPanel(h4(strong("Top Publisher 🔥")), textOutput("top_publisher")))
                 ),
                 h3(" Global Video Game Sales Trends 🎮",tags$br(),tags$br()),
                 p("Adjust the year range slider to explore trends over time, select a game genre to focus on specific categories, and choose
                   a platform to analyze sales across different gaming  devices"),
                 p("The chart mainly focuses on sales trends in North America, Europe, Japan, and other regions, 
                   helping you understand how game sales vary across different markets. The dashed line show how overall game sales vary across different years"),
                 
                 plotOutput("sales_trend"),
                 fluidRow(column(12, wellPanel(h4("Number of games selected:"), textOutput("num_selected_games"))))
               )
             )
    ),
    
    tabPanel("Top Ranked Games", 
             sidebarLayout(
               sidebarPanel(
                 p("Use the filters to refine your search! ",tags$br()),
                 sliderInput("year_ranked", "Select Year Range:", min = years_range[1], max = years_range[2], value = years_range, sep = ""),
                 selectInput("genre_ranked", "Select Genre:", choices = genres, selected = "All"),
                 selectInput("platform_ranked", "Select Platform:", choices = platforms, selected = "All"),
                 actionButton("submit_ranked", "Submit 🔍"),  # Submit button added
                 img(src = "pictwo.jpg", width = "100%", height = "auto")
               ),
               mainPanel(
                 h3("Top Ranked Games Based on Filters 🏆",tags$br(),tags$br()), 
                 p("Use the year range, genre, and platform filters to refine your search and discover the highest-selling games. 
                   The following table displays key details, including rankings, platforms, publishers, and regional sales.",tags$br(),tags$br()),
                 DTOutput("game_table")
               )
             )
    ),
    
    tabPanel("Explore Your Game",
             sidebarLayout(
               sidebarPanel(
                 selectizeInput("game_name", "Search for your game 👇", choices = NULL, multiple = FALSE),
                 actionButton("search_btn", "Search 🔍"),
                 img(src = "picthree.jpg", width = "100%", height = "auto")
               ),
               mainPanel(
                 h4(HTML("<b>Dive into the World of Your Favorite Games! </b> 🎮"),tags$br(),tags$br()), 
                 p(" 🔍 Curious about a specific game? Search 
                   and explore detailed insights on its sales, rankings, and performance across different regions! 
                   🌍  Whether you're a passionate gamer, a data enthusiast, or an industry analyst, this
                   feature helps you unlock valuable insights into the gaming market! ✨"),tags$br(),tags$br(),
                 DTOutput("game_info")
               )
             )
    )
  )
)





##############  Server  ###############################################################


server <- function(input, output, session) {
  
  #  filters
  filtered_trends_data <- reactive({
    df %>%
      filter(
        (input$genre_trends == "All" | genre == input$genre_trends),
        (input$platform_trends == "All" | platform == input$platform_trends),
        year >= input$year_trends[1] & year <= input$year_trends[2]
      )
  })
  
  # Top Ranked Games (only updates when Submit is clicked)
  filtered_ranked_data <- eventReactive(input$submit_ranked, {
    df %>%
      filter(
        (input$genre_ranked == "All" | genre == input$genre_ranked),
        (input$platform_ranked == "All" | platform == input$platform_ranked),
        year >= input$year_ranked[1] & year <= input$year_ranked[2]
      )
  })
  
  # Best-Selling Game
  output$best_game <- renderText({
    data <- filtered_trends_data()
    if (nrow(data) == 0) return("No game found for selected filters.")
    best_game <- data %>% arrange(desc(global_sales)) %>% slice(1) %>% pull(name)
    return(best_game)
  })
  
  # Top Publisher
  output$top_publisher <- renderText({
    data <- filtered_trends_data()
    if (nrow(data) == 0) return("No publisher found for selected filters.")
    best_publisher <- data %>%
      group_by(publisher) %>%
      summarise(total_sales = sum(global_sales, na.rm = TRUE)) %>%
      arrange(desc(total_sales)) %>%
      slice(1) %>% pull(publisher)
    return(best_publisher)
  })
  
  # Number of Selected Games
  output$num_selected_games <- renderText({
    data <- filtered_trends_data()
    paste(nrow(data), "games selected")
  })
  
  # Sales Trend Plot
  output$sales_trend <- renderPlot({
    data <- filtered_trends_data()
    if (nrow(data) <= 1) return(NULL)
    
    sales_data <- data %>%
      group_by(year) %>%
      summarise(
        na_sales = sum(na_sales, na.rm = TRUE),
        eu_sales = sum(eu_sales, na.rm = TRUE),
        jp_sales = sum(jp_sales, na.rm = TRUE),
        other_sales = sum(other_sales, na.rm = TRUE),
        global_sales = sum(global_sales, na.rm = TRUE)
      )
    
    ggplot(sales_data, aes(x = year)) +
      geom_line(aes(y = na_sales, color = "North America"), linewidth = 1.5) +
      geom_line(aes(y = eu_sales, color = "Europe"), linewidth = 1.5) +
      geom_line(aes(y = jp_sales, color = "Japan"), linewidth = 1.5) +
      geom_line(aes(y = other_sales, color = "Other Regions"), linewidth = 1.5) +
      geom_line(aes(y = global_sales, color = "Global Sales"), linewidth = 1.5, linetype = "dashed") +
      labs(x = "Year", y = "Total Sales (millions)", color = "Sales Region") +
      theme_minimal()
  })
  
  #  Game Name Choices
  observe({
    updateSelectizeInput(session, "game_name", choices = unique(na.omit(df$name)), server = TRUE)
  })
  
  # Search Game
  game_search <- eventReactive(input$search_btn, {
    req(input$game_name)
    df %>% filter(name == input$game_name)
  })
  
  output$game_table <- renderDT({ datatable(filtered_ranked_data(), options = list(pageLength = 10,autoWidth = TRUE, rownames = FALSE)) })
  
  output$game_info <- renderDT({ datatable(game_search(), options = list(pageLength = 5, autoWidth = TRUE)) })
}

shinyApp(ui, server)
