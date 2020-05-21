#' Further data manipulation on the recipes data
#'
#' @importFrom dplyr %>% mutate rename
#' @export
manipulate_data = function(tibble) {
  tibble %>%
    mutate(Number_of_ingredients = as.integer(map_dbl(Ingredients,
                                                      length))) %>%
    mutate(Ingredients = map_chr(Ingredients, ~paste0(.x,
                                                      collapse = ", "))) %>%
    rename("Number of ingredients" = "Number_of_ingredients")
}
