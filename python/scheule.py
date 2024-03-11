import os
import subprocess
import datetime
import time

def execute_bat_file():
    bat_file_path = "C:\path\to\bat\file.bat"

    subprocess.call(bat_file_path, shell=True)

#  현재 시간 가지고 오기
now = datetime.datetime.now()
# 자동 실행 시킬 시간
target_time = datetime.time(9,0,0) 

while now.time() < target_time:
    time.sleep(60) # 1분마다 체크하기

execute_bat_file()