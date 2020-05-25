#' Further data manipulation on the recipes data
#'
#' @param recipe_data A data frame/tibble
#' @importFrom dplyr %>% mutate rename
#' @importFrom rlang .data
#' @export
manipulate_data = function(recipe_data) {
  recipe_data %>%
    mutate(Number_of_ingredients = as.integer(purrr::map_dbl(Ingredients,
                                                      length))) %>%
    mutate(Ingredients = purrr::map_chr(Ingredients, ~paste0(.x,
                                                      collapse = ", "))) %>%
    rename("Number of ingredients" = "Number_of_ingredients")
}
