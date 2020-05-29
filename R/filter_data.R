#' Filter out search results that contain either wanted or unwanted
#' ingredients
#'
#' @param data Data frame/tibble
#' @param ingredients A vector of ingredients
#' @param wanted Logical element dependent on whether the vectot of ingredients
#' are wanted or unwanted ingredients
#' @importFrom dplyr filter %>%
#' @importFrom rlang .data
#' @export
filter_data = function(data, ingredients, wanted) {
  if (wanted == TRUE) {
    for (ing in ingredients) {
      data = data %>%
        filter(purrr::map_lgl(.x = .data$Ingredients, ~stringr::str_detect(.x, ing)))
    }
  } else {
    for (ing in ingredients) {
      data = data %>%
        filter(!purrr::map_lgl(.x = .data$Ingredients, ~stringr::str_detect(.x, ing)))
      }
  }
  data
  }
