metric_accuracy <- function(y_hat, y) {
    stopifnot(length(y_hat) == length(y))
    mean(y_hat == y)
}

cm <- function(y_hat, y, scale = c("categorical", "likert")) {
    stopifnot(length(y_hat) == length(y))
    scale <- match.arg(scale, c("categorical", "likert"), several.ok = FALSE)

    # Factor levels (hard-coded)
    levels <- switch(
        scale,
        categorical = c("Negative", "Neutral", "Positive"),
        likert = c(
            "Strongly Disagree",
            "Disagree",
            "Neutral",
            "Agree",
            "Strongly Agree"
        )
    )
    y <- factor(as.character(y), levels = levels, ordered = TRUE)
    y_hat <- factor(as.character(y_hat), levels = levels, ordered = TRUE)

    # Confusion matrix
    table(Predicted = y_hat, Actual = y)
}

metric_f1 <- function(cm, score = c("macro", "micro")) {
    stopifnot(nrow(cm) == ncol(cm)) # Error if the confusion matrix is not square fsr
    score <- match.arg(score, c("macro", "micro"), several.ok = FALSE)

    # Base Metrics
    TP <- diag(cm)                   # True Positives (Diagonal)
    FP <- rowSums(cm) - TP           # False Positives (row sum - TP)
    FN <- colSums(cm) - TP           # False Negatives (column sum - TP)

    # Classwise Precision and Recall
    # (add correction 1e-9)
    precision <- TP / (TP + FP + 1e-9)
    recall    <- TP / (TP + FN + 1e-9)

    # Classwise F1
    f1 <- 2 * (precision * recall) / (precision + recall + 1e-9)

    ### MACRO F1-SCORE
    # (ignore empty classes)
    macro_f1 <- mean(f1[colSums(cm) > 0])
    if (score == "macro") return(macro_f1)

    ### MICRO F1-SCORE (using all observations)
    t_TP <- sum(TP)
    t_FP <- sum(FP)
    t_FN <- sum(FN)

    micro_precision <- t_TP / (t_TP + t_FP + 1e-9)
    micro_recall    <- t_TP / (t_TP + t_FN + 1e-9)
    micro_f1        <- 2 * (micro_precision * micro_recall) /
        (micro_precision + micro_recall + 1e-9)

    return(micro_f1)
}
