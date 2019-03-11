### Functions for downloading the Register of Members' Financial Interests

# Cache -----------------------------------------------------------------------

cache <- new.env(parent = emptyenv())

# Cache MP interests ----------------------------------------------------------

#' Download Register of Members' Financial Interests
#'
#' \code{download_mpinterests} scrapes entries in the Register of Members'
#' Financial Interests for each MP. There is no need to assign when calling
#' {download_mpinterests}, although if you do the returned objected is a raw
#' list of the entries.
#'
#' @param contents_page A character string of the contents page URL
#' for an edition of the Register of Members' Financial Interests.
#' @return NULL
#' @export

download_mpinterests <- function(contents_page) {
  urls <- handle_mp_urls(contents_page)
  date <- handle_date(contents_page)
  progress_bar <- dplyr::progress_estimated(nrow(urls))
  interests <- purrr::map(urls$mp_urls, handle_mp_page, progress_bar)
  assign(CACHE_DATE, date, envir = cache)
  assign(CACHE_INTERESTS, interests, envir = cache)
}

#' Get the cached Register of Members' Financial Interests
#'
#' \code{get_cache} gets the downloaded Register of Members' Financial
#' Interests which is used in all get_* functions.
#'
#' @return The cached Register of Members' Financial Interests as a list
#' @keywords internal

get_downloaded_mpinterests <- function(get = c("interests", "date")) {
  if (! exists(CACHE_INTERESTS, envir = cache)) {
    stop(paste("The Register of Members' Financial Interests has not been",
               "downloaded: use download_mpinterests"))
  }
  if (get == "interests") {
  get(CACHE_INTERESTS, envir = cache)
  } else {
    get(CACHE_DATE, envir = cache)
  }
}
