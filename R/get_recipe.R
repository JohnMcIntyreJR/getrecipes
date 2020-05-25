#' Collating recipes based on user parameter entry
#'
#' get_recipe() collects recipes that match the filters set by the user. It takes arguments
#' such as type of food/drink and the desired ingredients.
#'
#' @param type The type of food/drink
#' @param wanted_ingredients A vector of desired ingredients
#' @param pages The number of pages a user wants
#' @param filter_all_ing A logical element indicating whether the user wants recipes
#' containing all ingredients or at least one of the ingredients selected
#' @export
get_recipe = function(type, wanted_ingredients, pages, filter_all_ing = TRUE) {
  #User authentication
  api = getrecipes::get_api()

  #Concatenating the vector of ingredients to a single string - each ingredient
  #separated by a comma and no space
  ingredients = stringi::stri_paste(wanted_ingredients, collapse = ",")


  #Initialising the url vector and content list respectively
  url = vector("character", pages)
  content = list()

  url[1] = get_url(ingredients, type, 1)
  webpage_exists = RCurl::url.exists(url[1])

  #if statement to check if first webpage exists then a conditional step
  #if the user selects more than one page
  if(webpage_exists) {
      content = as.list(getrecipes::get_response(api = api, url[1])[["results"]])
      if(pages > 1) {
        content = getrecipes::join_pages(url, content, ingredients, type, pages, first_exist = TRUE)
        }
      } else {
      url[1] = get_url(ingredients, type, 2)
      content = as.list(getrecipes::get_response(api = api, url[1])[["results"]])
      if (pages > 1) {
        content = getrecipes::join_pages(url, content, ingredients, type, pages, first_exist = FALSE)
      }
      }

    #collating the list fields into columns in a dataset
    recipes = tibble::tibble(Name = as.vector(content$title),
                             Link = as.vector(content$href),
                             Ingredients = as.vector(stringr::str_split(content$ingredients, ", ")))

    #If statement based on whether the user wants recipes that contain all
    #ingredients or just some
    if (filter_all_ing) {
      recipes = recipes %>%
        #filter(map_lgl(.x = Ingredients, ~all(ingredients %in% .x))) %>%
        getrecipes::manipulate_data()
    } else {
      recipes = recipes %>%
        getrecipes::manipulate_data()
    }
    recipes
  }
