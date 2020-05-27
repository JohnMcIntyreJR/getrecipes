library("shiny")

# textUI = function(id) {
#   ns = NS(id)
#   uiOutput(ns("id"))
# }

pizza_emoji = emo::ji("pizza")
page_emoji = emo::ji("page")

shinyUI(fluidPage(
  titlePanel("Recipe finder"),
  sidebarLayout(
    sidebarPanel(h2("Answer the following questions to gain access to an abundance of
                    tailored recipes"),
                 textInput("type", glue::glue("What type of food or drink would you like
                                              to make?{pizza_emoji}:")),
 #                textUI(id), #Not sure
                 sliderInput("number1", "How many ingredients would you like to filter
                             your search by?:", value = 0, min = 0, max = 10),
                 uiOutput("wanted_ingredients"),
                 uiOutput("option"),
                 sliderInput("number2", "How many unwanted ingredients would you like to filter
                             your search by?:", value = 0, min = 0, max = 10),
                 uiOutput("unwanted_ingredients"),
                 sliderInput("pages", glue::glue("Number of pages {page_emoji}:"),
                             value = 1, min = 1, max = 50),
                 actionButton("data", "Find recipes!"),
                 ),
    mainPanel(h2("Table providing the name, link and ingredients for each recipe"),
              h3(textOutput("no_of_pages")),
              shinycssloaders::withSpinner(DT::dataTableOutput("table")))
  )
))
