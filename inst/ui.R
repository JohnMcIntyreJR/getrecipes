library("shiny")
library("bootstraplib")

bs_theme_new(bootswatch = "sketchy")

bs_theme_add_variables(
  "body-bg" = "LightCyan",
  "primary" = "blue",
  "secondary" = "green",
  "text-color" = "red",
  "headings-color" = "black",
  "font-family-sans-serif" = "Comic Sans MS, cursive, sans-serif",
  "body-color" = "red",
  "border-width" = "3px",
  "text-muted" = "green"
)

pizza_emoji = emo::ji("pizza")
page_emoji = emo::ji("page")

shinyUI(fluidPage(
  bootstrap(),
  shinyjs::useShinyjs(),
  titlePanel("Recipe finder"),
  sidebarLayout(
    sidebarPanel(h3("Answer the following questions to gain access to an abundance of
                    tailored recipes!"),
                 textInput("type", glue::glue("What type of food or drink would you like
                                              to make?{pizza_emoji}:")),
                 sliderInput("number1", "How many ingredients would you like to filter
                             your search by?:", value = 0, min = 0, max = 10),
                 uiOutput("wanted_ingredients"),
                 shinyjs::hidden(
                   selectInput("option", "Do you wish to collect recipes that contain
                               all of the chosen ingredients or at least one?:",
                               choices = c("All", "At least one"))
                 ),
                 #uiOutput("option"),
                 sliderInput("number2", "How many unwanted ingredients would you like to filter
                             your search by?:", value = 0, min = 0, max = 10),
                 uiOutput("unwanted_ingredients"),
                 sliderInput("pages", glue::glue("Number of pages {page_emoji}:"),
                             value = 1, min = 1, max = 10),
                 actionButton("data", "Find recipes!"),
                 img(src = "burger.png", height = "100px", width = "100px")
                 ),
    mainPanel(h2("Table providing the name, link and ingredients for each recipe"),
              h3(textOutput("no_of_pages")),
              shinycssloaders::withSpinner(DT::dataTableOutput("table"))
    ))))

#https://eu.jsonline.com/story/communities/southwest/news/greenfield/2017/09/19/gourmet-burger-restaurant-conceptual-layout-former-budget-cinemas-greenfield/681018001/
