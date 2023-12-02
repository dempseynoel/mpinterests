### Functions for handling contents and mp page urls

# Handle contents page --------------------------------------------------------

#' Handle MP hrefs
#'
#' @keywords internal

handle_mp_hrefs <- function(contents_page) {
  xml2::read_html(contents_page) %>%
    rvest::html_nodes(xpath = '//*[@id="mainTextBlock"]//a/@href') %>%
    rvest::html_text() %>%
    stringr::str_remove(pattern = "#[:upper:]") %>%
    tibble::tibble(mp_hrefs = .) %>%
    dplyr::filter(mp_hrefs != "")
}

#' Handle MP urls
#'
#' @keywords internal

handle_mp_urls <- function(contents_page) {
  base_url <- stringr::str_remove(contents_page, "contents.htm")
  mp_page_url <- handle_mp_hrefs(contents_page)
  mp_page_url$mp_urls <- stringr::str_glue("{base_url}{mp_page_url$mp_hrefs}")
  mp_page_url
}

# Handle individual MP page ----------------------------------------------------

#' Handle MP page
#'
#' @keywords internal

handle_mp_page <- function(mp_url, progress_bar) {
  Sys.sleep(2)
  progress_bar$tick()$print()
  mp_page <- xml2::read_html(mp_url) %>%
    rvest::html_nodes(xpath = '//*[@id="mainTextBlock"]/p') %>%
    rvest::html_text()
}

# Handle register date --------------------------------------------------------

#' Handle register date
#'
#' @keywords internal

handle_date <- function(contents_page) {
  date <- stringr::str_sub(contents_page, start = 51, end = 56) %>%
    as.Date(format = "%y %m %d")
}
