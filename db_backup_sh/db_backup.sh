#!/bin/bash

# コンテナ内でダンプファイルを生成するshファイル

#旧バックアップファイルの削除
rm etc/mysql_backup/*.sql

#job_errのリセット
job_err=false

# ダンプファイル生成
mysqldump --databases grass_chords_production -u ${MYSQL_BACKUP_USER} -p${MYSQL_PASSWORD} > etc/mysql_backup/gc_backup.sql

# エラー確認
if [ $? = 0 ]; then
 job=0
else
 job=$? job_err=true
fi

#日付及びバックアップ結果の出力
date_stamp=`date '+%Y-%m-%d %H:%M'`
echo "#"$date_stamp
echo '  grass_chords_production=' ${job}

#終了処理(エラーがある場合は１でリターン)
if [ $job_err = true ]; then
  exit 1
else
  exit 0
fi

