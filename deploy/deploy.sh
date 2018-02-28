if [ "$1" != "stage" ] && [ "$1" != "prod" ]; then
  echo "Invalid environment => $1"
  exit
fi

date=`date "+%Y%m%d%H%M%S"`
tag=slim-$date
docker build -t come_and_get_me_web:$tag .
docker save --output ./tmp/deploys/come_and_get_me_web.tar come_and_get_me_web:$tag
rsync ./tmp/deploys/come_and_get_me_web.tar deploy@slingshot.jakobra.com:/var/apps/come_and_get_me/come_and_get_me_web.tar --progress
rsync ./docker-compose/docker-compose.yml deploy@slingshot.jakobra.com:/var/apps/come_and_get_me/$1/docker-compose.yml --progress
rsync ./docker-compose/docker-compose.$1.yml deploy@slingshot.jakobra.com:/var/apps/come_and_get_me/$1/docker-compose.$1.yml --progress
rsync ./deploy/run.sh deploy@slingshot.jakobra.com:/var/apps/come_and_get_me/$1/run.sh --progress

ssh -T deploy@slingshot.jakobra.com << EOF
cd /var/apps/come_and_get_me
docker load --input come_and_get_me_web.tar
cd $1 && TAG=$tag ./run.sh $1
docker image prune -a -f
EOF
