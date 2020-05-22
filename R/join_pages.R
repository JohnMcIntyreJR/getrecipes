#' Joining lists relating to different pages of search results
#'
#'
#' @export
join_pages = function(url, content, ingredients, type, pages, first_exist) {
  api = getrecipes::get_api()

  for (i in 2:pages) {
    url[i] = getrecipes::get_url(ingredients, type, i)

    #If statement which checks to see if the corresponding web page exists then
    #a further if statement to check if it contains recipe information
    webpage_exists = RCurl::url.exists(url[i])
    contain_recipes = getrecipes::recipes_exist(url[i])
    if (webpage_exists) {
      if (contain_recipes) {
        content = getrecipes::list_join(url[i], content)
        message = NULL
      } else {
        #Breaking the for loop if there are no more search results
        message = getrecipes::reached_limit(first_exist, page = i)
        break
      }
    } else {
      #Breaking the for loop if there are no more search results
      message = getrecipes::reached_limit(first_exist, page = i)
      break
    }
  }
  content
}
