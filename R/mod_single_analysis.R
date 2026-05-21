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
                # Dynamic text input
                uiOutput(ns("text_input_ui")),

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
            uiOutput(ns("explanation_ui"))
        ),
        column(
            width = 4,
            box(
                title = i18n$t("Settings"),
                width = NULL,
                status = "warning",
                # Dynamic select
                uiOutput(ns("domain_ui")),
                uiOutput(ns("scale_ui"))
            ),
            valueBoxOutput(ns("stance_box"), width = NULL)
        )
    ))
}

#' single_analysis Server Functions
mod_single_analysis_server <- function(id, settings_rx, i18n_r) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        tdf <- golem::get_golem_options("translations_df")
        # 1. Динамический textAreaInput (реагирует на i18n_r)
        output$text_input_ui <- renderUI({
            # Сохраняем текущее значение, чтобы не стереть его при смене языка
            current_val <- isolate(input$text) %||% ""

            textAreaInput(
                ns("text"),
                i18n_r()$t("Text to analyse"),
                value = current_val,
                rows = 5,
                placeholder = as.character(
                    i18n_r()$t("Enter text here...")
                )
            )
        })

        # 2. Динамический Domain (зависит от языка АНАЛИЗА input$lang)
        output$domain_ui <- renderUI({
            # Сохраняем выбор
            current_domain <- isolate(input$domain)

            # Определяем список ролей в зависимости от выбранного языка анализа
            # Здесь можно добавить логику перевода самих терминов ролей
            roles <- c(
                "General Expert",
                "Sociologist",
                "Psychologist",
                "Computer Scientist",
                "Programmer",
                "Political Scientist"
            )

            # Переводим лейблы ролей через i18n_r
            role_labels <- sapply(roles, function(x)
                tdf[x, input$lang]
            )
            names(roles) <- role_labels

            selectInput(
                ns("domain"),
                i18n_r()$t("Expert Domain"),
                choices = roles,
                selected = current_domain
            )
        })

        # 3. Динамическая шкала (реагирует на i18n_r)
        output$scale_ui <- renderUI({
            current_scale <- isolate(input$scale)

            scales <- c("categorical", "likert", "numeric")
            scale_labels <- sapply(scales, function(x)
                as.character(i18n_r()$t(tools::toTitleCase(x))))
            names(scales) <- scale_labels

            selectInput(
                ns("scale"),
                i18n_r()$t("Sentiment Scale"),
                choices = scales,
                selected = current_scale
            )
        })

        # Логика анализа
        result <- eventReactive(input$run, {
            req(input$text, input$target)
            cfg <- settings_rx()

            # Имитация вызова stancer
            list(stance = "Agree", explanation = "The text expresses strong positive sentiment towards R's tidyverse ecosystem.")
        })

        output$stance_box <- renderValueBox({
            res <- result()
            valueBox(
                res$stance,
                i18n_r()$t("Detected Stance"),
                icon = icon("balance-scale"),
                color = "green"
            )
        })

        output$explanation_ui <- renderUI({
            res <- result()
            box(
                title = i18n_r()$t("Reasoning & Explanation"),
                width = NULL,
                status = "info",
                p(res$explanation, style = "font-style: italic; font-size: 1.1em; color: #2c3e50;")
            )
        })
    })
}
