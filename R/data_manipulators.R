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
   plyr::llply(result[[2]]$report$foods, function(x) {
     semi_clean <- data.frame(Source= x[["name"]],
                              Value = 
                                unlist(x$nutrients))
     semi_clean$Type <- row.names(semi_clean)
     row.names(semi_clean) <- NULL
     
     semi_clean[,c(1,3,2)]
   })

}
