#' Further data manipulation on the recipes data
#'
#' @param recipe_data A data frame/tibble
#' @param unwanted_ingredients A vector of unwanted ingredients
#' @importFrom dplyr %>% mutate rename
#' @importFrom rlang .data
#' @export
manipulate_data = function(recipe_data, unwanted_ingredients) {
  if (is.null(unwanted_ingredients)) {
    recipe_data %>%
      #mutate(Ingredients = map_chr(Ingredients, ~unique(.x))) %>%
      mutate(Link = purrr::map2_chr(.data$Link, .data$Name, ~HTML(paste0("<a href='",.x, "' target='_blank'>",.y,"</a>")))) %>%
      mutate(Number_of_ingredients = as.integer(purrr::map_dbl(.data$Ingredients,
                                                               length))) %>%
      mutate(Ingredients = purrr::map_chr(.data$Ingredients, ~paste0(.x,
                                                               collapse = ", "))) %>%
      rename("Number of ingredients" = "Number_of_ingredients")
  } else {
    recipe_data %>%
      #mutate(Ingredients = map_chr(Ingredients, ~unique(.x))) %>%
      mutate(Link = purrr::map2_chr(.data$Link, .data$Name, ~HTML(paste0("<a href='",.x,"'target='_blank'>",.y,"</a>")))) %>%
      mutate(Number_of_ingredients = as.integer(purrr::map_dbl(.data$Ingredients,
                                                               length))) %>%
      mutate(Ingredients = purrr::map_chr(.data$Ingredients, ~paste(.x,
                                                               collapse = ", "))) %>%
      getrecipes::filter_data(unwanted_ingredients, FALSE) %>%
      rename("Number of ingredients" = "Number_of_ingredients")
  }
}
