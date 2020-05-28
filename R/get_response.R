#' Getting a response from a server
#'
#' Taken from rtypeform package created by Colin Gillespie
#' @param api An application programming interface key to authenticate a user to an API
#' @param url The url of the webpage
#' @export
get_response = function(api, url) {
  authorization = get_authorization(api)
  ua = httr::user_agent("https://github.com/JohnMcIntyreJR/getrecipes")

  resp = httr::GET(url, authorization, ua)
  # if(status_code(resp) != 200) {
  #   resp = RETRY("GET", url, times = 5)
  # }
  cont = httr::content(resp, "text", encoding = "UTF-8")
  content = jsonlite::fromJSON(cont)

  check_api_response(resp, content)
  content
}
