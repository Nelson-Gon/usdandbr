% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{set_apikey}
\alias{set_apikey}
\title{Set User API key}
\usage{
set_apikey(api_key = NULL)
}
\arguments{
\item{api_key}{A character string as provided by the USDA Nutrient Database.}
}
\value{
NULL Saves user api_key
}
\description{
Sets user's API key
}
\examples{
\dontrun{
set_apikey(api_key="my_key_here")
}
}
