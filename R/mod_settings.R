#' settings UI Function
mod_settings_ui <- function(id, i18n) {
    ns <- NS(id)
    tagList(
        box(
            title = i18n$t("Interface Settings"), width = 6, status = "primary",

            # Выбор языка с флагами
            shinyWidgets::pickerInput(
                inputId = ns("selected_language"),
                label = i18n$t("UI Language"),
                choices = i18n$get_languages(),
                selected = i18n$get_key_translation(),
                choicesOpt = list(
                    content = c(
                        '<img src="https://flagcdn.com/w20/gb.png" width="20" style="margin-right: 10px;"/> English',
                        '<img src="https://flagcdn.com/w20/ru.png" width="20" style="margin-right: 10px;"/> Русский'
                    )
                ),
                options = shinyWidgets::pickerOptions(html = TRUE)
            ),

            hr(),
            p(i18n$t("More settings coming soon..."))
        )
    )
}

#' settings Server Functions
mod_settings_server <- function(id) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        # Language Observer
        # observeEvent(input$selected_language, {
        #     shiny.i18n::update_lang(
        #         input$selected_language,
        #         session = session
        #     )
        # })

        return(
            reactive({ input$selected_language })
        )
    })
}
