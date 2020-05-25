#' List concatenation function to join recipe data
#'
#' @param url An initialized vector
#' @param content A list containing recipe data
#' @export
list_join = function(url, content) {
  api = getrecipes::get_api()
  content = purrr::map2(content,
                        as.list(getrecipes::get_response(api = api,
                                                         url)[["results"]]),
                        c)
  content
}
