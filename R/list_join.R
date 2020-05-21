#' List concatenation function to join recipe data
#'
#'
#' @export
list_join = function(url, content) {
  api = getrecipes::get_api()
  content = purrr::map2(content,
                        as.list(getrecipes::get_response(api = api,
                                                         url)[["results"]]),
                        c)
  content
}
