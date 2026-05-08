#' batch_analysis UI Function
mod_batch_analysis_ui <- function(id) {
    ns <- NS(id)
    tagList(
        fluidRow(
            # Левая колонка: Загрузка и настройки
            column(
                width = 4,
                box(
                    title = i18n$t("Data Import"), width = NULL, status = "primary", solidHeader = TRUE,
                    fileInput(
                        ns("file_input"),
                        i18n$t("Upload Excel or CSV"),
                        accept = c(".xlsx", ".xls", ".csv"),
                        buttonLabel = i18n$t("Browse..."),
                        placeholder = i18n$t("No file selected"),
                    ),
                    actionButton(ns("load_example"), i18n$t("Use Example"),
                                 icon = icon("lightbulb"), class = "btn-default btn-sm"),
                    hr(),
                    uiOutput(ns("column_mapping_ui"))
                ),
                box(
                    title = i18n$t("Batch Settings"), width = NULL, status = "warning",
                    numericInput(ns("n_rows"), i18n$t("Number of rows to analyse"), value = 6, min = 1, max = 20),
                    actionButton(ns("run_batch"), i18n$t("Start Batch Analysis"),
                                 class = "btn-success btn-lg", icon = icon("play-circle"), width = "100%")
                )
            ),
            # Правая колонка: Просмотр данных и результатов
            column(
                width = 8,
                box(
                    title = i18n$t("Data Preview & Results"), width = NULL, status = "info",
                    reactable::reactableOutput(ns("data_table"))
                ),
                uiOutput(ns("download_ui"))
            )
        )
    )
}

#' batch_analysis Server Functions
mod_batch_analysis_server <- function(id, settings_rx) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

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
                h4(i18n$t("Column Mapping")),
                selectInput(ns("col_text"), i18n$t("Text Column"), choices = cols),
                selectInput(ns("col_target"), i18n$t("Target Column (Optional)"),
                            choices = c("-" = "", cols)),
                textInput(ns("manual_target"), i18n$t("Or Enter Manual Target"), value = "")
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
                    searchPlaceholder = i18n$t("Search..."),
                    noData = i18n$t("No data found")
                )
            )
        })

        # 5. Кнопка скачивания
        output$download_ui <- renderUI({
            req(processed_data())
            downloadButton(ns("download_results"), i18n$t("Download Results (CSV)"), class = "btn-primary")
        })

        output$download_results <- downloadHandler(
            filename = function() { paste0("stancer-results-", Sys.Date(), ".csv") },
            content = function(file) { readr::write_csv(processed_data(), file) }
        )
    })
}
