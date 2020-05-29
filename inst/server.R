library("shiny")
library("dplyr")
library("purrr")
library("shinyjs")


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

  output$wanted_ingredients = renderUI({
    getrecipes::generate_textboxes(10, TRUE)
  })

  observeEvent(input$number1, {


    ingredient_ids = paste0("wanted_ingredient", 1:10)
    selected_ingredient_ids = paste0("wanted_ingredient", 1:input$number1)
    unselected_ingredient_ids = paste0("wanted_ingredient", (input$number1 + 1):10)

    if (input$number1 == 0) {
      map(ingredient_ids, shinyjs::hide)
    } else{
      map(selected_ingredient_ids, shinyjs::show)
      map(unselected_ingredient_ids, shinyjs::hide)
    }
  })

  observeEvent(input$number2, {
    output$unwanted_ingredients = renderUI({
      no_of_unwanted_ingredients = input$number2
      getrecipes::generate_textboxes(no_of_unwanted_ingredients, FALSE)
    })
  })

  observeEvent(input$number1, {
    if (input$number1 >= 2) {
      output$option = renderUI({
      selectInput("option", "Do you wish to collect recipes that contain
                all of the chosen ingredients or at least one?:",
                choices = c("All", "At least one"))
        })
      }
    })


  #Observe event function which causes the code to run when the button
  #is clicked
  observeEvent(input$data, {
    #User inputs assigned to variables
    pages = input$pages
    type = input$type

    #Generating a vector of ingredients
    ingredients = getrecipes::ingredients_vec(input$number1, input, TRUE)
    unwanted_ingredients = getrecipes::ingredients_vec(input$number2, input, FALSE)


    # If statement which depends on whether user wants recipes containing all
    # or at least one of the chosen ingredients

    if (input$number1 < 2) {
      rvs$recipes = getrecipes::get_recipe(type, ingredients, FALSE, unwanted_ingredients, pages)
    } else {
      if (input$option == "All") {
        rvs$recipes = getrecipes::get_recipe(type, ingredients, TRUE, unwanted_ingredients, pages)
        } else {
          rvs$recipes = getrecipes::get_recipe(type, ingredients, FALSE, unwanted_ingredients,
                                               pages)
        }
      }

    #Creating a page count message
    rvs$page_message = getrecipes::page_count(rvs$recipes, pages)
    })
  output$table = DT::renderDataTable({
    DT::datatable(rvs$recipes, escape = FALSE)
    })
  output$no_of_pages = renderText({
    rvs$page_message
    })
  })
