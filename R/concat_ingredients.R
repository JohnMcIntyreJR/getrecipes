#' Concatenating a multiple strings into one
#'
#' Taking a set of ingredient inputs and concatenating them. They are collapsed
#' with a comma and no space
#' @export
concat_ingredients = function(no_of_ingredients, input) {
  if(no_of_ingredients == 0) {
    concat_inputs = NULL
  } else {
    inputs = reactiveValuesToList(input)
    ings_i_want = paste0("ingredient", 1:no_of_ingredients)
    selected_inputs = inputs[ings_i_want]

    concat_inputs = paste0(selected_inputs, collapse = ",")
  }
  return(concat_inputs)
}
