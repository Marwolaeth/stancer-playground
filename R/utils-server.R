`%||%` <- function(x, y) if (is.null(x)) y else x

api_key <- function(key) {
    function() {
        list(Authorization = paste(
            'Bearer', key
        ))
    }
}

prepare_chat <- function(config, params = NULL) {
    if (tolower(config$provider) == "yandex") {
        chat <- ellmer::chat_openai_compatible(
            base_url = "https://llm.api.cloud.yandex.net/v1",
            name = "Yandex",
            credentials = api_key(config$key),
            model = glue::glue("gpt://{config$project_id}/{config$model}"),
            api_headers = c(
                "OpenAI-Project" = config$project_id
            ),
            echo = "none",
            params = params
        )
    } else {
        chat <- ellmer::chat(
            name = paste(config$provider, config$model, sep = "/"),
            credentials = api_key(config$key),
            echo = "none",
            params = params
        )
    }

    chat
}

empty_result <- function(msg) {
    list(
        summary = data.frame(
            text = "NA",
            target = "NA",
            target_type = NA,
            language = NA,
            stance = "NA",
            explanation = msg
        )
    )
}
