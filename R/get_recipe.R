#' Collating recipes based on user parameter entry
#'
#' get_recipe() collects recipes that match the filters set by the user. It takes arguments
#' such as type of food/drink and the desired ingredients.
#'
#' @param type The type of food/drink
#' @param wanted_ingredients A vector of desired ingredients
#' @param filter_all_ing A logical element indicating whether the user wants recipes
#' containing all ingredients or at least one of the ingredients selected
#' @param unwanted_ingredients A vector of unwanted ingredients
#' @param pages The number of pages a user wants
#' @export
get_recipe = function(type, wanted_ingredients, filter_all_ing = TRUE,
                      unwanted_ingredients, pages) {
  #User authentication
  api = getrecipes::get_api()

  #Concatenating the vector of ingredients to a single string - each ingredient
  #separated by a comma and no space
  ingredients = stringi::stri_paste(wanted_ingredients, collapse = ",")


  #Initialising the url vector and content list respectively
  url = vector("character", pages)
  content = list()

  #Check to see if the first webpage exists
  url[1] = get_url(ingredients, type, 1)
  webpage_exists = RCurl::url.exists(url[1])

  #if statement to check if first webpage exists then a conditional step
  #if the user selects more than one page
  if (webpage_exists) {
      content = as.list(getrecipes::get_response(api = api, url[1])[["results"]])
      if (pages > 1) {
        content = getrecipes::join_pages(url, content, ingredients, type, pages, first_exist = TRUE)
        }
      } else {
      url[1] = get_url(ingredients, type, 2)
      content = as.list(getrecipes::get_response(api = api, url[1])[["results"]])
      if (pages > 1) {
        content = getrecipes::join_pages(url, content, ingredients, type, pages,
                                         first_exist = FALSE)
      }
      }

    #collating the list fields into columns in a dataset
    recipes = tibble::tibble(Name = stringr::str_squish(as.vector(content$title)),
                             Link = as.vector(content$href),
                             Ingredients = as.vector(stringr::str_split(content$ingredients, ", ")))


    #If statement based on whether the user wants recipes that contain all
    #ingredients or just some
    if (filter_all_ing == TRUE) {
      recipes = recipes %>%
        getrecipes::manipulate_data(unwanted_ingredients) %>%
        getrecipes::filter_data(wanted_ingredients, TRUE)
     } else {
       recipes = recipes %>%
        getrecipes::manipulate_data(unwanted_ingredients)
    }
    recipes
  }
