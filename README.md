# landing_target
<p>Образ:</p>
<p>https://disk.yandex.ru/d/Zy6PdU75LF4qDA</p>
<p>Raspberri должа быть подключена к интернету</p>
<p>Пароль wifi raspberry: robotseverywhere</p>
<p>Запустить:</p>
<p>(После первого запуска) sudo reboot</p>
<p>git clone https://github.com/main2stels/landing_target.git</p>
<p>cd landing_target/</p>
<p>sudo bash ./rosinstall.sh</p>
<h1>Параметр лист: </h1>
<p>PLND_ENABLED=1</p>
<p>Установить, если нет высотомера(высота будет определяться камерой):</p>
<p>RNGFND1_TYPE=10</p>
<p>SYSID_MYGCS=1</p>
<p>Перезагрузить полетный контроллер</p>
<p>PLND_ALT_MIN=0,3</p>
<p>PLND_EST_TYPE=0</p>
<p>PLND_LAG=0,1</p>
<p>PLND_TYPE=1</p>
<p>PLND_XY_DIST_MAX=10</p>
<p>Для SERIAL к которому подключена raspberry:</p>
<p>SERIAL2_BAUD=921</p>
<p>SERIAL2_PROTOCOL=2</p>
