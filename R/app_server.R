#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
    # Инициализируем настройки модели
    settings <- mod_model_config_server("model_config_1")

    # Передаем настройки в модуль анализа
    mod_single_analysis_server("single_analysis_1", settings)
}
