#' Making a certain number of textboxes visible to the user
#'
#' @param no_of_ingredients Number of ingredients
#' @param wanted Logical element dependent on whether the ingredients are wanted
#' or not
#' @importFrom purrr map
#' @export
show_ui = function(no_of_ingredients, wanted) {
  if (wanted == TRUE) {
    ingredient = "wanted_ingredient"
  } else {
    ingredient = "unwanted_ingredient"
  }

  ingredient_ids = paste0(ingredient, 1:10)
  selected_ingredient_ids = paste0(ingredient, 1:no_of_ingredients)
  unselected_ingredient_ids = paste0(ingredient, (no_of_ingredients + 1):10)

  if (no_of_ingredients == 0) {
    purrr::map(ingredient_ids, shinyjs::hide)
  } else {
    purrr::map(selected_ingredient_ids, shinyjs::show)
    purrr::map(unselected_ingredient_ids, shinyjs::hide)
  }
}
