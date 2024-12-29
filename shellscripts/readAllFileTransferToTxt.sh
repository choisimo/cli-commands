#!/bin/bash

# 출력 파일 초기화
OUTPUT_FILE="get_id.txt"
> "$OUTPUT_FILE"  # 기존 내용을 비우기

# 현재 디렉토리의 모든 하위 디렉토리를 순회
find . -type f -name "mod.info" | while read MOD_INFO_FILE; do
  # mod.info 파일에서 id 값을 추출
  ID=$(grep -E "^id=" "$MOD_INFO_FILE" | cut -d'=' -f2)
  
  if [ -n "$ID" ]; then
    # id 값과 해당 파일의 디렉토리 이름 출력
    echo "$ID from $(dirname "$MOD_INFO_FILE")" >> "$OUTPUT_FILE"
  fi
done

echo "ID values saved to $OUTPUT_FILE."
