# "startup" messages
.onAttach <- function(...){

   packageStartupMessage(startup_message())
}

startup_message <- function(){
   issues_url <-"https://github.com/Nelson-Gon/usdar/issues" 
  paste0("Welcome to usdar version ",
                              utils::packageVersion("usdar"),".\nPlease set api key for this session with set_apikey",
                                "\nFor more information, please see :",gsub("/issues","",issues_url),
                                "\nReport issues at: ", issues_url
   )
   
}



