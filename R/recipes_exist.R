#' A check for recipe data within a webpage
#'
#' @export
recipes_exist = function(url) {
  api = getrecipes::get_api()
  is.data.frame(getrecipes::get_response(api = api, url)$results)
}
