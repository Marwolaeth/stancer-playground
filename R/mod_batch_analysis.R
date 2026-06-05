#' batch_analysis UI Function
mod_batch_analysis_ui <- function(id, i18n) {
    ns <- NS(id)
    tagList(
        fluidRow(
            # Left: Inputs & Settings ----
            column(
                width = 4,
                ## Load Data ----
                box(
                    title = i18n$t("Data Import"),
                    width = NULL, status = "danger", solidHeader = TRUE,
                    uiOutput(ns("file_import_ui")) |> with_helper("import"),
                    actionButton(
                        ns("load_example"),
                        i18n$t("Use Example"),
                        icon = icon("lightbulb"),
                        class = "btn-default btn-sm"
                    ),
                    hr(),
                    uiOutput(ns("column_mapping_ui"))
                ),
                ## Analysis Parameters ----
                box(
                    title = i18n$t("Analysis Parameters"),
                    width = NULL, status = "warning",
                    solidHeader = FALSE,
                    collapsible = TRUE, collapsed = FALSE,
                    selectInput(
                        ns("lang"),
                        i18n$t("Analysis Language"),
                        choices = c("English" = "en", "Russian" = "ru")
                    ) |>
                        with_helper("language"),
                    uiOutput(ns("domain_ui")),
                    uiOutput(ns("scale_ui")),
                    numericInput(
                        ns("n_rows"),
                        i18n$t("Number of rows to analyse"),
                        value = 6, min = 1, max = 20
                    ) |>
                        with_helper("limits")
                ),
                ## Actions ----
                uiOutput(ns("batch_actions_ui"))
            ),
            # Right: Data & Results ----
            column(
                width = 8,
                box(
                    title = fluidRow(
                        column(
                            12,
                            i18n$t("Data and Results"),
                        ) |> with_helper("results", style = "float:right;")
                    ),
                    width = NULL, status = "info",
                    reactable::reactableOutput(ns("data_table"))
                ),
                uiOutput(ns("download_ui")),
                br(),
                uiOutput(ns("metrics_ui")),
                uiOutput(ns("confusion_matrix_ui"))
            )
        )
    )
}

#' batch_analysis Server Functions
mod_batch_analysis_server <- function(id, settings_rx, i18n_r) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        tdf <- golem::get_golem_options("translations_df")

        # Inputs & Settings ----
        ## Load Data ----
        ### File Import ----
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

        #### Data Container ----
        raw_data <- reactiveVal(NULL)

        #### Import Button ----
        observeEvent(input$file_input, {
            ext <- tools::file_ext(input$file_input$datapath)
            df <- if(ext == "csv") {
                readr::read_csv(input$file_input$datapath)
            } else {
                readxl::read_excel(input$file_input$datapath)
            }
            raw_data(df)
        })

        ### Example Data ----
        observeEvent(input$load_example, {
            raw_data(stancer::programming_tweets)
        })

        ### Column Mapping ----
        output$column_mapping_ui <- renderUI({
            req(raw_data())
            cols <- colnames(raw_data())

            types <- c("object", "claim")
            type_labels <- sapply(types, function(x)
                as.character(i18n_r()$t(tools::toTitleCase(x))))
            names(types) <- type_labels

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
                    ns("col_type"),
                    i18n_r()$t("Target Type Column (Optional)"),
                    choices = c("-" = "", cols)
                ),
                selectInput(
                    ns("manual_type"),
                    i18n_r()$t("Or Select Target Type Manually"),
                    choices = types
                ),
                selectInput(
                    ns("col_true"),
                    i18n_r()$t("True Labels Column (Optional)"),
                    c("-" = "", cols)
                ),
                helpText(
                    i18n_r()$t(
                        "If True Labels are provided, scoring metrics will be available."
                    )
                )
            )
        })

        ## Settings ----
        ### Domain Roles ----
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

            # Translate using database, not i18n
            ## BC depends on analysis language, not UI language
            role_labels <- sapply(roles, function(x)
                tdf[x, input$lang]
            )
            names(roles) <- role_labels

            selectInput(
                ns("domain"),
                i18n_r()$t("Expert Domain"),
                choices = roles,
                selected = current_domain
            ) |>
                with_helper("domain")
        })

        ### Scales ----
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
            ) |>
                with_helper("scale")
        })

        # Actions ----
        output$batch_actions_ui <- renderUI({
            req(raw_data())

            tagList(
                ## Run Analysis ----
                actionButton(
                    ns("run_batch"),
                    i18n_r()$t("Run Analysis"),
                    class = "btn-success btn-lg",
                    icon = icon("rocket"),
                    width = "100%"
                ),
                # Score ----
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

        # Stance Analysis ----
        processed_data <- eventReactive(input$run_batch, {
            req(raw_data())
            df <- head(raw_data(), input$n_rows)

            # Safety Measures ----
            cfg <- settings_rx()

            # Temporary disable to prevent repeated clicks
            shinyjs::disable("run_batch")
            on.exit(shinyjs::enable("run_batch"))

            ## 1. Argument Mapping ----
            targets <- if (input$col_target != "") {
                df[[input$col_target]]
            } else {
                input$manual_target
            }

            types <- if (input$col_type != "") {
                df[[input$col_type]]
            } else {
                input$manual_type
            }

            # 2. Prepare Chat ----
            # Check API Key
            if (is.null(cfg$key)) {
                showNotification(
                    i18n_r()$t("API Key is missing!"),
                    type = "error"
                )
                return(empty_result(i18n_r()$t("API Key is missing!")))
            }

            params <- ellmer::params(temperature = 0)
            chat <- prepare_chat(cfg, params)

            # 3. Run Analysis ----
            withProgress(message = i18n_r()$t("Batch Analysis"), value = 0, {
                results_list <- list()
                n <- nrow(df)

                for (i in seq_len(n)) {
                    incProgress(
                        1/n, detail = paste(i18n_r()$t("Processing row"), i)
                    )

                    res <- tryCatch({
                        stancer::llm_stance(
                            df[[input$col_text]][i],
                            target = targets[i],
                            type = types[i],
                            chat_base = chat,
                            language = input$lang,
                            scale = input$scale,
                            domain_role = input$domain
                        )
                    },
                    error = function(e) {
                        showNotification(
                            paste(i18n_r()$t("Error during analysis:"), e$message),
                            type = "error"
                        )
                        return(empty_result(i18n_r()$t("Error during analysis")))
                    })

                    results_list[[i]] <- res$summary
                }

                # 4. Combine ----
               raw_data() |>
                    cbind(do.call(rbind, results_list))
            })

            # # stancer::llm_stance(df, ...)
            # df$stance <- sample(c("Positive", "Neutral", "Negative"), nrow(df), replace = TRUE)
            # df$explanation <- "Batch analysis explanation placeholder... This is a rather long explanation: the model tried to weigh all arguments."
            # # To be used with metric_f1()
            # attr(df, "scale") <- input$scale
            # df
        })

        # Data & Results ----
        ## Data Preview ----
        output$data_table <- reactable::renderReactable({
            display_df <- if (!is.null(processed_data())) processed_data() else raw_data()
            req(display_df)
            reactable::reactable(
                display_df,
                pagination = TRUE,
                highlight = TRUE,
                searchable = TRUE,
                paginationType = "simple",
                ### Columns ----
                defaultColDef = reactable::colDef(
                    searchable = FALSE, show = FALSE
                ),
                columns = stancer_columns(
                    input$col_text, input$col_true, input$col_target
                ),
                ### Labels ----
                language = reactable_lang(i18n_r)
            )
        })

        ### Download ----
        output$download_ui <- renderUI({
            req(processed_data())
            downloadButton(
                ns("download_results"),
                i18n_r()$t("Download Results (CSV)"),
                class = "btn-danger"
            )
        })

        output$download_results <- downloadHandler(
            filename = function() {
                paste0("stancer-results-", Sys.Date(), ".csv")
            },
            content = function(file) {
                readr::write_csv(processed_data(), file)
            }
        )

        ## Metrics ----
        ### Display Metrics ----
        output$metrics_ui <- renderUI({
            req(evaluation_results()) # Reactive

            m <- evaluation_results()

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

        ### Display Confusion Matrix ----
        output$confusion_matrix_ui <- renderUI({
            res <- evaluation_results()

            box(
                title = fluidRow(
                    column(
                        12,
                        i18n_r()$t("Confusion Matrix"),
                    ) |> with_helper("metrics", style = "float:right;")
                ),
                width = NULL,
                status = "info",
                footer = i18n_r()$t(
                    "Rows: True Labels | Columns: Predicted Labels"
                ),
                reactable::reactable(
                    as.data.frame.matrix(t(res$cm)),
                    bordered = TRUE,
                    compact = TRUE,
                    filterable = FALSE,
                    searchable = FALSE,
                    sortable = FALSE,
                    resizable = FALSE,
                    defaultColDef = reactable::colDef(
                        align = "center",
                        headerStyle = list(background = "#f7f7f8"),
                        # Cell colouring
                        style = function(value, index, name) {
                            if (!is.numeric(value) || is.na(value)) return()
                            true <- as.data.frame(
                                t(res$cm))$Actual[index]
                            is_diagonal <- (true == name)

                            scaled <- (value - min(res$cm)) /
                                (max(res$cm) - min(res$cm))
                            if (is_diagonal) {
                                # Green colours for true predictions
                                colour <- grDevices::rgb(
                                    colorRamp(
                                        c("#ffffff", "#d4edda", "#28a745")
                                    )(scaled),
                                    maxColorValue = 255)
                            } else {
                                # Red colours for mistakes
                                # If zero mistakes, white
                                if (value == 0) {
                                    colour <- "#ffffff"
                                } else {
                                    colour <- grDevices::rgb(
                                        colorRamp(
                                            c("#ffffff", "#f8d7da", "#dc3545")
                                        )(scaled),
                                        maxColorValue = 255
                                    )
                                }
                            }

                            list(
                                background = colour,
                                fontWeight = "bold",
                                color = if(scaled > 0.5) "white" else "black"
                            )
                        }
                    )
                )
            )
        })

        ### Calculate Metrics ----
        evaluation_results <- eventReactive(input$run_score, {
            req(processed_data())
            req(input$col_true, input$col_true != "")
            df <- processed_data()

            cm <- cm(
                df$stance, df[[input$col_true]],
                scale = attr(df, "scale")
            )
            acc <- metric_accuracy(
                df$stance, df[[input$col_true]]
            ) |> round(3)

            f1 <- metric_f1(cm) |> round(3)

            list(accuracy = acc, f1 = f1, cm = cm, n = nrow(df))
        })

    })
}
