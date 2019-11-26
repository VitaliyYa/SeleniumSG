# Selenium-Grid
How to run tests locally whith Selenium Grid

## Запуск Selenium Grid локально:
1. Запустить локально хаб https://selenium.dev/documentation/en/grid/setting_up_your_own_grid/
2. Запустить 4 ноды вручную: две ноды с chrome, две ноды c firefox
3. Запустить smoke тесты в 2 потока на гриде, сначала на Chrome, потом на Firefox
4. Отключить все ноды
5. Добавить настройки для нод с помощью nodeConfig.json
6. Запустить ноды с помощью конфигурационных файлов nodeConfig.json
7. Запустить smoke тесты в 2 потока на гриде, сначала на Chrome, потом на Firefox
8. Создать новый репозиторий. Закоммитить файлы с nodeConfig в репозиторий. Написать в readme команды для запуска тестов на гриде в 2 потока.


------------------------

### 1. Запуск хаба:

`java -jar selenium-server-standalone.jar -role hub`

### 1.1. Запуск хаба с hubConfig.json:

`java -jar selenium-server-standalone.jar -role hub -hubConfig hubConfig.json`

### 2. Запуск 4-х нод вручную, 2 ноды с chrome, две ноды c firefox:
(Ничего лучше не прдумал, чем запустить в четырех вкладках терминала по команде:
```bash
java -jar selenium-server-standalone.jar -role node -hub http://localhost:4444 -browser browserName=chrome

java -jar selenium-server-standalone.jar -role node -hub http://localhost:4444 -browser browserName=firefox

```

### 3. Запустить smoke тесты в 2 потока на гриде, сначала на Chrome, потом на Firefox
```
py.test -s -m smoke --executor=http://localhost:4444/wd/hub --domain=https://staging1.int.stepik.org --browser=chrome -n2

py.test -s -m smoke --executor=http://localhost:4444/wd/hub --domain=https://staging1.int.stepik.org --browser=firefox -n2
```

### 4. Отключить все ноды
Ничего, кроме Ctrl+C не нашел.

### 5. Настройки для нод с помощью nodeConfig.json
Файлы: [для Chrome](cromeNodeConfig.json) и [для Firefox](firefoxNodeConfig.json)


