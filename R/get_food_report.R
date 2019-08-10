#' Retrieve food reports from the USDA Food Compositions  Data Base.
#' @inheritParams get_nutrients
#' @param type One of "b", "f" or "s" for basic, full or stats
#' @return An object as per the requested format.
#' @details 
#'  This uses Food Reports API Version 2
#' @examples 
#' \dontrun{
#'  get_food_report(ndbno = "35193",
#' result_type = "xml")
#' get_food_report(ndbno = c("35193","01009"),
#'                result_type = "xml")
#'                res<-get_food_report(ndbno = "35193",
#'                result_type = "xml")
#'                pretty_xml(res, tag="food", target="type")
#'                }
#' @source \url{https://ndb.nal.usda.gov/ndb/doc/apilist/API-FOOD-REPORTV2.md}
#' @seealso \code{\link{get_nutrients}} \code{\link{pretty_xml}} \code{\link{get_nutrient_info}}
#' @export

get_food_report <- function(api_key=NULL,
                            ndbno=NULL,
                            type="b",
                            result_type="json"){
if(is.null(api_key)){
  api_key <- get_apikey()
}

base_url <- "https://api.nal.usda.gov/ndb/V2/reports"
request_URL <- NULL
if(length(ndbno) == 1){
    request_URL <- paste0(base_url,"?ndbno=",
                          ndbno,"&type=",
                          type,"&format=",
                            result_type,
                          "&api_key=",api_key,
                          collapse = "")
  }
  else{
    request_URL <- paste0(base_url,"?ndbno=",
                          ndbno[1],
                          paste0("&ndbno=",
                                 ndbno[-1],
                                 collapse = ""),
                          "&type=",
                          type,"&format=",
                            result_type,
                          "&api_key=",api_key,
                          collapse = "")
  }
final_res <- httr::GET(request_URL)
if(httr::http_error(final_res) & final_res$status_code == 403){
  stop("Access denied. Did you provide the correct api_key?
       Use set_apikey to set a session key.")
}
if(result_type == "json"){
  processed_res <- jsonlite::fromJSON(httr::content(final_res,
                                                "text"),
                                  simplifyVector = FALSE)
  list(final_res, processed_res)
}
else{
  final_res 
}

}
  
  
