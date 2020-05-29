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
#' @importFrom RCurl url.exists
#' @export
join_pages = function(url, content, ingredients, type, pages, first_exist) {
  for (i in 2:pages) {
    url[i] = getrecipes::get_url(ingredients, type, i, first_exist)

    #Changing p=i to p=i+1 if response obtained already in case where p=i
    if (url[i] == url[i-1]) {
      url[i] = getrecipes::get_url(ingredients, type, i + 1, first_exist)
    }

    #If statement which checks to see if the corresponding web page exists then
    #a further if statement to check if it contains recipe information
    webpage_exists = RCurl::url.exists(url[i])
    if (webpage_exists) {
      contain_recipes = getrecipes::recipes_exist(url[i])
      if (contain_recipes) {
        content = getrecipes::list_join(url[i], content)
      } else {
        url[i] = getrecipes::get_url(ingredients, type, i + 1, first_exist)
        if (webpage_exists) {
          contain_recipes = getrecipes::recipes_exist(url[i])
          if (contain_recipes) {
            content = getrecipes::list_join(url[i], content)
          } else {
            #Breaking the loop if two consecutive pages return non-recipe data
            break
          }
        }
      }
    } else {
      url[i] = getrecipes::get_url(ingredients, type, i + 1, first_exist)
      webpage_exists = RCurl::url.exists(url[i])
      if (webpage_exists) {
        contain_recipes = getrecipes::recipes_exist(url[i])
        if (contain_recipes) {
          content = getrecipes::list_join(url[i], content)
          } else {
            #Breaking the loop if two consecutive pages return non-recipe data
            break
            }
        } else {
          #Breaking the loop if there are no more (2 or more pages in a row
          #that result in a failed server request) search results
          break
        }
      }
    }
  content
}
