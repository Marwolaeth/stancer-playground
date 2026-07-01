reactable_lang <- function(i18n_r) {
    reactable::reactableLang(
        searchPlaceholder = i18n_r()$t("Search..."),
        noData = i18n_r()$t("No data found"),
        pageNext = i18n_r()$t("Next →"),
        pagePrevious = i18n_r()$t("← Previous"),
        pageNumbers = i18n_r()$t("Page {page} of {pages}"),
        pageInfo = i18n_r()$t("{rowStart}–{rowEnd} of {rows}"),
        pageSizeOptions = i18n_r()$t("Show {rows} rows"),
        pageNextLabel = i18n_r()$t("Next page"),
        pagePreviousLabel = i18n_r()$t("Previous page"),
        pageNumberLabel = i18n_r()$t("Page {page}"),
        pageJumpLabel = i18n_r()$t("Go to page"),
        pageSizeOptionsLabel = i18n_r()$t("Rows per page")
    )
}

content_tooltip <- function(value, cmax = 50) {
    if (is.na(value)) return("NA")

    if (nchar(value) > cmax) {
        htmltools::tagList(
            htmltools::span(substr(value, 1, cmax), "..."),
            htmltools::span(
                class = "tooltiptext",
                value
            )
        )
    } else {
        value
    }
}

stance_badge <- function(value) {
    if (is.na(value)) return(value)

    # Colour pallette for both scales
    colour <- stance_colour_reactable(value)
    htmltools::span(
        style = paste0(
            "background-color: ", colour, "; ",
            "color: white; padding: 2px 8px; border-radius: 12px; ",
            "font-size: 0.9em; font-weight: bold;"
        ),
        value
    )
}

stancer_columns <- function(
        col_text,
        col_true = NULL,
        col_target = NULL
) {
    ## Protect column names ----
    protected_names <- c(".stance", "explanation")
    safe_col_text <- if (col_text %in% protected_names) paste0(col_text, "_original") else col_text
    safe_col_true <- if (col_true == "") "undefined" else col_true
    safe_col_target <- if (col_target == "") "stance_target" else col_target

    col_defs <- list(
        ## Text ----
        text = reactable::colDef(
            show = TRUE,
            name = tools::toTitleCase(col_text),
            searchable = TRUE,
            filterable = TRUE,
            cell = function(value) content_tooltip(value, 80),
            style = 'white-space: pre-wrap;'
        ),
        ## Predicted Stance ----
        .stance = reactable::colDef(
            show = TRUE,
            name = "Predicted Stance",
            searchable = FALSE,
            filterable = TRUE,
            maxWidth = 180,
            cell = function(value) stance_badge(value)
        ),
        ## Explanation ----
        explanation = reactable::colDef(
            show = TRUE,
            name = "Explanation",
            searchable = TRUE,
            filterable = TRUE,
            cell = function(value) content_tooltip(value),
            style = 'background: #eee; white-space: pre-wrap;'
        )
    )
    names(col_defs)[1] <- safe_col_text

    ## True Labels (Optional) ----
    if (!is.null(col_true) & col_true != "") {
        col_defs[["true_labels"]] <-reactable::colDef(
            show = TRUE,
            name = "True Stance",
            searchable = FALSE,
            filterable = TRUE,
            maxWidth = 180,
            cell = function(value) stance_badge(value)
        )

        names(col_defs)[4] <- safe_col_true
    }

    ## Target (Optional) ----
    if (!is.null(col_true) & col_true != "") {
        col_defs[["target"]] <-reactable::colDef(
            show = TRUE,
            name = "Target",
            searchable = TRUE,
            filterable = TRUE
        )

        names(col_defs)[5] <- safe_col_target
    }

    col_defs
}
