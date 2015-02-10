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
#define PartnerPrivKey @"MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBANz2U9O42flxxwD8LJ9VbUUG1fqJc4pb5aQN3ZIlmyemAKghcsIF1MJr9o99Q6KJ1s5qFugyQSLrp704OpWHfM61ADzXU/3yRLUFS5wVZjkdzM81GMXQflfewOQAzzJDpfG/dF3pDVoBe/QYxJ/GvFp4hiLebr7WyMpZpV3peRDnAgMBAAECgYEAsbAtDQ+TyjKi07n2sFLkQiQTIxwxm8v2yYyU55fyQ1oNISd0v24tAAQODKmxIB40bV2G+kafdtOG2nVDN0fzJk/7TR8gSOA0VoWIXv1Gfd1NFKczjkc8coP9VebDuB58lUeqbNihs11NKMs2avbGq6yxNmDZutEUvV5xl0GyMsECQQD62XZtOcqchmKDs8ciP+9eOM0s0abaiqwDVziibq2CGXZlUks9kTgnGC2R4VnPLWmQwxYLL5INqqCo9+YjgjlXAkEA4X/E0bJAADxe86cP+tirXZ4BQPa91gZavpHU7c+nZhQfsxXH7V6PTqCP0eaxL4m4zeVyGpBnV/0hMYhgoDva8QJBAKanWvpt7qHW1hRRl/a1Kz4Z1pX0IzoF7wm5JLMlfLh2WiYuajZZCElQ0tWcNaJitUOrmDWOQSY7OcmICKmGlrkCQQCHTj8vBCHbAl6HHMs93RyWQ+TEskkeTxnMF30IZP0xBwouTvdzurWKnFUvwZi3yY+WHALnZZZc+YodSpOQEdpBAkEA0rLTonhpBRabrRhxsLfYpCmWt+6k/kIZaEq52WMxKHnrugrx+yjDhR7tRap8aqrVuzCytk/se6nZYZ/4N8BHqg=="
//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"
