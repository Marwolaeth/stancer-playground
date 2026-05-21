#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
    i18n <- golem::get_golem_options(which = "translator")
    i18n$set_translation_language("en")
    i18n$use_js()

    # keep track of language object as a reactive
    i18n_r <- reactive({
        i18n
    })

    ui_language <- mod_settings_server("settings_1")

    observeEvent(ui_language(), {
        shiny.i18n::update_lang(ui_language(), session = session)
        i18n_r()$set_translation_language(ui_language())

        showNotification(
            paste(i18n$t("Language changed to"), ui_language()),
            type = "message"
        )
    })

    # 2. Конфигурация LLM (Controlbar)
    # Переименовано из settings в config по вашей просьбе
    config <- mod_model_config_server("model_config_1", i18n_r)

    # 3. Модуль анализа одного текста
    # Передаем реактивный объект config, чтобы модуль знал параметры модели
    mod_single_analysis_server("single_analysis_1", config, i18n_r)

    # 4. Модуль пакетной обработки
    mod_batch_analysis_server("batch_analysis_1", config, i18n_r)
}
