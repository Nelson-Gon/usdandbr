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
#' @param abbr Logical. Should the names of Source be abbrevaited? Defaults to  TRUE.
#' @param bind_data Logical. Should the data be bound as a single `data.frame` object? Defaults
#' to TRUE.
#' @return The default return value is a data.frame object showing
#' the corresponding data as requested with `get_nutrients`. If bind_data is
#' set to FALSE, a list of data frames is returned instead.
#' @seealso \code{\link{get_nutrients}}
#' @examples 
#' \dontrun{
#' res <-get_nutrients(nutrients = c("204","510"))
#' get_nutrient_info(res)
#' }
#' @export
 get_nutrient_info <- function(result, abbr = TRUE, bind_data = TRUE){
    
    if(abbr==TRUE){
       
       final_res <- plyr::llply(result[[2]]$report$foods,
                                function(x) {
                                   if(nchar(x[["name"]]) >= 10){
                                      x[["name"]] <- gsub("[[:punct:]]$","",
                                                          substring(x[["name"]], 1, 14))
                                   }
                                   semi_clean <- data.frame(Source= x[["name"]],
                                                            Value = 
                                                               unlist(x$nutrients),
                                                            stringsAsFactors = FALSE)
                                   semi_clean$Type <- row.names(semi_clean)
                                   row.names(semi_clean) <- NULL
                                   
                                   semi_clean[,c(1,3,2)]
                                })
       
       if(bind_data ==TRUE){
          do.call(rbind,final_res)
       }
       else{
          final_res
          
       }
       
       
       
       
       
    }
    
    else{
       final_res <-plyr::llply(result[[2]]$report$foods, 
                               function(x) {
                                  semi_clean <- data.frame(Source= x[["name"]],
                                                           Value = 
                                                              unlist(x$nutrients),
                                                           stringsAsFactors = FALSE)
                                  semi_clean$Type <- row.names(semi_clean)
                                  row.names(semi_clean) <- NULL
                                  semi_clean[,c(1,3,2)]
                               })
       
       if(bind_data ==TRUE){
          do.call(rbind,  final_res)
       }
       
       else{
          final_res
       }
       
       
       
       
    }
    
 }
 
 
