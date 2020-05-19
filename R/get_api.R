#' Retrieve API key from Renviron
#'
#' Taken from Colin Gillespie's rtypeform package
#'
#' If the entry \code{"getrecipes_api"} exists in your
#' \code{.Renviron} return that value. Otherwise, raise an error.
#' @param api Default \code{NULL}. Your private api key. If \code{api}
#' is \code{NULL}, the environment variable \code{Sys.getenv("getrecipes_api")}
#' is used.
#' @export
get_api = function(api = NULL) {
  if (is.null(api)) api = Sys.getenv("getrecipes_api")
  # if the passed token is actually an oauth token, then use that instead
  if (inherits(api, "Token2.0")) api = api$credentials$access_token
  if (is.character(api) && nchar(api) != 0) return(api)
}
