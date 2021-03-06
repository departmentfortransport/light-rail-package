#' Converts one minimal tidy dataset table into a publication table in excel
#'
#' This function reads the data in one minimal tidy dataset table and converts it into
#' a fully formatted, publication-ready excel file. The excel file is saved in the folder
#' specified in the arguments. This function is called in the \code{\link{generate_publication_tables}}
#' function. The function uses constants from the \code{publication_table_constants.R} file
#' to determine the content of the table.
#'
#' @param minimal_tidy_table is a tibble which matches the format of those contained in the
#' minimal tidy dataset list.
#'
#' @param minimal_tidy_table_name is a string containing the name of the minimal tidy table,
#' for example "LRT0104_passenger_miles".
#'
#' @param save_publication_tables_path is a string containing the file path of the folder in which
#' you would like to save the excel file. For Windows paths, each backslash
#' must be changed to either a forward slash "/" or two backslashes "\\\\".
#'
#' @param publication_date is a string containing the date of the publication, for example
#' "25th June 2020". The date must be given in this format.
#'

make_publication_table <- function(minimal_tidy_table,
                                   minimal_tidy_table_name,
                                   publication_tables_folder_path,
                                   publication_date){


  # Set style path ================================================================================================================================================

  style_path <- system.file("styles", "DfT_styles.xlsx", package = "tramlr", mustWork = TRUE)

  xltabr::set_style_path(style_path)


  # Get minimal_tidy_table into correct format ====================================================================================================================

  # Extract table_content key from minimal_tidy_data_name

  table_key <- strsplit(minimal_tidy_table_name, "_")[[1]][[1]]


  # Round all numbers to correct decimal points

  minimal_tidy_table <- dplyr::mutate_if(minimal_tidy_table, is.numeric, tramlr::round_up, table_content[[table_key]]$decimal_points)


  # If the table should have two headers (i.e. includes GB and underground data), add three blank columns

  if (table_content[[table_key]]$double_header){

    minimal_tidy_table <- tibble::add_column(minimal_tidy_table, blank1 = "", .after = gap_one)

    minimal_tidy_table <- tibble::add_column(minimal_tidy_table, blank2 = "", .after = gap_two)

    minimal_tidy_table <- tibble::add_column(minimal_tidy_table, blank3 = "", .after = gap_three)

  }


  # If the table includes a London column, remove it

  if (table_content[[table_key]]$London){

    minimal_tidy_table <- dplyr::select(minimal_tidy_table, -London)

  }


  # Convert tibble to dataframe (xltabr functions don't work with tibbles)

  minimal_tidy_df <- as.data.frame(minimal_tidy_table)


  # Format table ==================================================================================================================================================

  LRT_tab <- xltabr::initialise()


  # Add title

  # If there is a reference to the current year in the title (and footer) then substitute in the current year

  if (table_content[[table_key]]$inflation){

    # Get year and financial year from publication date

    gdp_year <- strsplit(publication_date, " ")[[1]]
    gdp_year <- gdp_year[[length(gdp_year)]]

    year_1 <- as.integer(gdp_year) - 1
    year_2 <- stringr::str_sub(gdp_year, -2, -1)
    financial_year <- c(year_1, year_2)
    financial_year <- paste(financial_year, collapse = "/")

    # Substitute year and financial year into header and footer text

    table_content[[table_key]]$title_text <- gsub("FIN_YEAR", financial_year, table_content[[table_key]]$title_text)

    table_content[[table_key]]$footer_text <- gsub("YEAR", gdp_year, table_content[[table_key]]$footer_text)

  }

  all_title_text <- c(main_title_text,
                      table_content[[table_key]]$title_text,
                      "",
                      table_content[[table_key]]$units)

  LRT_tab <- xltabr::add_title(LRT_tab,
                               title_text = all_title_text,
                               title_style_names = LRT_title_style_names)


  # Add headers

  if (table_content[[table_key]]$double_header){

    # Uses the constants gap_two and gap_three to put the title gaps in the correct places

    gap_one_index <- grep(paste("^", gap_one, "$", sep = ""), colnames(minimal_tidy_df)) + 1

    gap_two_index <- grep(paste("^", gap_two, "$", sep = ""), colnames(minimal_tidy_df)) + 1

    gap_three_index <- grep(paste("^", gap_three, "$", sep = ""), colnames(minimal_tidy_df)) + 1

    double_headers_row_1 <- c("",
                              "",
                              rep("Light Rail and Tram Systems, England", gap_two_index - (gap_one_index + 1)),
                              "",
                              rep("Light Rail and Tram Systems, GB", gap_three_index - (gap_two_index + 1)),
                              "",
                              rep("Underground Systems", length(minimal_tidy_df)[[1]] - (gap_three_index)))

    double_headers_row_2 <- c(colnames(minimal_tidy_df)[1:(gap_one_index - 1)],
                              "",
                              colnames(minimal_tidy_df)[(gap_one_index + 1):(gap_two_index - 1)],
                              "",
                              colnames(minimal_tidy_df)[(gap_two_index + 1):(gap_three_index - 1)],
                              "",
                              colnames(minimal_tidy_df)[(gap_three_index + 1):length(minimal_tidy_df)[[1]]])

    headers_all <- list(double_headers_row_1, double_headers_row_2)

    headers_row_style <- c("top_header_1", "top_header_2")

  } else {

    headers_all <- list(colnames(minimal_tidy_df))

    headers_row_style <- c("top_header_2")

  }

  LRT_tab <- xltabr::add_top_headers(LRT_tab,
                                     top_headers = headers_all,
                                     row_style_names = headers_row_style)


  # Add body

  if (table_content[[table_key]]$double_header){

    if (table_content[[table_key]]$decimal_points == 0){

      body_column_style <- no_dp_double_header_body_col_style

    } else {

      body_column_style <- double_header_body_col_style

    }

  } else {

    if (table_content[[table_key]]$decimal_points == 0){

      body_column_style <- no_dp_single_header_body_col_style

    } else {

      body_column_style <- single_header_body_col_style

    }

  }

  LRT_tab <- xltabr::add_body(tab = LRT_tab,
                              df = minimal_tidy_df,
                              col_style_names = body_column_style,
                              fill_non_values_with = list(na = ".",
                                                          nan = NULL,
                                                          inf = NULL,
                                                          neg_inf = NULL))


  # Add footer

  # Get date to use in footer

  next_publicaion_year <- as.integer(strsplit(publication_date, " ")[[1]][[3]])
  next_publicaion_year <- as.character(next_publicaion_year + 1)

  footer_text <- c(source,
                   table_content[[table_key]]$footer_text,
                   paste("Last updated:", publication_date),
                   paste("Next update: Summer", next_publicaion_year),
                   end_footers)

  footer_styles <- c("source",
                     rep("footer", length(table_content[[table_key]]$footer_text)),
                     rep("footer_italics", 2),
                     rep("footer", 4))

  LRT_tab <- xltabr::add_footer(LRT_tab,
                                footer_text = footer_text,
                                footer_style_names = footer_styles)



  # Set column widths

  if (table_content[[table_key]]$double_header){

    column_widths <- double_header_col_widths

  } else {

    column_widths <- single_header_col_widths

  }

  LRT_tab <- xltabr::set_wb_widths(tab = LRT_tab, body_header_col_widths = column_widths)


  # Merge cells

  if (table_content[[table_key]]$double_header){

    first_header_row_index <- length(all_title_text) + 1

    openxlsx::mergeCells(LRT_tab$wb, 1, cols = (gap_one_index + 1):(gap_two_index - 1), rows = first_header_row_index)
    openxlsx::mergeCells(LRT_tab$wb, 1, cols = (gap_two_index + 1):(gap_three_index - 1), rows = first_header_row_index)
    openxlsx::mergeCells(LRT_tab$wb, 1, cols = (gap_three_index + 1):length(minimal_tidy_df)[[1]], rows = first_header_row_index)

  }

  LRT_tab <- xltabr::auto_merge_title_cells(LRT_tab)

  LRT_tab <- xltabr::auto_merge_footer_cells(LRT_tab)


  # Freeze pane

  first_table_row <- length(all_title_text) + length(headers_all) + 1

  openxlsx::freezePane(LRT_tab$wb, 1, first_table_row, first_table_column)


  # Add data and styles to workbook (xltabr stores them in a separate object until this point
  # so this is done once all the xltabr funcions are carried out)

  LRT_tab <- xltabr::write_data_and_styles_to_wb(LRT_tab)


  # Add bottom border to upper header row (if table has double header)

  if (table_content[[table_key]]$double_header){

    openxlsx::addStyle(LRT_tab$wb, 1, bottom_border, rows = first_header_row_index, cols = c((gap_one_index + 1):(gap_two_index - 1),
                                                                                             (gap_two_index + 1):(gap_three_index - 1),
                                                                                             (gap_three_index + 1):length(minimal_tidy_df)[[1]]), stack = TRUE)

  }


  # Add dotted line along the bottom of cells in the table where specified in table_content

  if (!is.null(table_content[[table_key]]$dotted_line)){

    tramlr::add_dotted_line(minimal_tidy_df,
                            all_title_text,
                            LRT_tab,
                            table_key)

  }


  # Change row height for tables with long footers

  tramlr::set_footer_row_heights(table_key,
                                 all_title_text,
                                 headers_all,
                                 minimal_tidy_df,
                                 footer_text,
                                 LRT_tab)


  # Add hyperlinks

  openxlsx::writeData(wb = LRT_tab$wb,
                      sheet = 1,
                      startRow = grep(names(hyperlink_header), main_title_text),
                      startCol = 1,
                      x = hyperlink_header)

  hyperlink_footer_row <- length(all_title_text) + length(headers_all) + dplyr::count(minimal_tidy_df)[[1]] + length(footer_text) - length(end_footers)
  hyperlink_footer_row <- hyperlink_footer_row + grep(names(hyperlink_footer), end_footers)

  openxlsx::writeData(wb = LRT_tab$wb,
                      sheet = 1,
                      startRow = hyperlink_footer_row,
                      startCol = 1,
                      x = hyperlink_footer)


  # Set print scaling and orientation

  openxlsx::pageSetup(wb = LRT_tab$wb, sheet = 1, orientation = "landscape", fitToHeight = TRUE, fitToWidth = TRUE)


  # Rename worksheet

  openxlsx::renameWorksheet(wb = LRT_tab$wb, sheet = "Sheet1", newName = table_key)


  # Save workbook

  openxlsx::saveWorkbook(LRT_tab$wb, file = paste(publication_tables_folder_path, "/", table_key, ".xlsx", sep = ""), overwrite = TRUE)


  # Message to user that the table is saved

  message(table_key)


}

