//
//  Sign.h
//  Sign
//
//  Created by zhangwenqiang on 16/6/19.
//  Copyright © 2016年 ishi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString * SYHSignName NS_EXTENSIBLE_STRING_ENUM;

@interface Sign : NSObject

+(NSString*)sign:(id)parameters;

extern SYHSignName const SYHSignAppKey;
extern SYHSignName const SYHSignAppValue;

@end
