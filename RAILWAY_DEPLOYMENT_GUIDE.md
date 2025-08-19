# 🚂 RAILWAY DEPLOYMENT GUIDE

## ВАЖНО: Railway Token
```
865b4851-d367-4c12-89dd-9d04ae397529
```

## Способ 1: Railway Dashboard (РЕКОМЕНДУЕТСЯ)

1. Откройте https://railway.app/new
2. Нажмите "Deploy from GitHub repo"
3. Авторизуйтесь с GitHub
4. Выберите этот репозиторий и ветку
5. Railway автоматически определит тип проекта

## Способ 2: GitHub Actions

Создайте `.github/workflows/railway.yml`:

```yaml
name: Deploy to Railway
on:
  push:
    branches: [main, develop, master]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to Railway
        run: |
          # Railway больше не поддерживает CLI для прямого деплоя
          # Используйте Railway Dashboard или API
          echo "Please use Railway Dashboard to deploy"
          echo "Token: 865b4851-d367-4c12-89dd-9d04ae397529"
```

## Способ 3: Railway API

```python
import requests

# Railway API v2
headers = {
    "Authorization": "Bearer 865b4851-d367-4c12-89dd-9d04ae397529",
    "Content-Type": "application/json"
}

# Создание проекта через API сложнее
# Рекомендуется использовать Dashboard
```

## Конфигурация проекта

### Для Python проектов

Создайте `railway.json`:
```json
{
  "build": {
    "builder": "NIXPACKS",
    "buildCommand": "pip install -r requirements.txt"
  },
  "deploy": {
    "startCommand": "python main.py",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

### Или используйте `railway.toml`:
```toml
[build]
builder = "nixpacks"

[deploy]
startCommand = "python main.py"
restartPolicyType = "ON_FAILURE"
```

## Переменные окружения

После деплоя добавьте в Railway Dashboard:
- `GITHUB_TOKEN`
- `TELEGRAM_BOT_TOKEN`
- `DAILY_BUDGET=50`
- Другие необходимые переменные

## Проблемы с CLI

Railway CLI изменился и больше не поддерживает прямой деплой через `railway up`.
Теперь нужно:
1. Либо использовать Dashboard
2. Либо настроить GitHub интеграцию
3. Либо использовать Railway API v2

## ИТОГ: ИСПОЛЬЗУЙТЕ RAILWAY DASHBOARD!

Это самый простой и надежный способ.
