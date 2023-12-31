package kh.spring.gaji.user.controller;

import java.io.IOException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kh.spring.gaji.common.MailSendService;
import kh.spring.gaji.mypage.model.service.MypageService;
import kh.spring.gaji.region.model.service.RegionService;
import kh.spring.gaji.user.model.dto.UserDto;
import kh.spring.gaji.user.model.dto.UserInsertAddressDto;
import kh.spring.gaji.user.model.service.UserService;

@Controller
public class UserController {
	@Autowired
	private UserService userService;

	@Autowired
	private MailSendService mailService;
	
	@Autowired
	private RegionService regionService;
	
	@Autowired
	private MypageService myPageService;

	@Autowired
	private BCryptPasswordEncoder bCryptPasswordEncoder; 
	
	@GetMapping("/signup")
	public ModelAndView signup(ModelAndView mv) { // 개인회원가입
		mv.setViewName("user/signup");
		mv.addObject("dongList", regionService.dongList());
		mv.addObject("guList", regionService.guList());
		return mv;
	}

	@PostMapping("/signup")
	public String singupUser(UserDto userDto, RedirectAttributes ra, UserInsertAddressDto addressDto) {
		try {
			userDto.setPassword(bCryptPasswordEncoder.encode(userDto.getPassword()));
			if (userService.signup(userDto, addressDto) > 0) {
				ra.addFlashAttribute("msg", "계정 생성이 성공하였습니다.");
				return "redirect:/"; // 성공 시 메인 페이지로 리다이렉트
			} else {
				ra.addFlashAttribute("msg", "계정 생성이 실패하였습니다. 다시 시도해주십시오.");
				return "user/singup"; // 실패 시 다시 회원 가입 페이지로 이동
			}
		} catch (IOException e) {
			ra.addFlashAttribute("msg", "계정 생성이 실패하였습니다. 다시 시도해주십시오.");
			return "user/singup"; // 예외 발생 시 다시 회원 가입 페이지로 이동
		}
	}

	// 이메일 인증
	@GetMapping("/mailcheck")
	@ResponseBody
	public String mailCheck(String email) {
		System.out.println("이메일 인증 요청이 들어옴!");
		System.out.println("이메일 인증 이메일 : " + email);
		return mailService.joinEmail(email);
	}
	
	@GetMapping("/idfind")
	public String idFind() {
		return "user/idfindresult"; // 아이디 찾기 폼을 보여주는 뷰 이름
	}
	
	@PostMapping("/checkid")
	@ResponseBody
	public String checkId(String userId) {
		return userService.checkId(userId);
	}
	
	@PostMapping("/checknickname")
	@ResponseBody
	public String checkNickName(String nickname) {
		return userService.checkNickname(nickname);
	}
	
	@PostMapping("/checkmn")
	@ResponseBody
	public String checkMobileNumber(String mobileNumber) {
		return myPageService.checkMobilNumber(mobileNumber);
	}
	
	@PostMapping("/checkemail")
	@ResponseBody
	public String checkEmail(String email) {
		return myPageService.checkEmail(email);
	}

	@GetMapping("/idInquiry")
	public String idInquiry() { // 아이디찾기
		return "user/idInquiry";
	}

	@PostMapping("/idInquiry")
	public ModelAndView idFind(@RequestParam Map<String, String> map, ModelAndView mv) {
		String findId = userService.findId(map);
		mv.setViewName("user/idfindresult");
		mv.addObject("foundId", findId);
		return mv;
	}


	@GetMapping("/pwInquiry")
	public String pwInquiry() { // 비밀번호찾기
		return "user/pwInquiry";
	}
	
	@PostMapping("/pwInquiry")
	public ModelAndView pwFind(@RequestParam Map<String, String> map, ModelAndView mv, RedirectAttributes ra, UserDto userDto) {
		map.replace("password", bCryptPasswordEncoder.encode(map.get("password")));
		int chagePassword = userService.findPass(map);
		if(chagePassword == 1) {
			ra.addFlashAttribute("msg", "비밀번호 변경 완료");
			mv.setViewName("redirect:/login");
		}	else {
			
			ra.addFlashAttribute("msg", "비밀번호 변경 실패");
			mv.setViewName("redirect:/pwInquiry");
		}
		
		return mv;
		
	}
	
	@ExceptionHandler
	public String exception(Exception e, RedirectAttributes ra) {
		ra.addFlashAttribute("msg", "예기치않은 오류로 메인페이지로 이동합니다.");
		return "redirect:/";
	}
}
