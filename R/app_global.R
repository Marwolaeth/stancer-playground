# Глобальный объект переводчика
# В golem файлы в R/ загружаются автоматически
i18n <- shiny.i18n::Translator$new(
    translation_json_path = "inst/app/www/translations.json"
)
i18n$set_translation_language("en") # Язык по умолчанию
