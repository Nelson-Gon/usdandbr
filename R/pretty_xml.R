#' Process XML data
#' @description This function is useful if one has requested for the return output
#' to be of xml type in get_nutrients.
#' @param result An object obtained from get_nutrients with
#' result_type set to xml
#' @param tag An xml tag. 
#' @param target Character. Extract certain attributes from processed xml data. Defaults to 
#' NULL.
#' @param return_raw Logical. Do you want to get a raw xml file and proceed with processing yourself? Defaults
#' to FALSE.
#' @return If default parameters are used, a semi processed xml file is returned.
#' If target is set, xml attributes corrseponding to target are returned.
#' @importFrom xml2 read_xml xml_find_all xml_attrs
#' @examples 
#' \dontrun{
#' if(!require(xml2)) require(xml2)
#' pretty_xml(res,"food")
#' }
pretty_xml <- function(result, tag,target=NULL,
                       return_raw=FALSE){
  processed_xml <- xml2::read_xml(result)
  tag <- paste0("//",tag,collapse="")
  to_use <- xml2::xml_find_all(processed_xml,tag) 
   if(return_raw==TRUE){
   
    processed_xml
   }
  else{
    if(is.null(target)){
      to_use
    }  
    else{
      
      xml2::xml_attrs(to_use,target)
    }
    
  }
  


  
  
}

