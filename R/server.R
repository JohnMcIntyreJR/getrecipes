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
    ingredients = concat_ingredients(input$number, input)

    observeEvent(input$number, {

    })

    content = get_content(ingredients, type, pages)
    Ingredients = as.vector(stringr::str_split(content$ingredients, ", "))

    #Creating a tibble to store the data
    rvs$recipes = tibble::tibble(Name = as.vector(content$title),
                                 Link = as.vector(content$href),
                                 Ingredients)

    #If statement deciding if recipes containing all ingredients or at least
    #one of the chosen ingredients are found
    if (input$option == "All") {
      rvs$recipes = rvs$recipes %>%
        #filter(map_lgl(.x = Ingredients, ~all(ingredients %in% .x))) %>%
        getrecipes::manipulate_data()
      } else {
        rvs$recipes = rvs$recipes %>%
          getrecipes::manipulate_data()
        }
    })
  output$table <- DT::renderDataTable({
    rvs$recipes
    })
})
