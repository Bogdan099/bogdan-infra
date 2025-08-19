# Orchestrator Service - Railway Deployment

Конфигурация для деплоя orchestrator сервиса на Railway платформе.

## 📁 Структура

```
orchestrator/
├── railway.json     # Railway конфигурация
├── Dockerfile       # Docker контейнер
├── .env.example     # Пример переменных окружения
└── README.md        # Эта документация
```

## 🚀 Деплой

### 1. Подготовка

Установите Railway CLI:
```bash
npm install -g @railway/cli
```

Войдите в аккаунт:
```bash
railway login
```

### 2. Настройка переменных окружения

Скопируйте и настройте переменные окружения:
```bash
cp .env.example .env
# Отредактируйте .env с вашими настройками
```

Установите переменные в Railway:
```bash
railway variables set DATABASE_URL="your-postgres-url"
railway variables set JWT_SECRET="your-jwt-secret"
railway variables set API_KEY="your-api-key"
# ... остальные переменные
```

### 3. Деплой сервиса

```bash
# Находясь в директории railway-configs/orchestrator/
railway deploy
```

### 4. Проверка статуса

```bash
railway status
railway logs
```

## ⚙️ Конфигурация

### Основные переменные окружения:

- `DATABASE_URL` - PostgreSQL соединение
- `REDIS_URL` - Redis для кэширования  
- `JWT_SECRET` - Секрет для JWT токенов
- `API_KEY` - API ключ сервиса

### Порты:

- **8000** - HTTP API сервер
- Health check: `GET /health`

### Ресурсы:

- 1 реплика
- Автоматический рестарт при ошибках
- Health check каждые 30 секунд

## 🔧 Разработка

Для локальной разработки:

```bash
# Сборка образа
docker build -t orchestrator .

# Запуск контейнера
docker run -p 8000:8000 --env-file .env orchestrator
```

## 📊 Мониторинг

- Health endpoint: `http://localhost:8000/health`
- Логи: `railway logs`
- Метрики: настраиваются через Sentry (SENTRY_DSN)

## 🐛 Устранение проблем

1. **Сервис не запускается**: проверьте логи `railway logs`
2. **Health check fails**: убедитесь что `/health` endpoint доступен
3. **Database connection**: проверьте `DATABASE_URL`