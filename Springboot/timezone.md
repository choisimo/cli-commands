springboot timezone 설정 방법

@SpringBootApplication 내부에 해당 코드 추가 


	@PostConstruct
	void start_time_zone() {
		TimeZone.setDefault(TimeZone.getTimeZone("Asia/Seoul"));
		log.info("<<< springboot server 시작 >>>");
		log.info("timezone : " + LocalDateTime.now());
	}
