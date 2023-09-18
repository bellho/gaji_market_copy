package kh.spring.gaji.trade.model.domain;

import org.springframework.stereotype.Component;
import lombok.Data;

@Component
@Data
public class SafeTradingDomain {
    private int transactionId;
    private String goodsTitle;
    private String sellerId;
    private String tradingStatus;
}