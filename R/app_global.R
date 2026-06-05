# options(ellmer_timeout_s = 120000000)

translations <- jsonlite::read_json(
    path = "inst/app/www/translations.json",
    simplifyDataFrame = TRUE
)$translation
row.names(translations) <- translations[["en"]]
