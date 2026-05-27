#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
#' @import shiny.i18n
run_app <- function(
	onStart = NULL,
	options = list(),
	enableBookmarking = NULL,
	uiPattern = "/",
	...
) {
    translations <- jsonlite::read_json(
        path = "inst/app/www/translations.json",
        simplifyDataFrame = TRUE
    )$translation
    row.names(translations) <- translations[["en"]]

	with_golem_options(
		app = shinyApp(
			ui = app_ui,
			server = app_server,
			onStart = onStart,
			options = options,
			enableBookmarking = enableBookmarking,
			uiPattern = uiPattern
		),
		golem_opts = list(
		    # Global Translator Object
		    translator = shiny.i18n::Translator$new(
		        translation_json_path = "inst/app/www/translations.json"
		    ),
		    translations_df = translations,
		    help_path = "inst/app/www/help"
		)
	)
}
