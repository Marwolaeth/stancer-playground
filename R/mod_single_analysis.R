#' single_analysis UI Function
mod_single_analysis_ui <- function(id, i18n) {
    ns <- NS(id)

    tagList(fluidRow(
        column(
            width = 8,
            box(
                title = i18n$t("Input Text"),
                width = NULL,
                status = "primary",
                solidHeader = TRUE,
                textAreaInput(
                    ns("text"),
                    i18n$t("Text to analyse"),
                    rows = 5,
                    placeholder = i18n$t("Enter text here...")$children[[1]]
                ),
                fluidRow(column(
                    6, textInput(ns("target"), i18n$t("Target of analysis"), value = "R language")
                ), column(
                    6, selectInput(
                        ns("lang"),
                        i18n$t("Language"),
                        choices = c(
                            "English" = "en",
                            "Russian" = "ru"
                        )
                    )
                )),
                actionButton(
                    ns("run"),
                    i18n$t("Analyse"),
                    class = "btn-success btn-lg",
                    icon = icon("play")
                )
            ),
            # Поле для объяснения (Explanation)
            uiOutput(ns("explanation_ui"))
        ),
        column(
            width = 4,
            box(
                title = i18n$t("Settings"),
                width = NULL,
                status = "warning",
                shinyWidgets::pickerInput(
                    ns("domain"),
                    i18n$t("Expert Domain"),
                    choices = c(
                        "General Expert",
                        "Sociologist",
                        "Psychologist",
                        "Computer Scientist",
                        "Programmer",
                        "Political Scientist"
                    ),
                    choicesOpt = list(
                        content = sapply(
                            list(
                                i18n$t("General Expert"),
                                i18n$t("Sociologist"),
                                i18n$t("Psychologist"),
                                i18n$t("Computer Scientist"),
                                i18n$t("Programmer"),
                                i18n$t("Political Scientist")
                            ),
                            as.character
                        )
                    ),
                    options = shinyWidgets::pickerOptions(html = TRUE)
                ),
                shinyWidgets::pickerInput(
                    ns("scale"),
                    i18n$t("Sentiment Scale"),
                    choices = c(
                        "Categorical" = "categorical",
                        "Likert" = "likert",
                        "Numeric" = "numeric"
                    ),
                    choicesOpt = list(
                        content = sapply(
                            list(
                                i18n$t("Categorical"),
                                i18n$t("Likert"),
                                i18n$t("Numeric")
                            ),
                            as.character
                        )
                    ),
                    options = shinyWidgets::pickerOptions(html = TRUE)
                )
            ),
            # Финальный результат (Gauge или Label)
            valueBoxOutput(ns("stance_box"), width = NULL)
        )
    ))
}

#' single_analysis Server Functions
mod_single_analysis_server <- function(id, settings_rx, i18n) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        # Реактивное значение для хранения результата
        result <- eventReactive(input$run, {
            req(input$text, input$target)

            # Интеграция с вашим пакетом stancer
            # Здесь мы создаем объект чата на основе настроек из controlbar
            cfg <- settings_rx()

            # В реальном приложении здесь будет вызов:
            # chat <- ellmer::chat_vignette(model = cfg$model, api_key = cfg$key)
            # (или аналогичный провайдер)

            # Для демонстрации логики возвращаем мок-объект,
            # имитирующий структуру stance_result
            list(stance = "Agree",
                 explanation = "The text expresses strong positive sentiment towards R's tidyverse ecosystem, highlighting its efficiency in data manipulation.")
        })

        output$stance_box <- renderValueBox({
            res <- result()
            valueBox(
                res$stance,
                i18n()$t("Detected Stance"),
                icon = icon("balance-scale"),
                color = "green"
            )
        })

        output$explanation_ui <- renderUI({
            res <- result()
            box(
                title = i18n()$t("Reasoning & Explanation"),
                width = NULL,
                status = "info",
                p(res$explanation, style = "font-style: italic; font-size: 1.1em; color: #2c3e50;")
            )
        })
    })
}
