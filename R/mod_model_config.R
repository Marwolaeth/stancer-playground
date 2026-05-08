#' model_config UI Function
mod_model_config_ui <- function(id, i18n) {
    ns <- NS(id)
    tagList(
        div(
            style = "padding: 15px;",
            h4(i18n$t("LLM Provider")),
            selectInput(
                ns("provider"),
                i18n$t("Select Provider"),
                choices = c(
                    "OpenRouter" = "openrouter",
                    "Anthropic" = "anthropic",
                    "OpenAI" = "openai",
                    "Mistral" = "mistral",
                    "OpenAI-compatible" = "openai-compatible"
                )
            ),
            textInput(ns("model_name"), i18n$t("Model Name"), value = "google/gemini-2.0-flash-001"),

            passwordInput(ns("api_key"), i18n$t("API Key"), placeholder = "sk-..."),

            checkboxInput(ns("save_cookie"), i18n$t("Save key in cookies"), value = FALSE),

            uiOutput(ns("key_status")),

            hr(),
            actionButton(
                ns("test_conn"),
                i18n$t("Test Connection"),
                class = "btn-info",
                width = "100%"
            )
        )
    )
}

#' model_config Server Functions
mod_model_config_server <- function(id, i18n) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        # 1. Загрузка ключа из Cookies при старте
        observeEvent(get_cookie("stancer_api_key"), {
            updatePasswordInput(session, "api_key", value = get_cookie("stancer_api_key"))
            updateCheckboxInput(session, "save_cookie", value = TRUE)
        }, once = TRUE)

        # 2. Сохранение в Cookies при изменении (если чекбокс активен)
        observe({
            if (input$save_cookie && nchar(input$api_key) > 0) {
                set_cookie("stancer_api_key", input$api_key)
            } else if (!input$save_cookie) {
                remove_cookie("stancer_api_key")
            }
        })

        # 3. Статус ключа (Приоритет: Sys.env > Input)
        output$key_status <- renderUI({
            env_var_name <- paste0(toupper(input$provider), "_API_KEY")
            has_env <- nchar(Sys.getenv(env_var_name)) > 0

            if (has_env) {
                span(icon("check-circle"),
                     i18n$t("Using System Environment Key"),
                     style = "color: green; font-size: 0.8em;"
                    )
            } else if (nchar(input$api_key) > 0) {
                span(icon("key"),
                     i18n$t("Using Manual Key"),
                     style = "color: orange; font-size: 0.8em;"
                    )
            } else {
                span(icon("exclamation-triangle"),
                     "No Key Detected",
                     style = "color: red; font-size: 0.8em;"
                    )
            }
        })

        # Возвращаем реактивный объект с настройками чата
        reactive({
            list(
                provider = input$provider,
                model = input$model_name,
                key = if (nchar(input$api_key) > 0)
                    input$api_key
                else
                    NULL
            )
        })
    })
}
