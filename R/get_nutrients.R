#' USDA Nutrient Database Information Retrieval.
#' @description A simple function to access and retrieve nutrient data
#' from the USDA nutrient data base.
#' @importFrom utils str
#' @param result_type A string. One of json or xml depending on  the type of format required.
#' @param nutrients  A string or vector of strings. A nutrient id as provided on the nutrient data base website.
#' @param api_key    A string. A unique api_key obtained after signingup at [NDB](https://ndb.nal.usda.gov/ndb/doc/index#.) If this is not set with
#' \code{\link{set_apikey}}, then the user can manually set it here.
#' @param ndbno      A string. A unique ndb number for a specific food of interest. Use this if nutrients is set
#' to `NULL`.
#' @param subset   Numeric. Defaults to 0 for all food types. 1 to return common food types.
#' @param offset   Where should offsetting begin? Defaults to 0. Lower values mean more results.
#' @param max_rows Numeric. Maximum number of rows to return. Defaults to 50. 
#' @param food_group String. Return results for only a certain food group.
#' @return A list of length two. The first list element returns unprocessed data if JSON is requested while the second is a data.frame object from
#' JSON data. An XML file is returned if xml is requested.
#' @references 
#' U.S. Department of Agriculture, Agricultural Research Service. 20xx. USDA National Nutrient Database for Standard Reference, Release . Nutrient Data Laboratory Home Page, http://www.ars.usda.gov/nutrientdata
#' @examples
#' \dontrun{
#' get_nutrients(result_type = "json", nutrients = "204",
#' food_group = "0500",
#' max_rows = 50, 
#' subset = 1)
#' }
#' @source \url{https://ndb.nal.usda.gov/ndb/doc/apilist/API-NUTRIENT-REPORT.md}
#' @export
get_nutrients <- function (result_type = "json", nutrients = NULL, api_key = NULL, 
                           ndbno = NULL, subset = 0,
                           offset = 0, max_rows = 50,
                           food_group = NULL) 
{
  if(is.null(api_key)){
    api_key <- get_apikey()
  }
 
if (is.null(nutrients) || missing(nutrients)) {
    stop("A valid nutrient value must be supplied. Please visit\n         https://ndb.nal.usda.gov/ndb/nutrients/index for a list of\n         available values. Try 204 for instance.")
  }
  base_url <- "http://api.nal.usda.gov/ndb/nutrients/"
  if (result_type == "json") {
    base_url <- paste0(base_url, "?format=json&api_key=", 
                       api_key, paste0("&nutrients=",
                                       nutrients,
                                       collapse = ""),"&max=",
                       max_rows,"&offset=",
                       offset,
                       "&fg=", food_group,"&subset=",
                       subset,
                        collapse = "")
    if (is.null(ndbno) || missing(ndbno)) {
      request_URL <- base_url
    }
    else {
      request_URL <- paste0(base_url, paste0("&ndbno=", ndbno), 
                            collapse = "")
    }
    unprocessed_res <- httr::GET(request_URL)
    if (grepl("application/json", unprocessed_res$headers$`content-type`) == 
        FALSE) {
      stop("JSON requested but content is not JSON. Please check your input or try again.")
    }
    
    if(httr::http_error(unprocessed_res) & 
       unprocessed_res$status_code == 403){
      stop("Access to the server was denied. 
      Did you provide a correct API key?!
           Please sign up for one at 
           https://ndb.nal.usda.gov/ndb/doc/index")
      
    }
    
    
    processed_res <- jsonlite::fromJSON(httr::content(unprocessed_res, 
                                                      "text"), simplifyVector = FALSE)
    
    
    final_res <- list(unprocessed_res, processed_res)
    if(grepl("error",final_res[[2]])){
      stop(sprintf(final_res[[2]]$errors$error[[1]]$message,
                   "In addition HTTP status code:",
                   final_res[[2]]$errors$error[[1]]$status))
      
      
    }
    else{
      final_res
    }
  }
  else {
    xml_base <- "http://api.nal.usda.gov/ndb/reports/"
if(length(nutrients)==1){
  request_URL <- paste0(xml_base, 
                        "?nutrients=", 
                        nutrients,
                        paste0("&ndbno=",
                               ndbno),
                        "&max=",max_rows,
                        "&offset=",offset,
                        "&fg=", food_group,
                        "&format=xml", 
                        "&api_key=", api_key,
                        collapse = "")
  
}

      
    
  if(grepl("&[a-z]+=?&",request_URL)){
    request_URL<- gsub("&[a-z]+\\=(?=&)","",request_URL,
                       perl = TRUE)
  }
 

xml_result <- httr::GET(request_URL)
    
    if(httr::http_error(xml_result) & 
      xml_result$status_code == 403){
      stop("Access to the server was denied. 
      Did you provide a correct API key?!
           Please sign up for one at 
           https://ndb.nal.usda.gov/ndb/doc/index")
   }
    
    if(httr::http_type(xml_result) !="application/xml"){
      stop("Result is not XML, please try again or check your input.")
      
    }
    
  xml_result
    
  }
}
