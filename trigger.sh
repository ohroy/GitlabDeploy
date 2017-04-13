#!/bin/sh
LOCK='/tmp/gitlab.lock'
echo $1 > /tmp/ppppp.log
if [ -f ${LOCK} ]
then
    echo "已有更新实例在运行"
    exit 0
fi
ref=${2##*/}
echo 当前版本:${ref}
WEB_PATH='/home/wwwroot/papa'
ini=`cat ${WEB_PATH}/.env|grep app_version=`
tmp=${ini##*version=}
echo "当前本地版本:${tmp}"
if [ $tmp == $WEB_PATH ]
then
   echo "已经是最新版本了"
   exit 0
fi
echo 'begin to deploy'
echo $ref > ${LOCKD}
pushd $WEB_PATH
now=`date '+%Y-%m-%d %H:%M:%S'`
echo $now
echo '准备休眠'
sleep 5
now=`date '+%Y-%m-%d %H:%M:%S'`
echo $now
git checkout master -f
git reset --hard origin/master
git clean -f
git pull
git checkout ${ref}
# conf
rm -rf runtime/*
sed -i 's@app_version=.*@app_version='${ref}'@' .env
# composer
export COMPOSER_HOME='/home/www/.composer'
composer update
composer dump
# 向群组汇报当前更新消息。
curl 'https://oapi.dingtalk.com/robot/send?access_token=654ea6851166793fbe26eda8cd1c530732b6c756b4c9084f617b894ec182d42f' \
   -H 'Content-Type: application/json' \
   -d '
  {"msgtype": "text",
    "text": {
        "content": "【版本通知】啪啪云控web端线上环境已经部署为v'${ref}',版本详情:http://api.papa555.com/debug/ver"
     },
        "at": {
    "isAtAll": true
   }
  }'

echo 'deploy ok';
popd
rm -f ${LOCK}
