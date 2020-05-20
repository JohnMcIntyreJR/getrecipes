library("shiny")
library("dplyr")
library("purrr")

shinyServer(function(input, output) {

  #Defining the reactive values
  rvs = reactiveValues(recipes = NULL)

  #Observe event function which causes the code to run when the button
  #is clicked
  observeEvent(input$data, {
    #User inputs assigned to variables
    pages = input$pages
    type = input$type

    #User authentication
    api = getrecipes::get_api()

    #If statement used to create a string containing all ingredients
    if (input$number == 0) {
      ingredients = NULL
    } else if (input$number == 1) {
      ingredients = input$ingredient1.1
    } else if (input$number == 2) {
      ingredients = stringr::str_c(input$ingredient2.1, input$ingredient2.2,
                                   sep = ",")
    } else if (input$number == 3) {
      ingredients = stringr::str_c(input$ingredient3.1, input$ingredient3.2,
                                   input$ingredient3.3, sep = ",")
    } else if (input$number == 4) {
      ingredients = stringr::str_c(input$ingredient4.1, input$ingredient4.2,
                                   input$ingredient4.3, input$ingredient4.4,
                                   sep = ",")
    } else if (input$number == 5) {
      ingredients = stringr::str_c(input$ingredient5.1, input$ingredient5.2,
                                   input$ingredient5.3, input$ingredient5.4,
                                   input$ingredient5.5, sep = ",")
    }
    #Initialising the url vector and content list respectively
    url = vector("character", pages)
    content = list()

    #Defining the url of the first page
    url[1] = getrecipes::get_url(ingredients, type, 1)

    #If statement which checks to see if the corresponding web page exists
    if (RCurl::url.exists(url[1])) {
      #Using the api to parse the JSON text to an R list for the first page
      content = as.list(getrecipes::get_response(api = api, url[1])[["results"]])

      #If user wants more than one page we concatenate pages
      if (pages > 1) {
        #For loop used to concatenate the lists (each list corresponds to
        #a page)
        for (i in 2:pages) {
          url[i] = getrecipes::get_url(ingredients, type, i)
          #If statement which checks to see if the corresponding web page exists
          if (RCurl::url.exists(url[i])) {
            #If statement checking whether a deployed webpage contains recipes
            #in the form of JSON text
            if (is.data.frame(getrecipes::get_response(api = api, url[i])$results)) {
              content = purrr::map2(content,
                                    as.list(getrecipes::get_response(api = api,
                                                         url[i])[["results"]]),
                                    c)
              } else {
                #Breaking the for loop if there are no more search results
                message(glue::glue("There are only {i-1} pages"))
                break
                }
            } else {
              #Breaking the for loop if there are no more search results
              message(glue::glue("There are only {i-1} pages"))
              break
            }
          }
        }
      } else {
        #The case when the first page does not exist
        url[1] = getrecipes::get_url(ingredients, type, 2)
        content = as.list(getrecipes::get_response(api = api, url[1])[["results"]])
        if (pages > 1) {
          for (i in 2:pages) {
            url[i] = getrecipes::get_url(ingredients, type, i + 1)
            if (url.exists(url[i])) {
              if (is.data.frame(getrecipes::get_response(api = api, url[i])$results)) {
                content = purrr::map2(content,
                                      as.list(getrecipes::get_response(api = api,
                                                           url[i])
                                              [["results"]]),
                                      c)
              } else {
                message(glue::glue("There is only {i-2} pages"))
                break
              }
            } else {
              message(glue::glue("There is only {i-2} pages"))
              break
            }
          }
        }
      }
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
        mutate(Number_of_ingredients = as.integer(map_dbl(Ingredients,
                                                          length))) %>%
        mutate(Ingredients = map_chr(Ingredients, ~paste0(.x,
                                                          collapse = ", "))) %>%
        rename("Number of ingredients" = "Number_of_ingredients")
      } else {
        rvs$recipes = rvs$recipes %>%
          mutate(Number_of_ingredients = as.integer(map_dbl(Ingredients,
                                                            length))) %>%
          mutate(Ingredients = map_chr(Ingredients,
                                       ~paste0(.x, collapse = ", "))) %>%
          rename("Number of ingredients" = "Number_of_ingredients")
        }
    })
  output$table <- DT::renderDataTable({
    rvs$recipes
    })
})
