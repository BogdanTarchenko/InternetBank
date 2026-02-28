# План коммитов core-service (имитация реальной работы)

Текущая ветка: `feature/core-service`.  
Перед выполнением команд перейдите в корень репозитория: `cd c:\Users\Lenovo\OpenideProjects\InternetBank`

---

## Шаг 0. Подготовка (сброс текущего индекса)

```powershell
cd c:\Users\Lenovo\OpenideProjects\InternetBank
git checkout feature/core-service
git reset HEAD
git add -A services/core/
git status
```

Дальше делаем коммиты по группам. Если всё уже в индексе одним куском — сначала один раз сбросить индекс и добавлять файлы по шагам ниже.

---

## Коммит 1. Инициализация core-сервиса

**Сообщение:** `Инициализация core-сервиса: Gradle, точка входа`

```powershell
git add services/core/build.gradle.kts
git add services/core/gradlew
git add services/core/gradlew.bat
git add services/core/gradle/
git add services/core/src/main/kotlin/com/example/core/CoreApplication.kt
git commit -m "Инициализация core-сервиса: Gradle, точка входа"
```

---

## Коммит 2. Доменная модель

**Сообщение:** `Добавлена доменная модель: счета, операции, пользователи, retry`

```powershell
git add services/core/src/main/kotlin/com/example/core/domain/
git commit -m "Добавлена доменная модель: счета, операции, пользователи, retry"
```

---

## Коммит 3. Конфигурация и безопасность API

**Сообщение:** `Конфигурация приложения и аутентификация API-клиентов`

```powershell
git add services/core/src/main/kotlin/com/example/core/config/
git add services/core/src/main/resources/application.yml
git commit -m "Конфигурация приложения и аутентификация API-клиентов"
```

---

## Коммит 4. Репозитории и миграции БД

**Сообщение:** `Репозитории JPA и миграции Liquibase`

```powershell
git add services/core/src/main/kotlin/com/example/core/repository/
git add services/core/src/main/resources/db/
git commit -m "Репозитории JPA и миграции Liquibase"
```

---

## Коммит 5. Сервисный слой

**Сообщение:** `Сервисы: счета, статусы пользователей, retry`

```powershell
git add services/core/src/main/kotlin/com/example/core/service/
git commit -m "Сервисы: счета, статусы пользователей, retry"
```

---

## Коммит 6. API контроллеры

**Сообщение:** `REST API: клиентский и сотруднический контуры по счетам`

```powershell
git add services/core/src/main/kotlin/com/example/core/controller/
git commit -m "REST API: клиентский и сотруднический контуры по счетам"
```

---

## Коммит 7. Интеграция Kafka и обработка событий

**Сообщение:** `Kafka: подписка на события статуса пользователя и механизм повторных попыток`

```powershell
git add services/core/src/main/kotlin/com/example/core/kafka/
git commit -m "Kafka: подписка на события статуса пользователя и механизм повторных попыток"
```

---

## Пуш ветки и создание Pull Request в GitHub

Замените `GITHUB_REPO` на URL вашего репозитория (например `https://github.com/username/InternetBank`).

### Пуш ветки

```powershell
git push -u origin feature/core-service
```

### Открыть страницу создания PR в GitHub

После пуша откройте в браузере (подставьте свой `GITHUB_REPO`):

```
GITHUB_REPO/compare/feature/core-service?expand=1
```

Или прямую ссылку «новый PR из ветки»:

```
GITHUB_REPO/pull/new/feature/core-service
```

Или: зайдите в репозиторий на GitHub → **Compare & pull request** во всплывающей подсказке после пуша, либо вкладка **Pull requests** → **New pull request** → выберите ветку `feature/core-service`.

### Одной строкой (PowerShell, подставьте свой URL)

```powershell
$GITHUB_REPO = "https://github.com/YOUR_USER/InternetBank"   # замените на свой URL
Start-Process "$GITHUB_REPO/pull/new/feature/core-service"
```

---

## Краткая шпаргалка: все коммиты подряд

Если хотите выполнить все коммиты за один заход (после шага 0 и добавления только нужных файлов по шагам 1–7):

```powershell
cd c:\Users\Lenovo\OpenideProjects\InternetBank
git checkout feature/core-service
git reset HEAD
# Коммит 1
git add services/core/build.gradle.kts services/core/gradlew services/core/gradlew.bat services/core/gradle/ services/core/src/main/kotlin/com/example/core/CoreApplication.kt
git commit -m "Инициализация core-сервиса: Gradle, точка входа"
# Коммит 2
git add services/core/src/main/kotlin/com/example/core/domain/
git commit -m "Добавлена доменная модель: счета, операции, пользователи, retry"
# Коммит 3
git add services/core/src/main/kotlin/com/example/core/config/ services/core/src/main/resources/application.yml
git commit -m "Конфигурация приложения и аутентификация API-клиентов"
# Коммит 4
git add services/core/src/main/kotlin/com/example/core/repository/ services/core/src/main/resources/db/
git commit -m "Репозитории JPA и миграции Liquibase"
# Коммит 5
git add services/core/src/main/kotlin/com/example/core/service/
git commit -m "Сервисы: счета, статусы пользователей, retry"
# Коммит 6
git add services/core/src/main/kotlin/com/example/core/controller/
git commit -m "REST API: клиентский и сотруднический контуры по счетам"
# Коммит 7
git add services/core/src/main/kotlin/com/example/core/kafka/
git commit -m "Kafka: подписка на события статуса пользователя и механизм повторных попыток"
# Пуш
git push -u origin feature/core-service
```

После этого откройте PR по ссылке выше (с вашим `GITHUB_REPO`).

---

## Вариант: отдельный PR на каждую фичу

Если нужны отдельные Pull Request по каждой части — заведите отдельные ветки от `main`, вносите изменения только по теме ветки, пушите и создаёте PR. Пример (подставьте свой `GITHUB_REPO`, например `https://github.com/username/InternetBank`):

| Ветка | Коммит (рус.) | Пуш | Открыть PR |
|-------|----------------|-----|-------------|
| `feature/core-service-init` | Инициализация core-сервиса: Gradle, точка входа | `git push -u origin feature/core-service-init` | `GITHUB_REPO/pull/new/feature/core-service-init` |
| `feature/core-service-domain` | Добавлена доменная модель: счета, операции, пользователи, retry | `git push -u origin feature/core-service-domain` | `GITHUB_REPO/pull/new/feature/core-service-domain` |
| `feature/core-service-config` | Конфигурация приложения и аутентификация API-клиентов | `git push -u origin feature/core-service-config` | `GITHUB_REPO/pull/new/feature/core-service-config` |
| `feature/core-service-persistence` | Репозитории JPA и миграции Liquibase | `git push -u origin feature/core-service-persistence` | `GITHUB_REPO/pull/new/feature/core-service-persistence` |
| `feature/core-service-services` | Сервисы: счета, статусы пользователей, retry | `git push -u origin feature/core-service-services` | `GITHUB_REPO/pull/new/feature/core-service-services` |
| `feature/core-service-api` | REST API: клиентский и сотруднический контуры по счетам | `git push -u origin feature/core-service-api` | `GITHUB_REPO/pull/new/feature/core-service-api` |
| `feature/core-service-kafka` | Kafka: подписка на события статуса пользователя и механизм повторных попыток | `git push -u origin feature/core-service-kafka` | `GITHUB_REPO/pull/new/feature/core-service-kafka` |

Ветки 2–7 нужно создавать от уже смерженной предыдущей (или от `feature/core-service`), чтобы код собирался.
