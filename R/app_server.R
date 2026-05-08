#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

    # 1. Модуль настроек (Язык интерфейса)
    # Мы не передаем i18n внутрь, так как update_lang работает глобально для сессии
    current_user_lang <- mod_settings_server("settings_1")

    # 2. Конфигурация LLM (Controlbar)
    # Переименовано из settings в config по вашей просьбе
    config <- mod_model_config_server("model_config_1")

    # 3. Модуль анализа одного текста
    # Передаем реактивный объект config, чтобы модуль знал параметры модели
    mod_single_analysis_server("single_analysis_1", config)

    # 4. Модуль пакетной обработки
    mod_batch_analysis_server("batch_analysis_1", config)

    # Дополнительно: можно добавить уведомление при смене языка
    observeEvent(current_user_lang(), {
        showNotification(
            paste(i18n$t("Language changed to"), current_user_lang()),
            type = "message"
        )
    })
}
