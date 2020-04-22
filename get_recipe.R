get_recipe = function(type, wanted_ingredients, pages = NULL) {
  api = get_api()
  length = length(wanted_ingredients)
  ingredients = vector("character", length)
  if(length == 1) {
    ingredients = wanted_ingredients
  } else {
    for(i in 1:(length-1)) {
      ingredients[i] = glue("{wanted_ingredients[i]},")
    }
    for(i in length) {
      ingredients[i] = glue("{wanted_ingredients[i]}")
    }
    ingredients = stringi::stri_paste(ingredients, collapse="")
  }
  if(is.null(pages)) {
    url = get_url(ingredients, type, NULL)
    content = as.list(get_response(api = api, url)[["results"]])
  } else {
    url = vector("character", pages)
    content = list()
    url[1] = get_url(ingredients, type, 1)
    if(url.exists(url[1])) {
      content = as.list(get_response(api = api, url[1])[["results"]])
      for (i in 2:pages) {
        url[i] = get_url(ingredients, type, i)
        if(url.exists(url[i])) {
          if(is.data.frame(get_response(api = api, url[i])$results)) {
            content = purrr::map2(content, as.list(get_response(api = api, url[i])[["results"]]), c)
            #list_join(i)
          } else {
            message(glue("There are only {i-1} pages"))
            break
          }
        } else {
          message(glue("There are only {i-1} pages"))
          break
        }
      }
    } else {
      url[1] = get_url(ingredients, type, 2)
      content = as.list(get_response(api = api, url[1])[["results"]])
      if (pages > 1) {
        for(i in 2:pages) {
          url[i] = get_url(ingredients, type, i+1)
          if(url.exists(url[i])) {
            if(is.data.frame(get_response(api = api, url[3])$results)) {
              content = purrr::map2(content, as.list(get_response(api = api, url[i])[["results"]]), c)
              #list_join(i)
              #content[i] = as.list(content[["results"]])
            } else {
              message(glue("There is only {i-2} pages"))
              break
              }
            } else {
            message(glue("There is only {i-2} pages"))
            break
          }
        }
      }
    }
    recipes = tibble::tibble(Name = as.vector(content$title), Link = as.vector(content$href), Ingredients = as.vector(str_split(content$ingredients, ", ")))
    recipes %>%
      mutate(total_ingredients = purrr::map_dbl(ingredients, length))
      #mutate("All Ingredients" = str_detect(ingredients, wanted_ingredients)) 
      #mutate(contains_all = map_lgl(Ingredients,
      #                                ~any(.x == "bacon")))
  }
}

###### Football data ######
# www.football-data.org/documentation/api#competition
# https://api.football-data.org/v2/competitions?plan=TIER_ONE
# https://api.football-data.org/v2/competitions/SA/scorers
# http://api.football-data.org/v2/teams/759/matches
# 
# ###### Twitter api ######
# https://api.twitter.com/1.1/search/tweets.json