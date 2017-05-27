# devtools::install_github("rpremraj/mailR") # wymaga instalacji Java

library(dplyr)
library(knitr)
library(mailR)
library(rmarkdown)
# library(readr)
# library(tidyr)

# Parametry poczty
from <- "user@domena.dom"
subject <- "Temat"
smtp <- list(host.name = "Adres servera SMTP",
             port = 465,
             user.name = "Użytkownik",
             passwd = "Hasło",
             ssl = TRUE)

# Dane z Google Spreadsheet na podstawie Google Forms
# File -> Download as -> csv
spreadsheet <- readr::read_csv("ścieżka/do/spreadsheet.csv")

for (i in 1:nrow(spreadsheet)) {
  rmarkdown::render(input = "mail_content.Rmd",
                    output_format = "html_document",
                    output_file = paste0(
                      paste(spreadsheet[i, ]$Nazwisko,
                            spreadsheet[i, ]$Imię,
                            sep = "_"),
                      ".html"),
                    output_dir = "email",
                    params = list(form = spreadsheet[i, ]),
                    encoding = "utf-8")
  
  email <- mailR::send.mail(from = from,
                            to = spreadsheet[i, ]$email,
                            subject = subject,
                            body = "docs/mail_content.html",
                            encoding = "utf-8",
                            html = TRUE,
                            smtp = smtp,
                            authenticate = TRUE,
                            send = FALSE)
  
  email$send() # ewentualnie wyżej send = TRUE
}