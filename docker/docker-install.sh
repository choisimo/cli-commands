# 이 스크립트는 Ubuntu 시스템에 Docker를 설치합니다.
# 다음 단계를 수행합니다:
# 1. 스크립트가 루트 권한으로 실행되는지 확인합니다.
# 2. 패키지 목록을 업데이트합니다.
# 3. Docker 설치에 필요한 패키지를 설치합니다.
# 4. Docker의 공식 GPG 키를 추가합니다.
# 5. Docker 저장소를 설정합니다.
# 6. Docker 패키지를 포함하도록 패키지 목록을 다시 업데이트합니다.
# 7. Docker 엔진, CLI 및 containerd를 설치합니다.
# 8. Docker 서비스를 시작하고 활성화합니다.
# 9. 현재 사용자를 Docker 그룹에 추가합니다 (root 사용자는 제외).
### for ubuntu
  
echo "Docker install"

# SUDO id - u 권한 확인
if [ $(id -u) != "0"]; then
    echo " 권한으로 실행해주세요."
    exit 1

sudo apt update

sudo apt install apt-transport-https ca-certificates curl software-properties-common

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |  tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io

sudo systemctl start docker
sudo systemctl enable docker

# current user add docker group
echo "Add ${USER} to docker group"
if ${USER} == "root"; then
    echo "root 계정은 docker 그룹에 추가할 수 없습니다."
fi
sudo usermod -aG docker ${USER}
