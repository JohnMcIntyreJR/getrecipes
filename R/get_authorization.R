#' Get Authorziation
#'
#' A function to get authorization taken from Colin Gillespie's rtypeform
#' package
#' 
#' @param api An authentication key
#' @export
get_authorization = function(api) {
  api = get_api(api)
  httr::add_headers(authorization = glue::glue("bearer {api}"))
}
