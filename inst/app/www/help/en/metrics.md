### Performance Metrics

These metrics quantify how well the model's predictions align with your "Ground Truth" labels.

#### Accuracy
*   **What it is**: The simplest measure of performance. It is the ratio of correctly predicted observations to the total observations.
*   **Interpretation**: If Accuracy is 0.80, it means the model was correct 80% of the time.
*   **Note**: Accuracy can be misleading if your classes are imbalanced (e.g., if 90% of your texts are "Neutral").

#### F1-Score (Macro)
*   **What it is**: The harmonic mean of Precision and Recall.
*   **Purpose**: It provides a better measure of the incorrectly classified cases than Accuracy, especially for imbalanced datasets.
*   **Interpretation**: It penalises extreme values. A high F1-score indicates that the model is robust and performs well across all categories without being biased towards the most frequent one.

#### Confusion Matrix

The Confusion Matrix is a visual tool to understand exactly *where* the model is making mistakes.

##### How to read it:
*   **Rows**: Represent the **Actual** labels (your Ground Truth).
*   **Columns**: Represent the **Predicted** labels (the model's output).
*   **Diagonal Cells**: The cells running from top-left to bottom-right show correct predictions. The darker/higher the number here, the better.
*   **Off-diagonal Cells**: Show misclassifications.

    *   *Example*: If there is a high number in the cell where the row is "Positive" and the column is "Negative", the model is frequently confusing supportive stances for opposing ones.
