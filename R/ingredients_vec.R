#' Creating a vector of ingredients
#'
#' @export
ingredients_vec = function(no_of_ingredients, input) {
  if(no_of_ingredients == 0) {
    concat_inputs = NULL
  } else {
    inputs = shiny::reactiveValuesToList(input)
    ings_i_want = paste0("ingredient", 1:no_of_ingredients)
    selected_inputs = inputs[ings_i_want]

    vec = as.vector(unlist(selected_inputs))
  }
  return(vec)
}
