### Yandex Cloud Project ID

Enter the ID of the folder (catalog) in Yandex Cloud where the service account for accessing the YandexGPT API is created. This ID is used to form the `modelUri` in requests to Yandex Foundation Models.

**How to find your Folder ID:**

1. Open the [Yandex Cloud management console](https://console.cloud.yandex.ru).
2. Select the desired folder from the top panel.
3. The ID appears:
   - **At the top**, right below the folder name, or
   - Click «⋮» next to the folder name → **Folder info** → the **ID** field.

**Example:** `b1gsm26ta12sfo8jpbgr`

**How it's used:**

The ID is inserted into `modelUri` when making API calls, for example:

```
gpt://b1gsm26ta12sfo8jpbgr/yandexgpt-lite
```

**Important:** The service account whose API key you are using must have the `ai.languageModels.user` and/or `ai.foundationModels.user` roles assigned to this folder. Without these roles, requests will be rejected with an access error.
