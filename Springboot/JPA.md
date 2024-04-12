## 복합키

    - 복합키 객체 생성
    alarmsReadsId id = new alarmsReadsId(alarmId, userId);

    - alarm_reads entity 생성
    alarm_reads alarmRead = new alarm_reads();
    alarmRead.setId(id);
