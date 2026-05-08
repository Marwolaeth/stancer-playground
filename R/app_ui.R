#' The application User-Interface
#'
#' @param request Internal state used by shiny.
#' @import shiny
#' @import shinydashboard
#' @import shinydashboardPlus
#' @import cookies
#' @import shiny.i18n
#' @noRd
app_ui <- function(request) {
    # Wrap UI with cookie handlers
    add_cookie_handlers(
        dashboardPage(title = "stancer playground",
            header = dashboardHeader(title = tagList(
                span(class = "logo-lg", "stancer playground"),
                icon("balance-scale")
            )),

            sidebar = dashboardSidebar(
                sidebarMenu(
                    id = "tabs",
                    menuItem(
                        i18n$t("Single Analysis"),
                        tabName = "single",
                        icon = icon("comment")
                    ),
                    menuItem(
                        i18n$t("Batch Analysis"),
                        tabName = "batch",
                        icon = icon("file-csv")
                    ),
                    menuItem(
                        i18n$t("Prompt Editor"),
                        tabName = "prompts",
                        icon = icon("edit")
                    ),
                    menuItem(
                        i18n$t("Settings"),
                        tabName = "settings",
                        icon = icon("cog")
                    )
                )
            ),

            controlbar = dashboardControlbar(
                id = "controlbar",
                width = 300,
                # Здесь будет модуль mod_model_config_ui
                mod_model_config_ui("model_config_1")
            ),

            body = dashboardBody(
                # Инициализация shinyjs и i18n
                shinyjs::useShinyjs(),
                shiny.i18n::usei18n(i18n),

                tabItems(
                    # Single Analysis Tab
                    tabItem(
                        tabName = "single",
                        mod_single_analysis_ui("single_analysis_1")
                    ),

                    # Batch Analysis Tab
                    tabItem(
                        tabName = "batch",
                        mod_batch_analysis_ui("batch_analysis_1")
                    ),

                    # Placeholder tabs
                    tabItem(
                        tabName = "prompts",
                        h2("Prompt Editor (Coming Soon)")
                    ),
                    tabItem(
                        tabName = "settings",
                        mod_settings_ui("settings_1")
                    )
                )
            ),
            footer = dashboardFooter(
                left = "Built with {stancer} and {golem}",
                right = "2026"
            )
        )
    )
}
