<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>안전거래 상세조회</title>
<!--favicon  -->
<link rel="icon"
	href="${pageContext.request.contextPath}/resources/img/favicon.ico">
<link rel="shortcut icon"
	href="${pageContext.request.contextPath}/resources/img/favicon.ico">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link href="${pageContext.request.contextPath}/resources/css/mypage/buyer.css" rel='stylesheet' type='text/css'>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</head>
<body>



<div class="container top">
<h1>안전거래 상세조회</h1>
</div>
<div class="container">
    <c:if test="${safePurchaseInfoDto.tradingStatus eq 1}">
        <button onclick="cancel('${safePurchaseInfoDto.transactionId}','${safePurchaseInfoDto.goodsId}')" class="btn-p">결제취소</button>
    </c:if>

<!-- 모달 트리거 버튼 -->
<button type="button" id="showReportModalBtn" data-toggle="modal" data-target="#reportModal">
  신고하기
</button>
 <c:if test="${reviewYN eq 0}">
        <button onclick="redirectReview()">리뷰작성</button>
 </c:if>

<!-- 신고하기 모달 -->
<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="reportModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="reportModalLabel">신고하기</h5>
      </div>
      <div class="modal-body">
        <form action="${pageContext.request.contextPath}/report" method="post">
          <div class="form-group">
            <label for="reportCategory">신고 카테고리</label>
            <select class="form-control" id="reportCategory" name="reportCategory">
              <option value="1">광고</option>
              <option value="2">욕설/비방</option>
              <option value="3">음란물</option>
              <option value="4">사기</option>
              <option value="5">기타</option>
            </select>
          </div>
          <input type="hidden" value="mypage/deal/safe/buyer?transactionId=${safePurchaseInfoDto.transactionId}" name="url">
          <input type="hidden" name="refId" value="${safePurchaseInfoDto.goodsId}">
          <div class="form-group">
            <label for="reportContent">신고 내용</label>
            <textarea class="form-control" id="reportContent" name="content" rows="10" required="required"></textarea>
          </div>
      <div class="modal-footer">
          <button type="submit" class="btn btn-p">신고 제출</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
      </div>
        </form>
      </div>
    </div>
  </div>
</div>


    <c:if test="${safePurchaseInfoDto.tradingStatus eq 3}">
        <button onclick="closePay('${safePurchaseInfoDto.transactionId}','${safePurchaseInfoDto.goodsId}')"  class="btn-p">결제확정</button>
    </c:if>
    
    <a href="${pageContext.request.contextPath}/goods/get?goodsId=${safePurchaseInfoDto.goodsId}"><p>상품명:${safePurchaseInfoDto.goodsTitle}</p></a>
    <p>상품가격:<fmt:formatNumber value="${safePurchaseInfoDto.price}" pattern="#,###"/></p>
    <p>판매자명:${safePurchaseInfoDto.sellerName}</p>
    <p>구매자명:${safePurchaseInfoDto.buyerName}</p>
    <p>휴대폰번호:${safePurchaseInfoDto.mobileNumber}</p>
    <p>배송지:${safePurchaseInfoDto.roadAddress}, ${safePurchaseInfoDto.detailAddress}</p>
    <p>거래일자:${safePurchaseInfoDto.tradingDate}</p>
    

    <c:choose>
        <c:when test="${safePurchaseInfoDto.tradingStatus eq 1}"><p>거래상태:입금완료</p></c:when>
        <c:when test="${safePurchaseInfoDto.tradingStatus eq 2}"><p>거래상태:상품준비중</p></c:when>
        <c:when test="${safePurchaseInfoDto.tradingStatus eq 3}"><p>거래상태:배송중</p></c:when>
        <c:when test="${safePurchaseInfoDto.tradingStatus eq 4}"><p>거래상태:거래완료</p></c:when>
        <c:when test="${safePurchaseInfoDto.tradingStatus eq 5}"><p>거래상태:결제취소</p></c:when>
    </c:choose>
	<p>
    <c:if test="${not empty safePurchaseInfoDto.trackingNumber}">
        운송장번호:
        <c:choose>
        <c:when test="${safePurchaseInfoDto.shippingCompany eq 1}">
        	대한통운
        </c:when>
        <c:when test="${safePurchaseInfoDto.shippingCompany eq 2}">
        	우체국택배
        </c:when>
        <c:when test="${safePurchaseInfoDto.shippingCompany eq 3}">
        	한진택배
        </c:when>
        <c:when test="${safePurchaseInfoDto.shippingCompany eq 4}">
        	로젠택배
        </c:when>
        </c:choose>
         ${safePurchaseInfoDto.trackingNumber}</p>
    </c:if>
		<button onclick="history.back()">이전으로</button>
</div>
<script>

<c:if test="${not empty msg}">
	alert("${msg}");
</c:if>

var cancel=(transactionId1,goodsId)=>{
	$.ajax({
		url:"${pageContext.request.contextPath}/payment/cancel",
		data:{transactionId:transactionId1,goodsId:goodsId},
		method: "post",
		dataType:"json",
		success:cancelCallBack,
		error : (request,status,error)=>{
			console.log(request);
			console.log(status);
			console.log(error);
			alert("code:"+request.status+"\n"+"message"+request.responseText+"\n"+error+":error");
		}
	});
}
var closePay=(transactionId1,goodsId)=>{
	$.ajax({
		url:"${pageContext.request.contextPath}/payment/closepay",
		data:{transactionId:transactionId1, goodsId:goodsId},
		method: "post",
		dataType:"text",
		success:closePayCallback,
		error : (request,status,error)=>{
			console.log(request);
			console.log(status);
			console.log(error);
			alert("code:"+request.status+"\n"+"message"+request.responseText+"\n"+error+":error");
		}
	});
}

function cancelCallBack(data){
	console.log("cancelCallBack들어옴");
	console.log(data);
	if(data.response.status=="cancelled"){
		alert("거래가 취소되었습니다");
		window.location.href="${pageContext.request.contextPath}/mypage/orderstatus/safe";
	}
	else
		alert("거래 취소에 실패하였습니다.");
}

function closePayCallback(data){
	console.log("ClosePayCallback들어옴");
	console.log(data);
	if(data=='1'){
		alert("거래가 확정되었습니다.");
		alert("리뷰를 작성페이지로 이동합니다.");
		window.location.href="${pageContext.request.contextPath}/mypage/dealreview?transactionId=${safePurchaseInfoDto.transactionId}";
	}
	else
		alert("거래 확정에 실패하였습니다.");
}

function redirectReview(){
	window.location.href="${pageContext.request.contextPath}/mypage/dealreview?transactionId=${safePurchaseInfoDto.transactionId}";
}
</script>
<script>
$(document).ready(function () {
    $('#reportModal').modal({
        backdrop: 'static', // 모달 바깥을 클릭해도 모달이 닫히지 않도록 설정
        show: false // 페이지 로드 시 모달을 표시하지 않도록 설정
    });

    // 신고하기 버튼을 클릭하면 모달을 표시
    $('#showReportModalBtn').click(function () {
        $('#reportModal').modal('show');
    });
    
    $('.btn-secondary').click(function(){
    	 $('#reportModal').modal('hide');
    })
});
</script>
</body>
</html>

