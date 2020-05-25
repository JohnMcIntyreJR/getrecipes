#' Parsing JSON text into a list containing recipe details
#'
#' @param ingredients A string containing selected ingredients, separated by a
#' comma but with no space
#' @param type A character string containing the type of food/drink a user wishes
#' to make
#' @param pages The number of pages of search results
#' @export
get_content = function(ingredients, type, pages) {
  #Initialising the url vector and content list respectively
  url = vector("character", pages)
  content = list()

  #User authentication
  api = getrecipes::get_api()

  #Defining the url of the first page
  url[1] = getrecipes::get_url(ingredients, type, 1)

  #If statement which checks to see if the corresponding web page exists
  if (RCurl::url.exists(url[1])) {
    #Using the api to parse the JSON text to an R list for the first page
    content = as.list(getrecipes::get_response(api = api, url[1])[["results"]])

    #If user wants more than one page we concatenate pages
    if (pages > 1) {
      content = getrecipes::join_pages(url, content, ingredients, type, pages, first_exist = TRUE)
      }
    } else {
      #The case when the first page does not exist
      url[1] = getrecipes::get_url(ingredients, type, 2)
      content = as.list(getrecipes::get_response(api = api, url[1])[["results"]])
      if (pages > 1) {
        content = getrecipes::join_pages(api, content, ingredients, type, pages, first_exist = FALSE)
      }
    }
  content
  }
