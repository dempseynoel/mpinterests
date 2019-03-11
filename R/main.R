### Functions for getting tibbles entries

#' Create a tibble of "Category 1: Employment and earnings" entries.
#'
#' \code{get_employment_and_earnings} gets entries under "Category 1:
#' Employment and earnings" in the Register of Members' Financial Interests
#' and returns a tibble. Each row is one entry.
#'
#' @return A tibble of "Category 1: Employment and earnings" entries.
#' @export

get_employment_and_earnings <- function() {

  # Get cache contents
  contents <- get_downloaded_mpinterests("interests")
  date <- get_downloaded_mpinterests("date")

  # Set category of interest
  category <- CATEGORY_1

  # Set category ending pattern
  end_pattern <- c(
    CATEGORY_2A,
    CATEGORY_2B,
    CATEGORY_3,
    CATEGORY_4,
    CATEGORY_5,
    CATEGORY_6,
    CATEGORY_7A,
    CATEGORY_7B,
    CATEGORY_8,
    CATEGORY_9,
    CATEGORY_10) %>%
    paste(., collapse = "|")

  # Get category entries
  purrr::map_df(contents, handle_category_tibble, category, end_pattern, date)
}

#' Create a tibble of "Category 2: Donations and other support" entries.
#'
#' \code{get_donations_and_support} gets entries under "Category 2: Donations
#' and other support" in the Register of Members' Financial Interests
#' and returns a tibble. Each row is one entry.
#'
#' @return A tibble of "Category 2: Donations and other support" entries.
#' @export

get_donations_and_support <- function() {

  # Get cache contents
  contents <- get_downloaded_mpinterests("interests")
  date <- get_downloaded_mpinterests("date")

  # Set category of interest
  category_a <- CATEGORY_2A
  category_b <- CATEGORY_2B

  # Set category ending pattern
  end_pattern_a <- c(
    CATEGORY_2B,
    CATEGORY_3,
    CATEGORY_4,
    CATEGORY_5,
    CATEGORY_6,
    CATEGORY_7A,
    CATEGORY_7B,
    CATEGORY_8,
    CATEGORY_9,
    CATEGORY_10) %>%
    paste(., collapse = "|")

  end_pattern_b <- c(
    CATEGORY_3,
    CATEGORY_4,
    CATEGORY_5,
    CATEGORY_6,
    CATEGORY_7A,
    CATEGORY_7B,
    CATEGORY_8,
    CATEGORY_9,
    CATEGORY_10) %>%
    paste(., collapse = "|")

  # Get category entries
  tibble_a <- purrr::map_df(contents, handle_category_tibble,
    category_a, end_pattern_a, date)
  tibble_a <- handle_entry(tibble_a, "donor_name",
    "Name of Donor:(.*?)Address of donor")
  tibble_a <- handle_entry(tibble_a, "donor_address",
    "Address of donor:(.*?)Amount")
  tibble_a <- handle_entry(tibble_a, "donor_donation",
    "Donation in kind:(.*?)Donor status")

  tibble_b <- purrr::map_df(contents, handle_category_tibble,
    category_b, end_pattern_b, date)
  tibble_b <- handle_entry(tibble_b, "donor_name",
    "Name of Donor:(.*?)Address of donor")
  tibble_b <- handle_entry(tibble_b, "donor_address",
    "Address of donor:(.*?)Amount")
  tibble_b <- handle_entry(tibble_b, "donor_donation",
    "Donation in kind:(.*?)Date received")

  # Bind tibbles
  tibble <- dplyr::bind_rows(tibble_a, tibble_b)
  tibble <- handle_entry(tibble, "date_received",
    "Date received:(.*?)Date accepted")
  tibble <- handle_entry(tibble, "donor_status",
    "Donor status:(.*?)\\(Registered")
  dplyr::select(tibble, -entries)
}

#' Create a tibble of "Category 3: Gifts and benefits from UK sources" entries.
#'
#' \code{get_gifts_and_benefits_uk} gets entries under "Category 3: Gifts and
#' benefits from UK sources" in the Register of Members' Financial Interests
#' and returns a tibble. Each row is one entry.
#'
#' @return A tibble of "Category 3: Gifts and benefits from UK sources" entries.
#' @export

get_gifts_and_benefits_uk <- function() {

  # Get cache contents
  contents <- get_downloaded_mpinterests("interests")
  date <- get_downloaded_mpinterests("date")

  # Set category of interest
  category <- CATEGORY_3

  # Set category ending pattern
  end_pattern <- c(
    CATEGORY_4,
    CATEGORY_5,
    CATEGORY_6,
    CATEGORY_7A,
    CATEGORY_7B,
    CATEGORY_8,
    CATEGORY_9,
    CATEGORY_10) %>%
    paste(., collapse = "|")

  # Get category entries and seperate
  tibble <- purrr::map_df(contents, handle_category_tibble,
    category, end_pattern, date)
  tibble <- handle_entry(tibble, "donor_name",
    "Name of Donor:(.*?)Address of donor")
  tibble <- handle_entry(tibble, "donor_address",
    "Address of donor:(.*?)Amount")
  tibble <- handle_entry(tibble, "donor_donation",
    "Donation in kind:(.*?)Date received")
  tibble <- handle_entry(tibble, "date_received",
    "Date received:(.*?)Date accepted")
  tibble <- handle_entry(tibble, "donor_status",
    "Donor status:(.*?)\\(Registered")
  dplyr::select(tibble, -entries)
}

#' Create a tibble of "Category 4: Visits outside the UK" entries.
#'
#' \code{get_visits_outside_uk} gets entries under "Category 4: Visits outside
#' the UK" in the Register of Members' Financial Interests and returns a tibble.
#' Each row is one entry.
#'
#' @return A tibble of "Category 4: Visits outside the UK" entries.
#' @export

get_visits_outside_uk <- function() {

  # Get cache contents
  contents <- get_downloaded_mpinterests("interests")
  date <- get_downloaded_mpinterests("date")

  # Set category of interest
  category <- CATEGORY_4

  # Set category ending pattern
  end_pattern <- c(
    CATEGORY_5,
    CATEGORY_6,
    CATEGORY_7A,
    CATEGORY_7B,
    CATEGORY_8,
    CATEGORY_9,
    CATEGORY_10) %>%
    paste(., collapse = "|")

  # Get category entries
  tibble <- purrr::map_df(contents, handle_category_tibble,
    category, end_pattern, date)
  tibble <- handle_entry(tibble, "donor_name",
    "Name of Donor:(.*?)Address of donor")
  tibble <- handle_entry(tibble, "donor_address",
    "Address of donor:(.*?)Estimate of")
  tibble <- handle_entry(tibble, "donor_donation",
    "amount of any donation\\):(.*?)Destination")
  tibble <- handle_entry(tibble, "visit_destination",
    "Destination of visit:(.*?)Dates of visit")
  tibble <- handle_entry(tibble, "visit_date",
    "Dates of visit:(.*?)Purpose of visit")
  tibble <- handle_entry(tibble, "visit_purpose",
    "Purpose of visit:(.*?)\\(Registered")
  dplyr::select(tibble, -entries)
}

#' Create a tibble of "Category 5: Gifts and benefits from outside the UK"
#' entries.
#'
#' \code{get_gifts_and_benefits_outside_uk} gets entries under "Category 5:
#' Gifts and benefits from outside the UK" in the Register of Members' Financial
#' Interests and returns a tibble. Each row is one entry.
#'
#' @return A tibble of "Category 5: Gifts and benefits from outside the UK"
#' entries.
#' @export

get_gifts_and_benefits_outside_uk <- function() {

  # Get cache contents
  contents <- get_downloaded_mpinterests("interests")
  date <- get_downloaded_mpinterests("date")

  # Set category of interest
  category <- CATEGORY_5

  # Set category ending pattern
  end_pattern <- c(
    CATEGORY_6,
    CATEGORY_7A,
    CATEGORY_7B,
    CATEGORY_8,
    CATEGORY_9,
    CATEGORY_10) %>%
    paste(., collapse = "|")

  # Get category entries
  tibble <- purrr::map_df(contents, handle_category_tibble,
    category, end_pattern, date)
  tibble <- handle_entry(tibble, "donor_name",
    "Name of Donor:(.*?)Address of donor")
  tibble <- handle_entry(tibble, "donor_address",
    "Address of donor:(.*?)Amount")
  tibble <- handle_entry(tibble, "donor_donation",
    "Donation in kind:(.*?)Date received")
  tibble <- handle_entry(tibble, "date_received",
    "Date received:(.*?)Date accepted")
  tibble <- handle_entry(tibble, "donor_status",
    "Donor status:(.*?)\\(Registered")
  dplyr::select(tibble, -entries)
}

#' Create a tibble of "Category 6: Land and property" entries.
#'
#' \code{get_land_and_property} gets entries under "Category 6:
#' Land and property" in the Register of Members' Financial Interests
#' and returns a tibble. Each row is one entry.
#'
#' @return A tibble of "Category 6: Land and property" entries.
#' @export

get_land_and_property <- function() {

  # Get cache contents
  contents <- get_downloaded_mpinterests("interests")
  date <- get_downloaded_mpinterests("date")

  # Set category of interest
  category <- CATEGORY_6

  # Set category ending pattern
  end_pattern <- c(
    CATEGORY_7A,
    CATEGORY_7B,
    CATEGORY_8,
    CATEGORY_9,
    CATEGORY_10) %>%
    paste(., collapse = "|")

  # Get category entries
  purrr::map_df(contents, handle_category_tibble, category, end_pattern, date)
}

#' Create a tibble of "Category 7: Shareholdings" entries.
#'
#' \code{get_shareholdings} gets entries under "Category 7:
#' Shareholdings" in the Register of Members' Financial Interests
#' and returns a tibble. Each row is one entry.
#'
#' @return A tibble of "Category 7: Shareholdings" entries.
#' @export

get_shareholdings <- function() {

  # Get cache contents
  contents <- get_downloaded_mpinterests("interests")
  date <- get_downloaded_mpinterests("date")

  # Set category of interest
  category_a <- CATEGORY_7A
  category_b <- CATEGORY_7B

  # Set category ending pattern
  end_pattern_a <- c(
    CATEGORY_7B,
    CATEGORY_8,
    CATEGORY_9,
    CATEGORY_10) %>%
    paste(., collapse = "|")

  end_pattern_b <- c(
    CATEGORY_8,
    CATEGORY_9,
    CATEGORY_10) %>%
    paste(., collapse = "|")

  # Get category entries
  tibble_a <- purrr::map_df(contents, handle_category_tibble,
    category_a, end_pattern_a, date)
  tibble_b <- purrr::map_df(contents, handle_category_tibble,
    category_b, end_pattern_b, date)

  # Bind tibbles
  dplyr::bind_rows(tibble_a, tibble_b)
}

#' Create a tibble of "Category 8: Miscellaneous" entries.
#'
#' \code{get_miscellaneous} gets entries under "Category 8:
#' Miscellaneous" in the Register of Members' Financial Interests
#' and returns a tibble. Each row is one entry.
#'
#' @return A tibble of "Category 8: Miscellaneous" entries.
#' @export

get_miscellaneous <- function() {

  # Get cache contents
  contents <- get_downloaded_mpinterests("interests")
  date <- get_downloaded_mpinterests("date")

  # Set category of interest
  category <- CATEGORY_8

  # Set category ending pattern
  end_pattern <- c(
    CATEGORY_9,
    CATEGORY_10) %>%
    paste(., collapse = "|")

  # Get category entries
  purrr::map_df(contents, handle_category_tibble, category, end_pattern, date)
}

#' Create a tibble of "Category 9: Family members employed" entries.
#'
#' \code{get_family_employed} gets entries under "Category 9:
#' Family members employed" in the Register of Members' Financial Interests
#' and returns a tibble. Each row is one entry.
#'
#' @return A tibble of "Category 9: Family members employed" entries.
#' @export

get_family_employed <- function() {

  # Get cache contents
  contents <- get_downloaded_mpinterests("interests")
  date <- get_downloaded_mpinterests("date")

  # Set category of interest
  category <- CATEGORY_9

  # Set category ending pattern
  end_pattern <- CATEGORY_10

  # Get category entries
  purrr::map_df(contents, handle_category_tibble, category, end_pattern, date)
}

#' Create a tibble of "Category 10: Family members lobbying" entries.
#'
#' \code{get_family_lobbying} gets entries under "Category 10:
#' Family members lobbying" in the Register of Members' Financial Interests
#' and returns a tibble. Each row is one entry.
#'
#' @return A tibble of "Category 10: Family members lobbying" entries.
#' @export

get_family_lobbying <- function() {

  # Get cache contents
  contents <- get_downloaded_mpinterests("interests")
  date <- get_downloaded_mpinterests("date")

  # Set category of interest
  category <- CATEGORY_10

  # Set category ending pattern
  end_pattern <- NA

  # Get category entries
  purrr::map_df(contents, handle_category_tibble, category, end_pattern, date)
}
