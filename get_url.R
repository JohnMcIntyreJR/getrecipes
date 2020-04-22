get_url = function(ingredients, type, page) {
  if(is.null(page)) {
    glue("http://www.recipepuppy.com/api/?i={ingredients}&q={type}")
    } else {
      glue("http://www.recipepuppy.com/api/?i={ingredients}&q={type}&p={page}")
    }
}
