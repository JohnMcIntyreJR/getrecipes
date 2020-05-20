library("shiny")

shinyUI(fluidPage(
  titlePanel("Recipe finder"),
  sidebarLayout(
    sidebarPanel(h2("Answer the following questions to gain access to an abundance of tailored recipes"),
                 textInput("type", "What type of food or drink would you like to make?:"),
                 sliderInput("number", "How many ingredients would you like to filter your search by?:",
                             value = 0, min = 0, max = 5),
                 conditionalPanel(
                   condition = "input.number == 1",
                   textInput("ingredient1.1", "Chosen ingredient:", "")
                 ),
                 conditionalPanel(
                   condition = "input.number == 2",
                   textInput("ingredient2.1", "Chosen ingredient #1:", ""),
                   textInput("ingredient2.2", "Chosen ingredient #2:", "")
                 ),
                 conditionalPanel(
                   condition = "input.number == 3",
                   textInput("ingredient3.1", "Chosen ingredient #1:", ""),
                   textInput("ingredient3.2", "Chosen ingredient #2:", ""),
                   textInput("ingredient3.3", "Chosen ingredient #3:", ""),
                 ),
                 conditionalPanel(
                   condition = "input.number == 4",
                   textInput("ingredient4.1", "Chosen ingredient #1:", ""),
                   textInput("ingredient4.2", "Chosen ingredient #2:", ""),
                   textInput("ingredient4.3", "Chosen ingredient #3:", ""),
                   textInput("ingredient4.4", "Chosen ingredient #4:", ""),
                 ),
                 conditionalPanel(
                   condition = "input.number == 5",
                   textInput("ingredient5.1", "Chosen ingredient #1:", ""),
                   textInput("ingredient5.2", "Chosen ingredient #2:", ""),
                   textInput("ingredient5.3", "Chosen ingredient #3:", ""),
                   textInput("ingredient5.4", "Chosen ingredient #4:", ""),
                   textInput("ingredient5.5", "Chosen ingredient #5:", ""),
                 ),
                 selectInput("option", "Do you wish to collect recipes that contain all of the chosen
                             ingredients or at least one?:", choices = c("All", "At least one")),
                 sliderInput("pages", "Number of pages:", value = 1, min = 1, max = 50),
                 actionButton("data", "Find recipes!"),
                 ),
    mainPanel(h2("Table providing the name, link and ingredients for each recipe"),
              shinycssloaders::withSpinner(DT::dataTableOutput("table")))
  )
))
