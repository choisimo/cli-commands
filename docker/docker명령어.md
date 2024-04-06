  $ sudo usermod -aG docker $USER
  도커 설치 후 기본적으로 실행권한은 root 에 있으므로
  원하는 유저 접근 권한 부여

  #### 재시작 할 때마다 자동 재시작
  docker run -d --restart always <container_name>
