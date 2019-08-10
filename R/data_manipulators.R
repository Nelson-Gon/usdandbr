#' Convert JSON data to a simpler data.frame object.
#' @description When JSON data is requested, `get_nutrient info` provides
#' a convenient way to get semi-clean data.
#' @param res An object of type `json` obtained from `get_nutrients`
#' @param abbr Logical. Should the names of Source be abbrevaited? Defaults to  TRUE.
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
get_nutrient_info <-function(res, 
                        abbr = TRUE, abbr_limit = 14){
  
######## This was initially more automated #######
###### The method failed for certain tasks and highly depended on seq formation #####
## This circumvents that. API changes might necessitate changes in this function#####
  

res1<-do.call(rbind,lapply(res[[2]]$report$foods,
                                function(x)
      do.call(rbind, lapply(x$nutrients,
                            
                            function(y)
                              
                              data.frame(ID = y[[1]],
                                         Nutrient=y[[2]],
                                         Unit=y[[3]], 
                                         Value=y[[4]],
                                         Gm=y[[5]],
                                         stringsAsFactors = FALSE)))))
    if(abbr){
      final_df <-do.call(rbind,
                         lapply(res[[2]]$report$foods, 
                                function(x)
                                  
                                  data.frame(ndbno = x[[1]],
                                             Name=substring(x[[2]],1,
                                                            abbr_limit),
                                             Weight=x[[3]],
                                             Measure = x[[4]],
                                             stringsAsFactors = FALSE)))  
      
      
    }
    
    
    else{
      final_df <-do.call(rbind,
                         lapply(res[[2]]$report$foods, 
                                function(x)
                                  
                                  data.frame(ndbno = x[[1]],
                                             Name=x[[2]],
                                             Weight=x[[3]],
                                             Measure = x[[4]],
                                             stringsAsFactors = FALSE)))
    }
    
    
    
    do.call(data.frame,list(final_df,res1))[,c(2,1,5,6,3,7,8,4,9)]
    
    
    
  }
  
  