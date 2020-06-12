#' Joining lists relating to different pages of search results
#'
#' @param url An initialized vector
#' @param content A list containing recipe data
#' @param ingredients A string containing ingredients separated by a comma
#' but no space
#' @param type A character string containing a type of food/drink
#' @param pages Number of pages of search results
#' @importFrom RCurl url.exists
#' @export
join_pages = function(url, content, ingredients, type, pages) {
  pages_skipped = 0
  for (i in 1:pages) {
    url[i] = getrecipes::get_url(ingredients, type, i)

    if (i > 1) {
      #Changing p=i to p=i+1 if response obtained already in case where p=i
      if (url[i] == url[i-1]) {
        url[i] = getrecipes::get_url(ingredients, type, i + pages_skipped)
      }
    }

    #If statement which checks to see if the corresponding web page exists then
    #a further if statement to check if it contains recipe information
    webpage_exists = RCurl::url.exists(url[i])
    if (webpage_exists) {
      contain_recipes = getrecipes::recipes_exist(url[i])
      if (contain_recipes) {
        if (i == 1) {
          content = as.list(getrecipes::get_response(api = getrecipes::get_api(),
                                           url[1])[["results"]])
        } else {
          content = getrecipes::list_join(url[i], content)
        }
      } else {
        pages_skipped = pages_skipped + 1
        url[i] = getrecipes::get_url(ingredients, type, i + pages_skipped)
        if (webpage_exists) {
          contain_recipes = getrecipes::recipes_exist(url[i])
          if (contain_recipes) {
            if (i == 1) {
              content = as.list(getrecipes::get_response(api = getrecipes::get_api(),
                                                         url[1])[["results"]])
            } else {
              content = getrecipes::list_join(url[i], content)
            }
          } else {
            #Breaking the loop if two consecutive pages return non-recipe data
            break
          }
        }
      }
    } else {
      pages_skipped = pages_skipped + 1
      url[i] = getrecipes::get_url(ingredients, type, i + pages_skipped)
      webpage_exists = RCurl::url.exists(url[i])
      if (webpage_exists) {
        contain_recipes = getrecipes::recipes_exist(url[i])
        if (contain_recipes) {
          if (i == 1) {
            content = as.list(getrecipes::get_response(api = getrecipes::get_api(),
                                                       url[1])[["results"]])
          } else {
            content = getrecipes::list_join(url[i], content)
          }
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
