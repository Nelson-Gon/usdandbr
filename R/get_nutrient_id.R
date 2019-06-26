#' Convenience function to easily extract nutrient ids.
#' @description Provides an easy way to access nutrient ids as provided 
#' by the USDA.
#' @param nutrient_name Name of the nutrient for which an id is returned.
#' @param df The data set that contains nutrient ids. Can be loaded into the 
#' environment by calling `data("nutrient_ids")`
#' @return Returns the nutrient id.
#' @examples 
#' data("nutrient_ids")
#' get_nutrient_id("myri",nutrient_ids)
#' @export
get_nutrient_id<- function(nutrient_name,df){
  df$NDB.Name <- sapply(df$NDB.Name,tolower)
  nutrient_name <- match.arg(nutrient_name,df$NDB.Name)
  to_match <- which(df$NDB.Name==nutrient_name)
  #to_match <- tolower(to_match)
  df[to_match,"NDB.ID"]
  
}


