#!/bin/bash


# SUDO 권한 확인
if [ "$(id -u)" != "0" ]; then
    echo "SUDO 권한으로 실행해주세요."
    exit 1
fi  # fi 누락된 부분 추가

# 설정값
CONTAINER_NAME="mariadb1"
TIME_ZONE="+09:00"
HOST_CONFIG_FILE="./mariadb.cnf"

# 1. 비밀번호 입력 받기
echo -n "Enter MariaDB root password: "
read -s MYSQL_ROOT_PASSWORD
echo

# 2. MariaDB 설정 파일 생성
echo "Creating MariaDB configuration file for timezone..."
cat <<EOL > $HOST_CONFIG_FILE
[mysqld]
default-time-zone = '${TIME_ZONE}'
EOL

# 3. 기존 컨테이너 종료 및 삭제
echo "Stopping and removing existing container if it exists..."
docker stop $CONTAINER_NAME >/dev/null 2>&1 || true
docker rm $CONTAINER_NAME >/dev/null 2>&1 || true

# 4. 새 컨테이너 실행
echo "Starting new MariaDB container with timezone configuration..."
docker run --name $CONTAINER_NAME \
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -p 3000:3306 \
  -v $(pwd)/mariadb.cnf:/etc/mysql/mariadb.cnf \
  -d mariadb

# 5. 컨테이너 재시작 (설정 적용)
echo "Restarting MariaDB container to apply configuration..."
docker restart $CONTAINER_NAME

# 6. 시간대 설정 확인
echo "Verifying timezone configuration in MariaDB..."
docker exec -i $CONTAINER_NAME mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW VARIABLES LIKE 'time_zone';"


# USER 생성 및 권한 부여
# docker exec -i $CONTAINER_NAME mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
# CREATE USER 'user'@'%' IDENTIFIED BY 'password';
# GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' WITH GRANT OPTION;