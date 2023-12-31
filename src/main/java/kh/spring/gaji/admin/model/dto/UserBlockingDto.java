package kh.spring.gaji.admin.model.dto;

import org.springframework.stereotype.Component;
import lombok.Data;

@Component
@Data
public class UserBlockingDto {
	private String bannedId; // 회원아이디 10자이내 영어로
	private String administerId; // 관리자ID
	private String adminId;
	private String reasonForBlocking; // 정지사유
	private int banNo;
	private String bandate;
	private String usercreated;
	private int enabled;
}
