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
    i18n <- golem::get_golem_options(which = "translator")
    i18n$set_translation_language("en")
    i18n$use_js()

    tagList(
        golem_add_external_resources(),
        dashboardPage(title = "stancer playground",
                      skin = "red",
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
                                  icon = icon("language")
                              )
                          )
                      ),

                      controlbar = dashboardControlbar(
                          id = "controlbar",
                          width = 300,
                          mod_model_config_ui("model_config_1", i18n)
                      ),

                      body = dashboardBody(
                          tabItems(
                              # Single Analysis Tab
                              tabItem(
                                  tabName = "single",
                                  mod_single_analysis_ui("single_analysis_1", i18n)
                              ),

                              # Batch Analysis Tab
                              tabItem(
                                  tabName = "batch",
                                  mod_batch_analysis_ui("batch_analysis_1", i18n)
                              ),

                              # Placeholder tabs
                              tabItem(
                                  tabName = "prompts",
                                  h2("Prompt Editor (Coming Soon)")
                              ),
                              tabItem(
                                  tabName = "settings",
                                  mod_settings_ui("settings_1", i18n)
                              )
                          )
                      ),
                      footer = dashboardFooter(
                          left = "Built with {stancer} and {golem}",
                          right = "2026"
                      )
        )
    ) |>
        # Wrap UI with cookie handlers
        add_cookie_handlers()
}

golem_add_external_resources <- function() {
    i18n <- golem::get_golem_options("translator")

    golem::add_resource_path("www", app_sys("app/www"))

    tags$head(
        golem::favicon(),
        golem::bundle_resources(
            path = app_sys("app/www"),
            app_title = "stancer playground"
        ),
        tags$link(
            rel = 'stylesheet',
            type = 'text/css',
            href = 'tooltips.css'
        ),

        # CRITICAL: Active browser-side script activation
        shinyjs::useShinyjs(),
        shiny.i18n::usei18n(i18n)
    )
}
