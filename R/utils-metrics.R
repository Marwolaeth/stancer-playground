metric_accuracy <- function(y_hat, y) {
    stopifnot(length(y_hat) == length(y))
    mean(y_hat == y)
}

metric_f1 <- function(y_hat, y) {
    stopifnot(length(y_hat) == length(y))

    # Confusion matrix
    if (is.factor(y_hat)) {
        levels <- levels(y_hat)
    } else {
        levels <- sort(unique(y_hat), decreasing = FALSE)
        y_hat <- factor(y_hat, levels = levels)
    }
    y <- factor(y, levels = levels)
    cm <- table(Predicted = y_hat, Actual = y)

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
    macro_f1 <- mean(f1)
    cat("Macro F1-Score:", round(macro_f1, 4), "\n")

    ### MICRO F1-SCORE (using all observations)
    t_TP <- sum(TP)
    t_FP <- sum(FP)
    t_FN <- sum(FN)

    micro_precision <- t_TP / (t_TP + t_FP + 1e-9)
    micro_recall    <- t_TP / (t_TP + t_FN + 1e-9)
    micro_f1        <- 2 * (micro_precision * micro_recall) /
        (micro_precision + micro_recall + 1e-9)

    cat("Micro F1-Score:", round(micro_f1, 4), "\n")

    return(micro_f1)
}
