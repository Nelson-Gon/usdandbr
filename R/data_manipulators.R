#' Pretty JSON Lists
#' @description A convenience function that returns processed JSON data.
#' @param result An object obtained from `get_nutrient_info`
#' @return A `data.frame` object with prettier JSON formatter data.
#' @seealso \code{\link{get_nutrient_info}}
#' @examples 
#' \dontrun{
#' # After setting api_key, get data
#' res <-get_nutrients(nutrients=c("204","205"),
#' result_type="json",
#' offset = 25,max_rows = 50,food_group = c("0500","0100"))
#' # use get_nutrient_info to get a semi-processed output
#' res2<-get_nutrient_info(res)
#' #prettify the above output
#' pretty_json(res2)
#' }
#' @export
pretty_json <- function(result) {
# This splits the data into the appropriate 
# Values, Food_Type, ID, SOURCE
pretty_result<- data.frame(Food=result[seq(2,
                                  nrow(result),5),2],
                    ID=result[seq(1,nrow(result),5),2],
                    Source=result[seq(1,nrow(result),5),1])
  numerics_only<-suppressWarnings(as.numeric(result$Value))
 numerics_only<-numerics_only[!is.na(numerics_only)] 
 
  pretty_result$Value<-numerics_only[seq(1,
                    length(numerics_only),2)]
  pretty_result$Value_2 <-numerics_only[seq(2,
                              length(numerics_only),2)]
  pretty_result$ID <- gsub("\\D","",pretty_result$ID)
  pretty_result[,c(3,1,2,4,5)]
  
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
#'res<-get_nutrients(nutrients = "204")
#'head(get_nutrient_info(res))

#' }
#' @export
get_nutrient_info <-
  function(result,
           abbr = TRUE,
           bind_data = TRUE) {
    if (abbr) {
      final_res <- plyr::llply(result[[2]]$report$foods,
                               function(x) {
                                 if (nchar(x[["name"]]) >= 10) {
                                   x[["name"]] <- gsub("[[:punct:]]$", "",
                                                       substring(x[["name"]], 1, 14))
                                 }
                                 semi_clean <-
                                   data.frame(
                                     Source = x[["name"]],
                                     Value =
                                       unlist(x$nutrients),
                                     stringsAsFactors = FALSE
                                   )
                                 #semi_clean$Type <- row.names(semi_clean)
                                 #row.names(semi_clean) <- NULL
                                 # Replace IDs with more informative output
                                 # Check IDs
                                 semi_clean$Value <-
                                   gsub("(\\d{3,})",
                                        "ID: \\1", semi_clean$Value,
                                        perl = TRUE)
                                 
                                 
                  semi_clean$Value <-gsub("(\\b[a-z]{1}\\b)",
                                      "Unit: \\1",semi_clean$Value,
                                              perl=TRUE) 
                                 
                                 semi_clean
                                 
                               })
      
      if (bind_data) {
        do.call(rbind, final_res)
      }
      else{
        final_res
        
      }
      
      
      
      
      
    }
    
    else{
      final_res <- plyr::llply(result[[2]]$report$foods,
                               function(x) {
                                 semi_clean <- data.frame(
                                   Source = x[["name"]],
                                   Value =
                                     unlist(x$nutrients),
                                   stringsAsFactors = FALSE
                                 )
                                 semi_clean$Value <-
                                   gsub("(\\d{3,})",
                                        "ID: \\1", semi_clean$Value,
                                        perl = TRUE)
                                 
                                 
                                 semi_clean$Value <-gsub("(\\b[a-z]{1}\\b)",
                                                         "Unit: \\1",semi_clean$Value,
                                                         perl=TRUE) 
                                 
                                 semi_clean
                                
                                 semi_clean
                               })
      
      if (bind_data) {
        do.call(rbind,  final_res)
      }
      
      else{
        final_res
      }
      
      
      
      
    }
    
  }
