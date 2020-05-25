#' Creating a vector of ingredients
#'
#' @param no_of_ingredients Number of ingredients user selects
#' @param input User inputted reactive values
#' @export
ingredients_vec = function(no_of_ingredients, input) {
  if(no_of_ingredients == 0) {
    vec = NULL
  } else {
    inputs = shiny::reactiveValuesToList(input)
    ings_i_want = paste0("ingredient", 1:no_of_ingredients)
    selected_inputs = inputs[ings_i_want]

    vec = as.vector(unlist(selected_inputs))
  }
  return(vec)
}
