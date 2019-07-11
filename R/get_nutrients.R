#' USDA Nutrient Database Information Retrieval.
#' @description A simple function to access and retrieve nutrient data
#' from the USDA nutrient data base.
#' @importFrom utils str
#' @param result_type A string. One of json or xml depending on  the type of format required.
#' @param nutrients  A string or vector of strings. A nutrient id as provided on the nutrient data base website.
#' @param api_key    A string. A unique api_key obtained after signingup at [NDB](https://ndb.nal.usda.gov/ndb/doc/index#.)
#' @param ndbno      A string. A unique ndb number for a specific food of interest. Use this if nutrients is set
#' to `NULL`.
#' @param subset   Numeric. Defaults to 0 for all food types. 1 to return common food types.
#' @param offset   Where should offsetting begin? Defaults to 0. Lower values mean more results.
#' @param max_rows Numeric. Maximum number of rows to return.
#' @param food_group String. Return results for only a certain food group.
#' @return A list of length two. The first list element returns unprocessed data if JSON is requested while the second is a data.frame object from
#' JSON data. An XML file is returned if xml is requested.
#' @references 
#' U.S. Department of Agriculture, Agricultural Research Service. 20xx. USDA National Nutrient Database for Standard Reference, Release . Nutrient Data Laboratory Home Page, http://www.ars.usda.gov/nutrientdata
#' @examples
#' \dontrun{get_nutrients(nutrients = "204",
#' api_key = "your key here",
#' subset = 0,ndbno =NULL,
#' max_rows = NULL,
#' food_group = NULL,
#' offset = 0,result_type = "json")
#' }
#' @export
get_nutrients <- function (result_type = "json", nutrients = NULL, api_key = NULL, 
                           ndbno = NULL, subset = 0, offset = 0, max_rows = NULL, food_group = NULL) 
{
  request_URL <- NULL
  if (is.null(api_key) || missing(api_key)) {
    stop("An API key is required. Please signup at https://ndb.nal.usda.gov/ndb/doc/index#.")
  }
  if (is.null(nutrients) || missing(nutrients)) {
    stop("A valid nutrient value must be supplied. Please visit\n         https://ndb.nal.usda.gov/ndb/nutrients/index for a list of\n         available values. Try 204 for instance.")
  }
  base_url <- "http://api.nal.usda.gov/ndb/nutrients"
  if (result_type == "json") {
    base_url <- paste0(base_url, "?format=json&api_key=", 
                       api_key, paste0("&nutrients=",
                                       nutrients), 
                       "&fg=", food_group, 
                       "&offset=", offset, collapse = "")
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
  else if (result_type == "xml") {
    base_url <- gsub("nutrients","reports/",base_url)
    if(length(nutrients) > 1){
      base_url <- paste0(base_url, paste0("?nutrients=", 
                                          nutrients[1]),
                         paste0("&nutrients=",
                                nutrients[2:length(nutrients)]),
                         "&fg=", food_group, "&offset=", offset, "&format=xml", 
                         "&api_key=", api_key, collapse = "")
      
    }
    else{
      base_url <- paste0(base_url, "?nutrients=", nutrients,
                         "&fg=", food_group, "&offset=", 
                         offset, "&format=xml", 
                         "&api_key=", api_key, collapse = "")
    }
    
    if (is.null(ndbno) || missing(ndbno)) {
      request_URL <- base_url
    }
    else {
      request_URL <- paste0(base_url, paste0("&ndbno=",
                                             ndbno), 
                            collapse = "")
    }
    xml_result <- httr::GET(request_URL)
    
    if(httr::http_type(xml_result) !="application/xml"){
      stop("Result is not XML, please try again or check your input.")
      
    }
    
    xml_result
  }
}
