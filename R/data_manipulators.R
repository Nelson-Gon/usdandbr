#' Convert JSON data to a simpler data.frame object.
#' @description When JSON data is requested, `get_nutrient info` provides
#' a convenient way to get semi-clean data.
#' @param res An object of type `json` obtained from `get_nutrients`
#' @param abbr Logical. Should the names of Source be abbrevaited? Defaults to  TRUE.
#' @param bind_data Logical. Should the data be bound as a single `data.frame` object? Defaults
#' to TRUE.
#' @param abbr_limit If abbr is TRUE, this determines the abbreviation limit. Defaults to 
#' 14.
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
get_nutrient_info <-function(res, bind_data = TRUE,
                        abbr = TRUE, abbr_limit = 14){
  
######## This was initially more automated #######
###### The method failed for certain tasks and highly depended on seq formation #####
## This circumvents that. API changes might necessitate changes in this function#####
  
  
  final_res <- lapply(res[[2]]$report$foods, function(x)
  {
    
    final_df <- data.frame(Name= x[["name"]],
                           Weight=x[["weight"]], 
                           
                           Measure = x[["measure"]],ndno=x[["ndbno"]],
                           Nutrient_id = x[["nutrients"]][[1]][1],
                           Unit = x[["nutrients"]][[1]][2],
                           value = x[["nutrients"]][[1]][3],
                           Gm = x[["nutrients"]][[1]][4],
                           stringsAsFactors = FALSE)
    if(abbr){
      final_df["Name"] <- substring(final_df["Name"],1,abbr_limit)
    }
    final_df[,c(1,5,4,7,6,8,3,2)]
  })
  
  if(bind_data){
    do.call(rbind,final_res)
    
  }
  else{
    final_res
  }
  
}


 