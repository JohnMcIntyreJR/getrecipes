#' Function displaying text indicating the number of pages of search results
#'
#' @param data A data frame/tibble
#' @param pages_wanted Desired number of pages of search results
#' @importFrom glue glue
#' @importFrom english as.english
#' @importFrom stringr str_to_title
#' @export
page_count = function(data, pages_wanted) {
  if (pages_wanted == 1) {
    "One page of search results!"
  }
  pages_returned = ceiling(nrow(data) / 10)
  logical = pages_returned < pages_wanted
  if (logical) {
    pages_returned = english::as.english(pages_returned)
    if(pages_returned == 1) {
      glue::glue("There is only 1 page that matches
                 your search criteria")
      } else {
      glue::glue("There are only {pages_returned} pages that match
                 your search criteria")
        }
    } else {
      pages_wanted = stringr::str_to_title(english::as.english(pages_wanted))
      glue::glue("{pages_wanted} pages of search results!")
    }
  }
