#' Collating recipes based on user parameter entry
#'
#' get_recipe() collects recipes that match the filters set by the user. It takes arguments
#' such as type of food/drink and the desired ingredients.
#'
#' @export
get_recipe = function(type, wanted_ingredients, pages, filter_all_ing = TRUE) {
  api = getrecipes::get_api()

  length = length(wanted_ingredients)
  ingredients = stringi::stri_paste(wanted_ingredients, collapse=",")

  url = vector("character", pages)
  content = list()

  url[1] = get_url(ingredients, type, 1)
  webpage_exists = RCurl::url.exists(url[1])
  if(webpage_exists) {
      content = as.list(get_response(api = api, url[1])[["results"]])
      if(pages > 1) {
        content = getrecipes::join_pages(url, content, ingredients, type, pages, first_exist = TRUE)
        }
      } else {
      url[1] = get_url(ingredients, type, 2)
      content = as.list(get_response(api = api, url[1])[["results"]])
      if (pages > 1) {
        content = getrecipes::join_pages(url, content, ingredients, type, pages, first_exist = FALSE)
      }
      }
    recipes = tibble::tibble(Name = as.vector(content$title),
                             Link = as.vector(content$href),
                             Ingredients = as.vector(stringr::str_split(content$ingredients, ", ")))
    if (filter_all_ing) {
      recipes = recipes %>%
        #filter(map_lgl(.x = Ingredients, ~all(ingredients %in% .x))) %>%
        mutate(Number_of_ingredients = as.integer(map_dbl(Ingredients,
                                                          length))) %>%
        mutate(Ingredients = map_chr(Ingredients, ~paste0(.x,
                                                          collapse = ", "))) %>%
        rename("Number of ingredients" = "Number_of_ingredients")
    } else {
      recipes = recipes %>%
        mutate(Number_of_ingredients = as.integer(map_dbl(Ingredients,
                                                          length))) %>%
        mutate(Ingredients = map_chr(Ingredients,
                                     ~paste0(.x, collapse = ", "))) %>%
        rename("Number of ingredients" = "Number_of_ingredients")
    }
    DT::datatable(recipes)
  }
