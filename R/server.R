library("shiny")
library("dplyr")
library("purrr")



# text = function(input, output, session) {
#   output$ui = renderUI({
#     textInput("ingredient", "Enter ingredient:", value = "")
#   })
# }

shinyServer(function(input, output) {

  #Defining the reactive values
  rvs = reactiveValues(recipes = NULL, page_message = NULL)

  # observeEvent(input$number, {
  #   for(i in 1:input$number) {
  #   callModule(text, "id")
  #   }
  # })

  observeEvent(input$number, {
    output$ingredients = renderUI({
      no_of_ingredients = input$number
      generate_textboxes(no_of_ingredients)
    })
  })


  #Observe event function which causes the code to run when the button
  #is clicked
  observeEvent(input$data, {
    #User inputs assigned to variables
    pages = input$pages
    type = input$type

    print(class(input))

    #Generating a vector of ingredients
    ingredients = getrecipes::ingredients_vec(input$number, input)

    # If statement which depends on whether user wants recipes containing all
    # or at least one of the chosen ingredients
    if(input$option == "All") {
      rvs$recipes = getrecipes::get_recipe(type, ingredients, pages, TRUE)
    } else {
      rvs$recipes == getrecipes::get_recipe(type, ingredients, pages, FALSE)
    }

    #Creating a page count message
    rvs$page_message = getrecipes::page_count(rvs$recipes, pages)
    })
  output$table = DT::renderDataTable({
    DT::datatable(rvs$recipes)
    })
  output$no_of_pages = renderText({
    rvs$page_message
    })
  })
