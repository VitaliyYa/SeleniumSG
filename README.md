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
С этип пунктом возникли сложности. Сначала взял конфиг за образец из руководсва по ссылке https://selenium.dev/documentation/en/grid/setting_up_your_own_grid/#configuration-of-node-with-json
но с этим примером нода не хотела стартовать, сервер писал обновите конфиг до совместимого с версией 3.х... и давал эту ссылку https://github.com/SeleniumHQ/selenium/blob/selenium-3.141.59/java/server/src/org/openqa/grid/common/defaults/DefaultNodeWebDriver.json
по ней норм запустилось, так и оставил.

### 6. Запуск нод с помощью конфигурационных файлов nodeConfig.json
Для ускорения запуска хаба и нод сделал [скрипт](startSG.sh) Володя, дякую! =)

### 7. Запуск smoke тестов в 2 потока на гриде, сначала на Chrome, потом на Firefox
Команды для запуска в Chrome:
`py.test -s -m smoke --executor=http://localhost:4444/wd/hub --domain=https://staging1.int.stepik.org --browser=chrome -n2`

и в Firefox:
`py.test -s -m smoke --executor=http://localhost:4444/wd/hub --domain=https://staging1.int.stepik.org -n2`

Для удобства в Pycharm настроил Run Configurations.  
в строку Keywords `smoke`  
в строку Additional Arguments `--executor=http://localhost:4444/wd/hub --domain=https://staging1.int.stepik.org --browser=chrome -n2`

### 8. Done.

------------------------------------------------

## Запуск Selenium Grid в докере
1. Установите docker в вашей ОС, например, https://phoenixnap.com/kb/how-to-install-docker-on-ubuntu-18-04
2. Научитесь запускать Selenium Grid в docker с помощью docker networking https://github.com/SeleniumHQ/docker-selenium#using-docker-networking. У вас должно быть запущено две ноды с Chrome и две ноды с Firefox. Попробуйте запустить smoke-тесты в два потока на гриде. Сохраните команды для запуска в readme вашего репозитория.
3. Установите docker-compose. Научитесь запускать Selenium Grid в docker с помощью docker-compose https://github.com/SeleniumHQ/docker-selenium#version-3. У вас должно быть запущено две ноды с Chrome и две ноды с Firefox. Попробуйте запустить smoke-тесты в два потока на гриде. Сохраните команды для запуска в readme вашего репозитория.

=================================================

### 1. Установка docker
Установка докер очень проста:  
```
sudo apt-get update
sudo apt-get install -y docker.io
```

Запуск Docker:
```
sudo systemctl start docker
```
Добавление docker в автозапуск:
```
sudo systemctl enable docker
```
или комбо из двух команд:
```
sudo systemctl start docker && sudo systemctl enable docker
```

Чтобы убедиться, что Docker работает, можно запустить команду:
```
sudo systemctl status docker
```

### 2. Запуск Selenium Grid в docker с помощью docker networking
Тоже достаточно всё просто:
Сначала создется сеть **grid**:  
```
docker network create grid
```
Запуск хаба:
```
docker run -d -p 4444:4444 --net grid --name selenium-hub selenium/hub:3.141.59-xenon
```
Запуск ноды с браузером Chrome:
```
docker run -d --net grid -e HUB_HOST=selenium-hub -v /dev/shm:/dev/shm selenium/node-chrome:3.141.59-xenon
```
Запуск ноды с браузером Firefox:
```
docker run -d --net grid -e HUB_HOST=selenium-hub -v /dev/shm:/dev/shm selenium/node-firefox:3.141.59-xenon
```
Посмотреть консоль хаба можно по адресу: `http://127.0.0.1:4444/grid/console`  
В каждой ноде по одному экзмпляру браузера.

После окончания работы с сеткой и закрытия контейнеров можно удалить сеть grid:
```
# Remove all unused networks
docker network prune
# OR Removes the grid network
docker network rm grid
```

### 3. Установка docker-compose. Запуск Selenium Grid в docker с помощью docker-compose
Установка docker-compose тоже очеь проста:
```
Sudo apt install docker-compose
```
Для запуска создать файл [docker-compose.yaml](docker-compose.yaml) локально и запускать сетку из папки командой:
```
docker-compose up -d
```
Запустится по одному экземпляру браузеров Chrome и Firefox.  
Для запуска 2-х экземпляров Chrome и 2-х Firefox:
```
docker-compose up --scale chrome=2 --scale firefox=2 -d
```
Для остановки сети и очистки созданных контейнеров команда:
```
docker-compose down
```
-------------------------------------------
### Allure-отчеты
Установка: просто скачать скопировать в папку и запускать локально из папки `allure/bin`  
При таком способе указывать путь запуска из локальной папки `./`  
```
./allure --version
```

Установка allure-pytest:
```
pip install allure-pytest
```

В папке с тестами создать каталог для отчетов `allure-results`. Запускать тесты с параметром `--alluredir` указав папку для отчетов:
```
--alluredir=./allure-results
```
После прогона тестов запустить сервер allure для ганерации и вывода отчета в браузере:
```
./allure serve [путь до папки allure-results]
```
[Документация](https://docs.qameta.io/allure/) по Allure Framework.
