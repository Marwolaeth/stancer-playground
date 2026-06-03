strip_html <- function(s) {
    gsub('<.*?>', '', s)
}

ht <- function(tag) {
    tag |> as.character() |> strip_html()
}

#' Helper wrapper
#' @param ui_element Shiny UI tag
#' @param help_id Helpfile base name  (e.g., "batch_analysis")
#' @param ... Other arguments to pass to `shinyhelper::helper()` or the `div` containing the icon.
with_helper <- function(ui_element, help_id, ...) {
    shinyhelper::helper(
        ui_element,
        icon = "question-circle",
        colour = '#d73925',
        type = 'markdown',
        content = help_id,
        buttonLabel = "Ok",
        easyClose = TRUE,
        fade = TRUE,
        ...
    )
}
