#' Check api response
#'
#' A function that checks the api response, taken from Colin Gillespie's
#' rtypeform package
#' @param resp A response
#' @param content The content
#' @importFrom httr status_code
#' @importFrom glue glue
#' @export
check_api_response = function(resp, content) {
  status_code = httr::status_code(resp)
  if (status_code %in% c(200, 201, 204)) return(invisible(TRUE))
  msg = glue::glue("{status_code} - {content$code}: {content$description}")
  stop(msg, call. = FALSE)
}
