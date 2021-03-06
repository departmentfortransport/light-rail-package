% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/05_QA_check_last_year_fields.R
\name{are_rows_identical}
\alias{are_rows_identical}
\title{Checks if rows are identical}
\usage{
are_rows_identical(sent_row, response_row)
}
\arguments{
\item{sent_row}{is a row from the survey sent forms tibble.}

\item{response_row}{is a row from the survey response forms tibble.}
}
\value{
If the inputs are identical, the output will be an empty tibble.
If the inputs are not identical, the output will be a tibble containing the name of the tram network,
the field in which the values are different, and the two different values.
}
\description{
This function checks if rows from the survey sent forms and the survey response forms are identical.
If they are, it returns an empty tibble.
If they are not, it returns a tibble with the name of the tram network, the field in which the values
are different, and the two different values.
}
