#### Parallel Processing

*   **How it works**: When enabled, the application sends multiple requests to the LLM provider simultaneously using the `ellmer` parallel processing engine.
*   **Benefit**: Significantly reduces the total time required to analyse large datasets.
*   **Note**: Using parallel requests may consume your API rate limits (RPM/TPM) faster. If you encounter "Rate Limit" errors, try disabling this option to process rows sequentially.
