#' Extraction of data from a food report
#' @description This function provides a quick and efficient way to extract
#' any form of data about a food report.
#' @param what A `character`(string). What kind of information do you want to extract?!
#' @param result An object obtained from `get_nutrients`
#' @return A list containing requested report info.
#' @examples 
#' \dontrun{
#' get_report_info("name",result)
#' }
#' @seealso \code{\link{get_nutrient_info}}
#' \code{\link{get_nutrients}}
get_report_info<- function(what,result){
  #what <- deparse(substitute(what))
  # stick tto strings. Avoid "abstraction"
  if(!is.character(what)){
    stop("what should be a quoted string i.e a character.")
  }
  where <- unlist(lapply(result[[2]]$report$foods, 
                         function(x) names(unlist(x)))[[2]])
  # Let error inform user of available arguments(for now)
  
  what <-  match.arg(what,where)
  
 Filter(Negate(is.null), Map(function(x) x[[what]], 
                      result[[2]]$report$foods))
  

}



