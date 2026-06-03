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
