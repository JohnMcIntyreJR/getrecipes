#' Creating a vector of ingredients
#'
#' @param no_of_ingredients Number of ingredients user selects
#' @param input User inputted reactive values
#' @param wanted Logical element dependent on whether the vectot of ingredients
#' are wanted or unwanted ingredients
#' @export
ingredients_vec = function(no_of_ingredients, input, wanted) {
  if (no_of_ingredients == 0) {
    vec = NULL
  } else {
    inputs = shiny::reactiveValuesToList(input)
    if (wanted == TRUE) {
      ings_i_want = paste0("wanted_ingredient", 1:no_of_ingredients)
    } else {
      ings_i_want = paste0("unwanted_ingredient", 1:no_of_ingredients)
    }
    selected_inputs = inputs[ings_i_want]

    vec = as.vector(unlist(selected_inputs))
  }
  return(vec)
}
