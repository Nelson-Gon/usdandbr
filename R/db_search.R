#' Plain Text Database Search
#' @description Provides a plain text option to search the database.
#' @param api_key An API key as obtained from the USDA NDB.
#' @param result_type The nature of the return result. Supports one of "xml"
#' and "json"
#' @param search_term A plain text string of the desired search term.
#' @param data_source A string. One of Branded Food Products and Standard Release.
#' @param food_group  A string. A specific food_group. See examples below.
#' @param sort_by    One of `r` for relevance and `n` for name that decides the nature of sorting for the return items.
#' @param max_rows  The maximum number of rows to return.
#' @param offset Determines the starting point for "indexing". Defaults to 0.
#' @return  A processed JSON result or xml result as may be requested.
#' @examples 
#' \dontrun{
#' #set_apikey("key here if not set for the session")
#' #sorted by relevance
#' db_search(result_type = "json",search_term = "Acerola",
#' sort_by = "r")
#' # sorted by name
#' db_search(result_type = "json",search_term = "Acerola",
#' sort_by = "n")
#' # return xml
#' res<-db_search(result_type = "xml",search_term = "Acerola",
#' sort_by = "r")
#' #process xml
#' pretty_xml(res, tag="name")
#' }
#' 
#' 
#' 
db_search<- function(api_key=NULL,
                     result_type=NULL,
                     search_term=NULL,
                     data_source=NULL,
                     food_group=NULL,
                     sort_by = "r",
                     max_rows = 50,
                     offset = 0){
  if(is.null(api_key)){
    api_key <- usdar::get_apikey()
  }
  base_url <-  "https://api.nal.usda.gov/ndb/search/?"
  request_url <- paste0(base_url,
                        "format=",
                        result_type,
                        "&q=",
                        search_term,
                        "&sort=",
                        sort_by,
                        "&max=",
                        max_rows,"&offset=",
                        offset,
                        paste0("&fg=",
                                       food_group,
                                       collapse=""),
                        "&ds=",data_source,
                        "&api_key=",
                        api_key,
                        collapse="")
  final_res<-httr::GET(request_url)
  if(result_type == "json"){
    jsonlite::fromJSON(httr::content(final_res,"text"))
  }
  else{
    
   final_res
    
  }
  
}




