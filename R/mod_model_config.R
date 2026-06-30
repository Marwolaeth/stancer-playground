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
            ) |> with_helper("model-provider"),
            textInput(
                ns("model_name"),
                i18n$t("Model Name"),
                value = "google/gemini-2.0-flash-001"
            ) |> with_helper("model-name"),

            passwordInput(
                ns("api_key"),
                i18n$t("API Key"),
                placeholder = "sk-..."
            ) |> with_helper("model-key"),

            checkboxInput(
                ns("save_cookie"),
                i18n$t("Save key in cookies"),
                value = FALSE
            ),

            uiOutput(ns("key_status")),

            hr(),
            actionButton(
                ns("test_conn"),
                i18n$t("Test Connection"),
                class = "btn-info",
                width = "100%"
            ),
            shiny::br(),
            shiny::br(),
            shiny::br(),
            uiOutput(ns("conn_status")) |> with_red_spinner(
                caption = i18n$t("Testing Connection..."),
                size = 0.4
            )
        )
    )
}

#' model_config Server Functions
mod_model_config_server <- function(id, i18n) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        # 1. Load API Key from Cookies on start ----
        observeEvent(get_cookie("stancer_api_key"), {
            updateTextInput(session, "api_key", value = get_cookie("stancer_api_key"))
            updateCheckboxInput(session, "save_cookie", value = TRUE)
        }, once = TRUE)

        # 2. Save to Cookies (if enabled) ----
        observe({
            if (input$save_cookie && nchar(input$api_key) > 0) {
                set_cookie("stancer_api_key", input$api_key)
            } else if (!input$save_cookie) {
                remove_cookie("stancer_api_key")
            }
        })

        # 3. API Key Status (Priority: Sys.env > Input) ----
        output$key_status <- renderUI({
            env_var_name <- paste0(toupper(input$provider), "_API_KEY")
            has_env <- nchar(Sys.getenv(env_var_name)) > 0

            if (has_env) {
                span(icon("check-circle"),
                     i18n()$t("Using System Environment Key"),
                     style = "color: green; font-size: 0.8em;"
                )
            } else if (nchar(input$api_key) > 0) {
                span(icon("key"),
                     i18n()$t("Using Manual Key"),
                     style = "color: orange; font-size: 0.8em;"
                )
            } else {
                span(icon("exclamation-triangle"),
                     i18n()$t("No Key Detected"),
                     style = "color: red; font-size: 0.8em;"
                )
            }
        })

        # 4. Test Connection ----
        conn_status_flag <- eventReactive(input$test_conn, {
            req(input$model_name)

            # Get API Key
            env_var_name <- paste0(toupper(input$provider), "_API_KEY")
            env_key <- Sys.getenv(env_var_name)

            # Test the current config before returning
            config <- list(
                provider = input$provider,
                model = input$model_name,
                key = if (nchar(input$api_key) > 0)
                    input$api_key
                else
                    env_key
            )
            chat <- prepare_chat(config, ellmer::params(max_tokens = 2))

            tryCatch({
                res <- chat$chat("Respond with '1'", echo = "none")
                # If character, the result is valid
                is.character(res) && nchar(res) > 0
            }, error = function(e) {
                message("Connection test failed: ", e$message)
                FALSE
            })
        })

        output$conn_status <- renderUI({
            req(is.logical(conn_status_flag()))

            if (conn_status_flag()) {
                span(icon("check-circle"),
                     "Ok",
                     style = "color: green; font-size: 1.2em;"
                )
            } else {
                span(icon("exclamation-triangle"),
                     i18n()$t("Error"),
                     style = "color: red; font-size: 1.2em;"
                )
            }
        })

        # Return Reactive with configuration
        reactive({
            list(
                provider = input$provider,
                model = input$model_name,
                key = if (nchar(input$api_key) > 0)
                    input$api_key
                else
                    Sys.getenv(paste0(toupper(input$provider), "_API_KEY"))
            )
        })
    })
}
