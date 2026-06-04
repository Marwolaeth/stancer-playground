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

with_red_spinner <- function(
        ui_element,
        size = 1.8,
        caption = 'Pending Evaluation'
) {
    shinycssloaders::withSpinner(
        ui_element,
        type = 2,
        color = '#d73925',
        color.background = '#610E01',
        hide.ui = FALSE,
        size = size,
        caption = caption
    )
}

stance_colour_reactable <- function(stance_label) {
    switch(
        as.character(stance_label),
        # Categorical (three-way)
        "Positive" = "#28a745",
        "Negative" = "#dc3545",
        "Neutral" = "#ffc107",
        # Likert Scale
        "Strongly Disagree" = "#bd2130",
        "Disagree" = "#dc3545",
        "Agree" = "#28a745",
        "Strongly Agree" = "#1e7e34",
        # Default
        "#6c757d"
    )
}

stance_colour_dashboard <- function(stance_label) {
    switch(
        as.character(stance_label),
        # Categorical (three-way)
        "Positive" = "green",
        "Negative" = "red",
        "Neutral" = "yellow",
        # Likert Scale
        "Strongly Disagree" = "maroon",
        "Disagree" = "red",
        "Agree" = "green",
        "Strongly Agree" = "olive",
        # Default
        "navy"
    )
}

stance_status <- function(stance_label) {
    switch(
        as.character(stance_label),
        # Categorical (three-way)
        "Positive" = "success",
        "Negative" = "danger",
        "Neutral" = "warning",
        # Likert Scale
        "Strongly Disagree" = "danger",
        "Disagree" = "danger",
        "Agree" = "success",
        "Strongly Agree" = "success",
        # Default
        "navy"
    )
}
