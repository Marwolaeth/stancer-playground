#' single_analysis UI Function
mod_single_analysis_ui <- function(id, i18n) {
    ns <- NS(id)
    tagList(fluidRow(
        column(
            width = 8,
            box(
                title = i18n$t("Input Text"),
                width = NULL,
                status = "danger",
                solidHeader = TRUE,
                # Dynamic text input
                uiOutput(ns("text_input_ui")) |> with_helper("text"),

                fluidRow(
                    column(
                        4,
                        textInput(
                            ns("target"),
                            i18n$t("Target of analysis"),
                            value = "R language"
                        ) |> with_helper("target")
                    ),
                    column(
                        4,
                        uiOutput(ns("type_ui")) |> with_helper("type")
                    ),
                    column(
                        4,
                        selectInput(
                            ns("lang"),
                            i18n$t("Analysis Language"),
                            choices = c(
                                "English" = "en",
                                "Russian" = "ru"
                            )
                        )|> with_helper("language")
                    )
                ),
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
                uiOutput(ns("domain_ui")) |> with_helper("domain"),
                uiOutput(ns("scale_ui")) |> with_helper("scale")
            ),
            valueBoxOutput(ns("stance_box"), width = NULL) |>
                with_red_spinner()
        )
    ))
}

#' single_analysis Server Functions
mod_single_analysis_server <- function(id, settings_rx, i18n_r) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        tdf <- golem::get_golem_options("translations_df")
        # 1. Dynamic textAreaInput ----
        output$text_input_ui <- renderUI({
            # The current value
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

        # 2. Dynamic target type labels ----
        output$type_ui <- renderUI({
            current_type <- isolate(input$type)

            types <- c("object", "claim")
            type_labels <- sapply(types, function(x)
                as.character(i18n_r()$t(tools::toTitleCase(x))))
            names(types) <- type_labels

            selectInput(
                ns("type"),
                i18n_r()$t("Target Type"),
                choices = types,
                selected = current_type
            )
        })

        # 3. Dynamic Domain (depends on input$lang) ----
        output$domain_ui <- renderUI({
            # The current value
            current_domain <- isolate(input$domain)

            roles <- c(
                "General Expert",
                "Sociologist",
                "Psychologist",
                "Computer Scientist",
                "Programmer",
                "Political Scientist"
            )

            # Translate labels
            role_labels <- sapply(roles, function(x)
                tdf[x, input$lang]
            )
            roles <- role_labels
            names(roles) <- role_labels

            selectInput(
                ns("domain"),
                i18n_r()$t("Expert Domain"),
                choices = roles,
                selected = current_domain
                # options = list(create = TRUE, addPrecedence = FALSE)
            )
        })

        # 4. Dynamic scale labels ----
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

        # The Analysis ----
        result <- eventReactive(input$run, {
            req(input$text, input$target)
            cfg <- settings_rx()
            params <- ellmer::params(temperature = 0)

            # Call stancer
            chat <- prepare_chat(cfg, params)

            stancer::llm_stance(
                input$text,
                target = input$target,
                chat_base = chat,
                type = input$type,
                language = input$lang,
                scale = input$scale,
                domain_role = input$domain
            )
        })

        # Output ----
        output$stance_box <- renderValueBox({
            res <- result()
            stance <- res$summary$stance

            valueBox(
                stance,
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
                p(
                    res$summary$explanation,
                    style = "font-style: italic; font-size: 1.1em; color: #2c3e50;"
                )
            )
        })
    })
}
