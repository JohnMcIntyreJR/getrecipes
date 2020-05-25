#' Generating shiny textboxes
#'
#' The idea behind this function is to dynamically create a certain amount
#' of shiny UI textboxes based on the number of ingredients the user wants
#' to filter their search results by
#'
#' @param no_of_ingredients Number of ingredients selected by the user
#' @export
generate_textboxes = function(no_of_ingredients) {
  if (no_of_ingredients > 0) {
    lapply(1:no_of_ingredients, function(i) {
      input_id = paste0("ingredient", i)
      shiny::textInput(inputId = input_id,
                       label = paste0("Ingredient ",
                                      i))
    })
  }
}
