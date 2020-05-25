#' Joining lists relating to different pages of search results
#'
#' @param url An initialized vector
#' @param content A list containing recipe data
#' @param ingredients A string containing ingredients separated by a comma
#' but no space
#' @param type A character string containing a type of food/drink
#' @param pages Number of pages of search results
#' @param first_exist Logical element indicating whether the webpage that should
#' contain the first page exists
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
      } else {
        #Breaking the for loop if there are no more search results
        break
      }
    } else {
      #Breaking the for loop if there are no more search results
      break
    }
  }
  content
}
