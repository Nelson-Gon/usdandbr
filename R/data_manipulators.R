#' Pretty JSON Lists
#' @description A convenience function that returns processed JSON data.
#' @param result An object obtained from `get_nutrients`
#' @return A pretty `dput` style list.
#' @export
pretty_json <- function(result){
  lapply(result,str)
}
#' Convert JSON data to a simpler data.frame object.
#' @description When JSON data is requested, `get_nutrient info` provides
#' a convenient way to get semi-clean data.
#' @param result An object obtained from `get_nutrients`
#' @export
 get_nutrient_info <- function(result){
  plyr::llply(result[[2]]$report$foods,
              function(x){
                semi_clean <- data.frame(Value = unlist(x$nutrients))
                semi_clean$Name <- row.names(semi_clean)
                row.names(semi_clean) <- NULL
                semi_clean[,c(2,1)]
                #reshape(semi_clean,direction = "wide")
                #possibly future reshape, currently limiting dependencies.
              })

}
