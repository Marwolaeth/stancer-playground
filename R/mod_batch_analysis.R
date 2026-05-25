#' batch_analysis UI Function
mod_batch_analysis_ui <- function(id, i18n) {
    ns <- NS(id)
    tagList(
        fluidRow(
            # Левая колонка: Загрузка и настройки
            column(
                width = 4,
                box(
                    title = i18n$t("Data Import"), width = NULL, status = "danger", solidHeader = TRUE,
                    uiOutput(ns("file_import_ui")),
                    actionButton(ns("load_example"), i18n$t("Use Example"),
                                 icon = icon("lightbulb"), class = "btn-default btn-sm"),
                    hr(),
                    uiOutput(ns("column_mapping_ui"))
                ),
                box(
                    title = i18n$t("Analysis Parameters"), width = NULL, status = "warning",
                    solidHeader = FALSE, collapsible = TRUE, collapsed = FALSE,
                    selectInput(
                        ns("lang"),
                        i18n$t("Analysis Language"),
                        choices = c("English" = "en", "Russian" = "ru")
                    ),
                    uiOutput(ns("domain_ui")),
                    uiOutput(ns("scale_ui")),
                    numericInput(
                        ns("n_rows"),
                        i18n$t("Number of rows to analyse"),
                        value = 6, min = 1, max = 20
                    )
                ),
                uiOutput(ns("batch_actions_ui"))
            ),
            # Правая колонка: Просмотр данных и результатов
            column(
                width = 8,
                box(
                    title = i18n$t("Data and Results"),
                    width = NULL, status = "info",
                    reactable::reactableOutput(ns("data_table"))
                ),
                uiOutput(ns("download_ui")),
                br(),
                uiOutput(ns("metrics_ui"))
            )
        )
    )
}

#' batch_analysis Server Functions
mod_batch_analysis_server <- function(id, settings_rx, i18n_r) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        tdf <- golem::get_golem_options("translations_df")

        output$file_import_ui <- renderUI({
            fileInput(
                ns("file_input"),
                label = i18n_r()$t("Upload Excel or CSV"),
                accept = c(".xlsx", ".xls", ".csv"),
                buttonLabel = i18n_r()$t("Browse..."),
                placeholder = as.character(
                    i18n_r()$t("No file selected")
                )
            )
        })

        # 1. Реактивное хранилище данных
        raw_data <- reactiveVal(NULL)

        # Загрузка файла
        observeEvent(input$file_input, {
            ext <- tools::file_ext(input$file_input$datapath)
            df <- if(ext == "csv") {
                readr::read_csv(input$file_input$datapath)
            } else {
                readxl::read_excel(input$file_input$datapath)
            }
            raw_data(df)
        })

        # Загрузка примера из пакета stancer
        observeEvent(input$load_example, {
            raw_data(stancer::programming_tweets)
        })

        # 2. Динамический интерфейс маппинга колонок
        output$column_mapping_ui <- renderUI({
            req(raw_data())
            cols <- colnames(raw_data())

            tagList(
                h4(i18n_r()$t("Column Mapping")),
                selectInput(
                    ns("col_text"),
                    i18n_r()$t("Text Column"),
                    choices = cols
                ),
                selectInput(
                    ns("col_target"),
                    i18n_r()$t("Target Column (Optional)"),
                    choices = c("-" = "", cols)
                ),
                textInput(
                    ns("manual_target"),
                    i18n_r()$t("Or Enter Manual Target"),
                    value = ""
                ),
                selectInput(
                    ns("col_true"),
                    i18n_r()$t("True Labels Column (Optional)"),
                    c("-" = "", cols)
                ),
                helpText(
                    i18n_r()$t("If True Labels are provided, scoring metrics will be available.")
                )
            )
        })

        output$domain_ui <- renderUI({
            current_domain <- isolate(input$domain)

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

        output$batch_actions_ui <- renderUI({
            req(raw_data())

            tagList(
                actionButton(
                    ns("run_batch"),
                    i18n_r()$t("Run Analysis"),
                    class = "btn-success btn-lg",
                    icon = icon("rocket"),
                    width = "100%"
                ),
                # Scoring button only active if true labels provided
                if (!is.null(input$col_true) && input$col_true != "") {
                    actionButton(
                        ns("run_score"),
                        i18n_r()$t("Calculate Metrics"),
                        class = "btn-info btn-block",
                        icon = icon("chart-line"),
                        style = "margin-top:12px;"
                    )
                }
            )
        })

        # 3. Анализ (Заглушка для интеграции с stancer)
        processed_data <- eventReactive(input$run_batch, {
            req(raw_data())
            df <- head(raw_data(), input$n_rows)

            # Здесь будет вызов stancer::llm_stance(df, ...)
            # Для примера добавим колонки имитации
            df$stance <- sample(c("Positive", "Neutral", "Negative"), nrow(df), replace = TRUE)
            df$explanation <- "Batch analysis explanation placeholder..."
            df
        })

        # 4. Отображение таблицы
        output$data_table <- reactable::renderReactable({
            display_df <- if (!is.null(processed_data())) processed_data() else raw_data()
            req(display_df)

            reactable::reactable(
                display_df,
                pagination = TRUE,
                highlight = TRUE,
                searchable = TRUE,
                language = reactable::reactableLang(
                    searchPlaceholder = i18n_r()$t("Search..."),
                    noData = i18n_r()$t("No data found")
                )
            )
        })

        # 5. Кнопка скачивания
        output$download_ui <- renderUI({
            req(processed_data())
            downloadButton(ns("download_results"), i18n_r()$t("Download Results (CSV)"), class = "btn-danger")
        })

        output$download_results <- downloadHandler(
            filename = function() { paste0("stancer-results-", Sys.Date(), ".csv") },
            content = function(file) { readr::write_csv(processed_data(), file) }
        )

        output$metrics_ui <- renderUI({
            req(metrics_data()) # Реактивное значение с результатами расчетов

            m <- metrics_data()

            fluidRow(
                infoBox(
                    i18n_r()$t("Accuracy"),
                    paste0(round(m$accuracy * 100, 1), "%"),
                    icon = icon("check"),
                    color = "green",
                    fill = TRUE,
                    width = 4
                ),
                infoBox(
                    i18n_r()$t("F1-Score"),
                    round(m$f1, 3),
                    icon = icon("bullseye"),
                    color = "purple",
                    fill = TRUE,
                    width = 4
                ),
                infoBox(
                    i18n_r()$t("Samples"),
                    m$n,
                    icon = icon("database"),
                    color = "blue",
                    fill = TRUE,
                    width = 4
                )
            )
        })

        metrics_data <- eventReactive(input$run_score, {
            # Здесь будет вызов функции из вашего пакета, например:
            # stancer::evaluate_performance(results_df, true_col = input$col_true, pred_col = "stance")

            # Мок-данные для демонстрации
            list(accuracy = 0.85, f1 = 0.824, n = input$n_rows)
        })

    })
}
