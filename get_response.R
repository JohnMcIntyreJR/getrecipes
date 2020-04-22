# Taken from rtypeform package
get_response = function(api, url) {
  authorization = get_authorization(api)
  ua = httr::user_agent("https://github.com/csgillespie/rtypeform")
  
  resp = httr::GET(url, authorization, ua)
  cont = httr::content(resp, "text", encoding = "UTF-8")
  content = jsonlite::fromJSON(cont)
  
  check_api_response(resp, content)
  content
}
