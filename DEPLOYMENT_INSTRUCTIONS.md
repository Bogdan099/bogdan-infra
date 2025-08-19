# 📋 ИНСТРУКЦИИ ДЛЯ ДЕПЛОЯ

## ШАГ 1: Подготовка файлов

Убедитесь что есть:
- `requirements.txt` или `package.json`
- Основной файл приложения (`main.py`, `app.py` и т.д.)

## ШАГ 2: Добавьте railway.json

```json
{
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "python main.py"
  }
}
```

## ШАГ 3: Закоммитьте и запушьте

```bash
git add .
git commit -m "Add Railway configuration"
git push
```

## ШАГ 4: Деплой через Dashboard

1. Откройте: https://railway.app/new
2. Нажмите "Deploy from GitHub repo"
3. Выберите этот репозиторий
4. Railway Token: `865b4851-d367-4c12-89dd-9d04ae397529`

## ВАЖНО

- НЕ используйте `railway up` - эта команда больше не работает
- НЕ пытайтесь установить старый CLI
- ИСПОЛЬЗУЙТЕ Railway Dashboard

## Если нужна помощь

Прочитайте RAILWAY_DEPLOYMENT_GUIDE.md в этой же директории.
