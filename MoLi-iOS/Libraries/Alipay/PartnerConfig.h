//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088311843874216"
//收款支付宝账号
#define SellerID  @"zhifu@imooly.com"
//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"rlkrg70j6qsivz80ievys001pz2poe2g"
//商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALGMI7Fkrl802eqATmqbT5GpCqrVHR60sBXSWclm7cT8FHfIkEqMu7oRGQQMAtUoqNeh4byvqG1j8jvxXBV2Z/c1UABC8ZdAXqjXQp+6fqmfMnNzwvJP511Ff7u4T003J557tlVaU3nKnpD/mxVYJlsipC5iMQZ70DuTuMJrZO+JAgMBAAECgYBMhCzNwqozdb+EhI9G+nAsQkHKpdXK6ewJO4JeffFyt4DKrrEgr84nvj6ds990pfU+GRIEE1/u5Of8VWRuC316IMPY9SEdwzFN65+zaZtnqpGmX6h3/SjL3LaKtv/oyP7eUXE7O71lHyOlJYKWtg/8PTDjJCf00Fl/lUFvUL5pQQJBANhY8a1B4kjr4KL4b9dfJJKedzz9vXPt6+o3PXNMELvCi7PmfodDeeuS4qY/3yBL7V8luwXwzm5WrJD79Cet3A0CQQDSFrFBFWCY5wsWU/waPf/BjbRX/ajTaTWOvoKR7EnaIjAuT2qFQKWEi4PrbptBnia6fgx+e/WOqx7Y9kP3YbZtAkEAtfj6LtT/1H4ykGGPEQSB6qFHghGbTOuOR473LQeJ+6QDheoV+wgSgMcnxNZsgunaWvGNgc2ulLhqpfiGwOlH8QJAbNDWJKjG7MuXAYykoo8EXqNgCsdW35G57OKeTKi/o91baVE3Eifm011UCeizP+yDkMri+8yG5suZYbVEhOi2jQJBAKuT4aYsIMw7NZi15R0KZobuoKRsMvbdHbx3u60QIKX6H2a0sYRbhn6PPhAxbSSYPEE7s9vwyVEnMglBIZckTo4="
//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"
