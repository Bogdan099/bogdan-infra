# 🚂 Railway Deployment Guide - Orchestrator Service

## ✅ Готовые файлы для деплоя

Все необходимые файлы созданы и готовы к деплою:

```
railway-configs/orchestrator/
├── railway.json      # ✅ Railway конфигурация
├── Dockerfile        # ✅ Docker контейнер
├── .env.example      # ✅ Переменные окружения
└── README.md         # ✅ Документация

deploy-orchestrator.sh # ✅ Скрипт автоматического деплоя
```

## 🚀 Автоматический деплой

### Шаг 1: Логин в Railway

Выберите один из способов:

**Способ 1: Browser login**
```bash
railway login
```

**Способ 2: Token login**
```bash
export RAILWAY_TOKEN='your-railway-token-here'
railway login
```

**Способ 3: Browserless login**
```bash
railway login --browserless
# Перейдите по ссылке и введите код сопряжения
```

### Шаг 2: Выполните деплой

```bash
# Запустите автоматический скрипт деплоя
./deploy-orchestrator.sh
```

## 📋 Ручной деплой

Если предпочитаете ручной деплой:

```bash
# 1. Перейдите в директорию
cd railway-configs/orchestrator

# 2. Инициализируйте проект
railway init --name orchestrator-service

# 3. Выполните деплой
railway deploy --detach

# 4. Проверьте статус
railway status

# 5. Получите URL
railway domain
```

## 🔧 Конфигурация

### Переменные окружения

Важные переменные, которые нужно настроить в Railway:

```bash
# Обязательные переменные
railway variables set DATABASE_URL="postgresql://..."
railway variables set REDIS_URL="redis://..."
railway variables set JWT_SECRET="your-secure-secret"
railway variables set API_KEY="your-api-key"

# Дополнительные настройки
railway variables set CORS_ORIGINS="https://your-frontend-domain.com"
railway variables set SENTRY_DSN="your-sentry-dsn"
```

### Порты и endpoints

- **Port**: 8000
- **Health check**: `/health`
- **API**: Все endpoints доступны через корневой URL

## 📊 После деплоя

1. **Проверьте health endpoint**:
   ```bash
   curl https://your-service-url.railway.app/health
   ```

2. **Просмотрите логи**:
   ```bash
   railway logs
   ```

3. **Мониторинг статуса**:
   ```bash
   railway status
   ```

## 🔗 Ожидаемый результат

После успешного деплоя вы получите:

- 🌐 **Service URL**: `https://orchestrator-service-production.railway.app`
- 🏥 **Health endpoint**: `https://your-url.railway.app/health`
- 📊 **Monitoring**: Доступ через Railway dashboard
- 📝 **Logs**: `railway logs` для просмотра логов

## 🐛 Устранение проблем

### Проблема: "Unauthorized. Please login"
**Решение**: Выполните `railway login` или установите `RAILWAY_TOKEN`

### Проблема: "Health check fails"
**Решение**: 
- Проверьте логи: `railway logs`
- Убедитесь что endpoint `/health` реализован в приложении
- Проверьте переменные окружения

### Проблема: "Build failed"
**Решение**:
- Убедитесь что `requirements.txt` присутствует в корне проекта
- Проверьте Dockerfile синтаксис
- Просмотрите build логи в Railway dashboard

## 💡 Дополнительные команды

```bash
# Просмотр переменных окружения
railway variables

# Подключение к базе данных
railway connect postgres

# Выполнение команды в контейнере
railway run python manage.py migrate

# Скачать логи
railway logs --tail 100 > logs.txt
```

---

**Примечание**: Замените `your-service-url` на реальный URL, который выдаст Railway после деплоя.