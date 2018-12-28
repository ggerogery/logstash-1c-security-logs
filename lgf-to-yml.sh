# Этот скрипт по крону собирает данные из lgf файлов для словарей logstash'a и приводит их к yml формату. Logstash с интервалом обновляет эти словари из директории $MAPPING_DIR
# В lgf файлах нужная инфа содержится в номированных массивах, зная эти номера инфу можно выгрепать. 
# Подробнее о формате: https://infostart.ru/public/182061/
# Коды массивов были обнаружены следующие:
# 1 – пользователи;
# 2 – компьютеры;
# 3 – приложения;
# 4 – события;
# 5 – метаданные;
# 6 – серверы;
# 7 – основные порты;
# 8 – вспомогательные порты.
# Так же встречаются пока неопознанные коды 11, 12 и 13


MAPPING_DIR=/etc/logstash/conf.d/custom_mapping_1C

for FILE in $(ls /mnt/1C_logs/*/1Cv8Log/*.lgf); do
  DB_STRING=$(echo $FILE | cut -d "/" -f4)
  cat $FILE | grep {1, | tr -d '{}"' | awk -F"," '{ print "\""$4"\""": ""\""$3"\""}' > $MAPPING_DIR/$DB_STRING\_UserId.yml
  cat $FILE | grep {2, | tr -d '{}"' | awk -F"," '{ print "\""$3"\""": ""\""$2"\""}' > $MAPPING_DIR/$DB_STRING\_ComputerId.yml
  cat $FILE | grep {3, | tr -d '{}"' | awk -F"," '{ print "\""$3"\""": ""\""$2"\""}' > $MAPPING_DIR/$DB_STRING\_NameApplicationId.yml
  cat $FILE | grep {4, | tr -d '{}"' | awk -F"," '{ print "\""$3"\""": ""\""$2"\""}' > $MAPPING_DIR/$DB_STRING\_EventId.yml
  cat $FILE | grep {5, | tr -d '{}"' | awk -F"," '{ print "\""$4"\""": ""\""$3"\""}' > $MAPPING_DIR/$DB_STRING\_MetadataId.yml
  cat $FILE | grep {6, | tr -d '{}"' | awk -F"," '{ print "\""$3"\""": ""\""$2"\""}' > $MAPPING_DIR/$DB_STRING\_WorkServerId.yml
done

