### Functions for handling downloaded Register of Members' Financial Interests

# Handle MP constituency and name ---------------------------------------------

#' Handle constituency
#'
#' @keywords internal

handle_mp_pcon <- function(contents) {
  contents[1] %>%
    stringr::str_extract(pattern = "(?<=\\().+?(?=\\))")
}

#' Handle MP name
#'
#' @keywords internal

handle_mp_name <- function(contents) {
  contents[1] %>%
    stringr::str_remove(pattern = "\\([^()]+\\)") %>%
    trimws()
}

# Handle category entries and tibble ------------------------------------------

#' Hangle category entries
#'
#' @keywords internal

handle_category_entries <- function(contents, category, end_pattern) {

  if (length(stringr::str_which(contents, category)) != 0) {
    start_element <- stringr::str_which(contents, category) + 1
    end_element <- grep(end_pattern, contents)[1] - 1

    if (is.na(end_element) == TRUE) {
      end_element <- length(contents)
    } else {
      end_element
    }

    entries <- contents[start_element[1]:end_element[1]]

  } else {
    entries <- ""
  }
}

#' Handle category tibble
#'
#' @keywords internal

handle_category_tibble <- function(contents, category, end_pattern, date) {
  tibble::tibble(
    register_date = date,
    constituency = handle_mp_pcon(contents),
    mp_name = handle_mp_name(contents),
    category = category,
    entries = handle_category_entries(contents, category, end_pattern)) %>%
    dplyr::filter(entries != "")
}

# Handle entry column and seperate out ----------------------------------------

#' Handle entry column
#'
#' @keywords internal

handle_entry <- function(tibble, col_name, pattern) {
  tibble[col_name] <- tibble$entries %>%
    stringr::str_match(.,
      stringr::regex(pattern = pattern, ignore_case = TRUE)) %>%
    trimws()
  tibble[col_name] <- tibble[[col_name]][,2]
  tibble
}
