library("shiny")
library("dplyr")
library("purrr")



# text = function(input, output, session) {
#   output$ui = renderUI({
#     textInput("ingredient", "Enter ingredient:", value = "")
#   })
# }

generate_textboxes = function(no_of_ingredients) {
  if (no_of_ingredients > 0) {
    lapply(1:no_of_ingredients, function(i) {
      input_id = paste0("ingredient", i)
      shiny::textInput(inputId = input_id,
                       label = paste0("Ingredient ",
                                      i))
    })
  }
}

shinyServer(function(input, output) {

  #Defining the reactive values
  rvs = reactiveValues(recipes = NULL)

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
    ingredients = getrecipes::ingredients_vec(input$number, input)

    if(input$option == "All") {
      rvs$recipes = getrecipes::get_recipe(type, ingredients, pages, TRUE)
    } else {
      rvs$recipes == getrecipes::get_recipe(type, ingredients, pages, FALSE)
      }
    })
  output$table <- DT::renderDataTable({
    rvs$recipes
    })
  })
