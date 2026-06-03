`%||%` <- function(x, y) if (is.null(x)) y else x

api_key <- function(key) {
    function() {
        list(Authorization = paste(
            'Bearer', key
        ))
    }
}

prepare_chat <- function(config, params = NULL) {
    ellmer::chat(
        name = paste(config$provider, config$model, sep = "/"),
        credentials = api_key(config$key),
        echo = "none",
        params = params
    )
}

# # pak::pak("tidyverse/ellmer")
# # pak::pak("Marwolaeth/stancer")
#
# library(stancer)
# library(ellmer)
#
# openrouter_key <- function() {
#     list(Authorization = paste(
#         'Bearer', Sys.getenv('OPENROUTER_API_KEY')
#     ))
# }
#
# chat <- chat_openrouter(
# #   model = 'nvidia/nemotron-3-super-120b-a12b:free', # Nice
#     model = 'openrouter/owl-alpha',
#     credentials = openrouter_key,
#     api_args = list(temperature = 0)
# )
#
# chat$chat("Hi")
