% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/06_QA_note_tables.R
\name{lrt_make_QA_tables}
\alias{lrt_make_QA_tables}
\title{Formats light rail and tram survey data into separate tables for the QA note}
\usage{
lrt_make_QA_tables(survey_response)
}
\arguments{
\item{survey_response}{is a tibble containing the data from the survey response forms.
The tibble structure should match the output of the \code{\link{read_lrt_folder}} function.}
}
\value{
List containing feature tables, one for each numerical feature and one for the worded answers.
}
\description{
This function takes the tibble with the data from all the survey responses, and
separates it into feature tables; one for each numerical feature, and one for the worded answers.
For each numerical feature, it adds a \code{diff} column, which gives the difference between
\code{this_year} and \code{last_year}, and a \code{percent_change} column, which gives the percentage
change between \code{this_year} and \code{last_year}.
}
\examples{
lrt_make_QA_tables(read_lrt_folder("G:/AFP/RLTDAll/STS/003 BLT/003 LIGHT RAIL/0001 Data/2020/5. RAP Data/Received Survey forms"))

}
