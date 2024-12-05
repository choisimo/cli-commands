#!/bin/bash

# 이 스크립트는 Ubuntu 시스템에 Docker를 설치합니다.
echo "Docker 설치 시작"

# SUDO 권한 확인
if [ "$(id -u)" != "0" ]; then
    echo "이 스크립트는 루트 권한으로 실행해야 합니다. SUDO를 사용하세요."
    exit 1
fi

# 1. 패키지 목록 업데이트
echo "패키지 목록 업데이트 중..."
apt update -y

# 2. Docker 설치에 필요한 패키지 설치
echo "Docker 설치에 필요한 패키지 설치 중..."
apt install -y apt-transport-https ca-certificates curl software-properties-common

# 3. Docker GPG 키 추가
echo "Docker GPG 키 추가 중..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 4. Docker 저장소 설정
echo "Docker 저장소 설정 중..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# 5. 패키지 목록 업데이트
echo "Docker 패키지 목록 업데이트 중..."
apt update -y

# 6. Docker 엔진, CLI 및 containerd 설치
echo "Docker 엔진, CLI 및 containerd 설치 중..."
apt install -y docker-ce docker-ce-cli containerd.io

# 7. Docker 서비스 시작 및 활성화
echo "Docker 서비스 시작 및 활성화 중..."
systemctl start docker
systemctl enable docker

# 8. 현재 사용자를 Docker 그룹에 추가
echo "현재 사용자를 Docker 그룹에 추가 중..."
if [ "$USER" = "root" ]; then
    echo "root 계정은 docker 그룹에 추가할 필요가 없습니다."
else
    usermod -aG docker "$USER"
    echo "Docker 그룹에 사용자를 추가했습니다. 적용하려면 로그아웃 후 다시 로그인하세요."
fi

echo "Docker 설치 및 설정이 완료되었습니다."
