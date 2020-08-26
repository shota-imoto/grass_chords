#!/bin/bash

# ダンプ生成用shファイルの起動
docker container exec ec2-user_db_1 bash db_backup.sh

# ダンプをコンテナからホストにコピー
docker container cp ec2-user_db_1:/etc/mysql_backup/gc_backup.sql .

# ダンプをホストからS3にアップロード
aws s3 mv gc_backup.sql s3://grasschords-db-backup/mysql_backup/gc_backup.sql
