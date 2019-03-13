# mpinterests
mpinterests offers a suite of functions for web scraping data contained within the House of Commons' "Register of Members' Financial Interests" (RMFI). Each available function in the package focuses on scraping data under one of the specified categories in the RMFI. 

## Overview
According to [Parliament](https://www.parliament.uk/mps-lords-and-offices/standards-and-financial-interests/parliamentary-commissioner-for-standards/registers-of-interests/register-of-members-financial-interests/) the "main purpose of the Register [RMFI] is to provide information about any financial interest which a Member has, or any benefit which he or she receives, which others might reasonably consider to influence his or her actions or words as a Member of Parliament." The RMFI is published both as a web page and a PDF document. A guide to the rules on the RMFI is available [here](https://publications.parliament.uk/pa/cm201516/cmcode/1076/107601.htm).

## Usage
The package provides one primary function to web scrape the RMFI: ```download_mpinterests```. The scraped data is stored as a list in a seperate environment, although if you wanted to inspect the raw data you can assign the returned list as local variable when calling the function. You need to call ```download_mpinterests``` first, by providing it with the URL of the RMFI contents page of interest, before calling any secondary function.

The secondary functions are all prefixed ```get_*``` and return tibbles based on the ten categories as defined in the RMFI rules where each row is one entry. For example, ```get_employment_and_earnings``` returns a tibble of all the entries under "Category 1: Employment and earnings". Sometimes there will be NAs introduced to the returned tibbles even if there is an entry for an MP; this is usually going to be due to inconsistencies in the MPs' web page HTML - see testing and reliability for further information.

The package is intended to work with the RFMI of the 2015-16 session and after. The RMFIs for sessions before 2015-16 are structured in a fundamentally different way.

## Example
![](mpinterests.gif)

## Testing and reliability
This package has **not** undergone any formal unit testing. This is deliberate as unit testing implies a certain level of guaranteed performance. As the RMFI is only available through a web page or a PDF, both of which are produced by hand for each edition, it is not possible to ensure that the package will perform as expected for any given edition of the RMFI. For example, there only needs to be one change in a page as a resut of human error for functions not to return the expected results. There is no guarantee that the package will continue to work for all future editions of the RMFI.

## Installation
Install from GitHub using devtools.
```
install.packages("devtools")
devtools::install_github("dempseynoel/mpinterests")
```
