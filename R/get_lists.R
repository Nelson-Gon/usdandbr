#' Get Lists from the USDA Food Composition Databases
#' @description A convenient wrapper function to obtain lists from the 
#' USDA nutrient databases. It queries the database for a list of foods,
#' food groups or nutrients. 
#' @param list_type A character(string). One of f,n,ns,nr,f, and g. See details
#' below.
#' @param sort_by A character(string). How would you like to sort the lists? One of 
#' n for name and id. id differs depending on the list type.
#' @param api_key  string. A valid api_key obtained from \url{https://ndb.nal.usda.gov/ndb/doc/index#}
#' @param max_items integer. Maximum number of items to return.
#' @param offset integer. Where should querying start? Defaults to 0.
#' @param format string. What kind of output do you need? Supports "xml" and "json"
#' @param return_request If format is set to json, this controls whether the initial request 
#' is returned to the user. Defaults to FALSE.
#' @details For list_type d represents derived foods, f for food,
#' n for all nutrients, ns speciality nutrients, nr for standard nutrients 
#' and g for food group. Details available at \url{https://ndb.nal.usda.gov/ndb/doc/apilist/API-LIST.md}
#' @return A list depending on the requested format type. For JSON, a list of length 2 if return request is requested. Otherwise a 
#' list of length 1 with a semi_processed JSON object. The return value for XML is 
#' an xml document.
#' @references \url{https://ndb.nal.usda.gov/ndb/doc/apilist/API-LIST.md}
#' @seealso \code{\link{get_nutrients}} \code{\link{pretty_xml}} \code{\link{pretty_json}}
#' @examples 
#' \dontrun{
#' res <- get_list(
#' list_type = "ns",sort_by = "id",
#' max_items = 50,offset = 12,format = "xml")
#' res
#' usdar::pretty_xml(res,tag="name")
#' usdar::pretty_json(res)
#' }
#' @export
#' 
get_list <- function(list_type="f", sort_by="n", api_key=NULL,
                     max_items=30, offset=0,
                     format="json", return_request=FALSE){
  
  if(is.null(api_key)){
    api_key <- get_apikey()
    if(is.null(api_key)){
      stop("Please provide an API key either manually or by
           setting it for the session with set_apikey. Sign up for 
           a key at https://ndb.nal.usda.gov/ndb/doc/index")
    }
  }
  base_url <- "https://api.nal.usda.gov/ndb/list?format="
  
 
   request_url <- paste0(base_url,"json&lt=",
                        list_type,"&sort=",
                        sort_by,"&api_key=",
                        api_key)
  
  if(format=="json"){
    request_url <- request_url
    unprocessed_res <- httr::GET(url=request_url)
    semi_processed_res <-jsonlite::fromJSON(httr::content(unprocessed_res,"text"))
    
    final_res <- list(unprocessed_res,semi_processed_res)
    if(return_request){
      final_res
    }
    else{
      final_res[[2]]
    }
    
  }
  else{
    request_url <- gsub("json","xml", request_url)
    httr::GET(request_url)
    
  }
  
 }


