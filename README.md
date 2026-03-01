## Структура

```
apps/
  ios/                    # iOS (Swift), XcodeGen
    project.yml            # конфигурация двух приложений
    BankClient/            # приложение для клиента банка
    BankEmployee/          # приложение для сотрудника банка
services/                  # микросервисы бэкенда (Java, Node/TS)
```

## Бэкенд

Из папки `services` бэкенд запускается через Docker:

```bash
cd services
docker-compose up --build -d
```

## iOS (Swift)

Два приложения в одном Xcode-проекте:

- **BankClient** — клиент банка (`tarchenko.BankClient`)
- **BankEmployee** — сотрудник банка (`tarchenko.BankEmployee`)

Проект собирается через [XcodeGen](https://github.com/yonaskolb/XcodeGen). После клонирования или изменения `project.yml`:

```bash
cd apps/ios
./generate.sh
```
