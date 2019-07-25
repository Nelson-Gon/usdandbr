#' Set User API key
#' @description Sets user's API key
#' @param api_key A character string as provided by the USDA Nutrient Database.
#' @return NULL Saves user api_key 
#' @examples 
#' \dontrun{
#' set_apikey(api_key="my_key_here")
#' }
#' @export

set_apikey <- function(api_key=NULL){
  if(is.null(api_key)){
    stop("Don't have an API key? Please sign up at
         https://ndb.nal.usda.gov/ndb/doc/index")
  }
  
  Sys.setenv("api_key"=api_key)
  
}

#' Get user api_key
#' @description Retrieves user api_key from .Renviron
#' @return NULL simply gets user api_key
#' @export
get_apikey <- function(){
  Sys.getenv("api_key")
}
