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
                with_red_spinner(
                    caption = i18n$t("Analysis in progress..."),
                    size = 1.1
                )
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

            # Temporary disable to prevent repeated clicks
            shinyjs::disable("run")
            on.exit(shinyjs::enable("run"))

            # Check API Key
            if (is.null(cfg$key)) {
                showNotification(
                    i18n_r()$t("API Key is missing!"),
                    type = "error"
                )
                return(empty_result(i18n_r()$t("API Key is missing!")))
            }

            params <- ellmer::params(temperature = 0)

            # Call stancer
            chat <- prepare_chat(cfg, params)

            tryCatch({
                stancer::llm_stance(
                    input$text,
                    target = input$target,
                    chat_base = chat,
                    type = input$type,
                    language = input$lang,
                    scale = input$scale,
                    domain_role = input$domain
                )
            }, error = function(e) {
                showNotification(
                    paste(i18n_r()$t("Error during analysis:"), e$message),
                    type = "error"
                )
                return(empty_result(i18n_r()$t("Error during analysis")))
            }) #|>
                # shiny::bindCache(
                #     input$text, input$target, input$scale, input$domain,
                #     settings_rx()
                # )
            # stance <- sample(
            #     c(
            #         "Positive", "Neutral", "Negative",
            #         "Strongly Agree", "Agree", "Disagree", "Strongly Disagree",
            #         "NA"
            #     ),
            #     size = 1
            # )
            # list(summary = data.frame(stance = stance, explanation = "Y"))
        })

        # Output ----
        ## Stance Box ----
        output$stance_box <- renderValueBox({
            res <- result()
            req(res)
            stance <- res$summary$stance

            valueBox(
                i18n_r()$t(as.character(stance)),
                i18n_r()$t("Detected Stance"),
                icon = icon("balance-scale"),
                color = stance_colour_dashboard(stance)
            )
        })

        ## Explanation & Analysis ----
        output$explanation_ui <- renderUI({
            res <- result()
            req(res)

            current_status <- stance_status(res$summary$stance)

            box(
                title = i18n_r()$t("Analysis Details"),
                width = NULL,
                status = current_status,
                solidHeader = FALSE,

                tabsetPanel(
                    id = ns("explanation_tabs"),
                    type = "tabs",

                    # 1. Result Explanation
                    tabPanel(
                        title = tagList(
                            icon("info-circle"),
                            i18n_r()$t("Reasoning & Explanation")
                        ),
                        shiny::br(),
                        p(
                            res$summary$explanation,
                            style = "font-style: italic; font-size: 1.1em; color: #2c3e50; padding: 10px;"
                        )
                    ),

                    # 2. Expert Analysis
                    tabPanel(
                        title = tagList(icon("users"), i18n_r()$t("Experts")),
                        shiny::br(),
                        tags$ul(
                            style = "list-style-type: none; padding-left: 0;",
                            tags$li(
                                shiny::h1(i18n_r()$t("Linguistic Analysis")),
                                shiny::br(),
                                shiny::markdown(res$analysis$linguistic)
                            ),
                            tags$hr(),
                            tags$li(
                                shiny::h1(
                                    i18n_r()$t("Social Media Interpretation")
                                ),
                                shiny::br(),
                                shiny::markdown(res$analysis$social_media)
                            ),
                            tags$hr(),
                            tags$li(
                                shiny::h1(paste0(input$domain, ":")),
                                shiny::br(),
                                shiny::markdown(res$analysis$domain)
                            )
                        )
                    ),

                    # 3. Debates
                    tabPanel(
                        title = tagList(icon("comments"), i18n_r()$t("Debates")),
                        shiny::br(),
                        fluidRow(
                            column(4,
                                   tags$div(
                                       style = "border-left: 3px solid green; padding-left: 10px;",
                                       strong(
                                           i18n_r()$t("Positive")
                                       ),
                                       tags$div(
                                           shiny::markdown(
                                               res$debates$positive
                                           ),
                                           style = "font-size: 0.9em;"
                                       )
                                   )
                            ),
                            column(4,
                                   tags$div(
                                       style = "border-left: 3px solid gray; padding-left: 10px;",
                                       strong(
                                           i18n_r()$t("Neutral")
                                       ),
                                       tags$div(
                                           shiny::markdown(
                                               res$debates$neutral
                                           ),
                                           style = "font-size: 0.9em;"
                                       )
                                   )
                            ),
                            column(4,
                                   tags$div(
                                       style = "border-left: 3px solid red; padding-left: 10px;",
                                       strong(
                                           i18n_r()$t("Negative")
                                       ),
                                       tags$div(
                                           shiny::markdown(
                                               res$debates$negative
                                           ),
                                           style = "font-size: 0.9em;"
                                       )
                                   )
                            )
                        )
                    )
                )
            )
        })
    })
}
