i18n. <- function(translator, key) {
  stopifnot(R6::is.R6(translator) && "Translator" %in% class(translator))
  t <- translator$clone(deep = TRUE)
  translation <- t$t(key)
  translation$children[[1]]
}
