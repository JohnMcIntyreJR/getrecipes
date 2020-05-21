#' Exceeding search results indicator
#'
#'
#' Function that prints a message to indicate the user when they have exceeded
#' the number of search results
#'
#' @export
reached_limit = function(first_exist, page) {
  if(first_exist) {
    message(glue::glue("There are only {page-1} pages"))
  } else {
    message(glue::glue("There are only {page-2} pages"))
  }
}
