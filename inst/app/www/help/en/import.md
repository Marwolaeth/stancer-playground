### Data Import and Corpus Analysis

This section allows you to upload your own dataset (corpus) for batch analysis. The system is designed to work with tabular data where each row represents an individual document.

#### Key Features:

*   **File Upload**: Upload your own CSV or Excel file containing the texts.
*   **Use Example**: If you don't have a dataset ready, click the **"Use Example"** button. This loads the `programming_tweets` dataset from the `stancer` library — a collection of 35 fictional tweets about Julia, Python, and R.

#### Column Mapping:
Once the data is loaded, you need to assign roles to your variables:
*   **Text Column**: The column containing the main text to be analysed.
*   **Target Column**: (Optional) The column specifying the target of the stance. If selected, the target will be dynamically updated for each row.
*   **Target Type Column**: (Optional) The column specifying the type of the target. Must contain either `Object` (for entity-based stance) or `Claim` (for assessing agreement with a proposition or a statement). If selected, the analysis type will be dynamically updated for each row.
*   **True Labels**: (Optional) The column containing your "Ground Truth" labels. This is required if you intend to use the **Scoring** feature to evaluate model performance.
