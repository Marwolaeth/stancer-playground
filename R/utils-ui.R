i18n. <- function(translator, key) {
    stopifnot(R6::is.R6(translator) && "Translator" %in% class(translator))
    t <- translator$clone(deep = FALSE)
    translation <- t$t(key)
    if (is.list(translation)) translation <- translation$children[[1]]
    translation
}

# t. <- function(key, language, translations) {
#     value <- translations[key, language]
#     ifelse(is.na(value), key, value)
# }
