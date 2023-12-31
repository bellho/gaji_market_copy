package kh.spring.gaji.pay.model.dto;
import org.springframework.stereotype.Component;
import lombok.Data;

@Component
@Data
public class DealReviewDto {
    private String goodsId;
    private String userId;
    private String message;
    private int mannerPoint;
    private int timePoint;
    private int goodsPoint;
    private int result1;
}