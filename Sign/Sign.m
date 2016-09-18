//
//  Sign.m
//  Sign
//
//  Created by zhangwenqiang on 16/6/19.
//  Copyright © 2016年 ishi. All rights reserved.
//

#import "Sign.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Sign

+(NSString*)sign:(NSMutableDictionary*)dic{
    NSMutableArray* allKeys = [NSMutableArray arrayWithArray:dic.allKeys];
    [allKeys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [((NSString*)obj1) compare: ((NSString*)obj2)];
    }];
    
    NSMutableString* sign = [NSMutableString string];
    NSString* apiKey = @"key=e2460167D9b64yf7je2Y65B405a5362a";
    
    for (NSString* key in allKeys) {
        NSString* val = [dic objectForKey:key];
        if (!(val == nil || val.length == 0)) {
            [sign appendString:key];
            [sign appendString:@"="];
            [sign appendString:val];
            [sign appendString:@"&"];
        }else{
            continue;
        }
    }
    [sign appendString:apiKey];
    return [Sign md5:[Sign md5:sign]];
}

+(NSString*)MD5:(NSString*)string{
    
    NSNumber * number = [NSNumber numberWithLongLong:strlen([string UTF8String])];
    
    //大写
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    CC_MD5_Update(&md5, [string UTF8String], [number intValue]);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *s = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],  digest[2],  digest[3],
                   digest[4],  digest[5],  digest[6],  digest[7],
                   digest[8],  digest[9],  digest[10], digest[11],
                   digest[12], digest[13], digest[14], digest[15]];
    return [s uppercaseString];
    
}

+ (NSString*)md5:(NSString*)string{
    
    NSNumber * number = [NSNumber numberWithLongLong:strlen([string UTF8String])];
    
    //小写
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    CC_MD5_Update(&md5, [string UTF8String], [number intValue]);//strlen([content UTF8String])
    unsigned char digest[CC_MD5_BLOCK_LONG];
    CC_MD5_Final(digest, &md5);
    NSString *s = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],  digest[2],  digest[3],
                   digest[4],  digest[5],  digest[6],  digest[7],
                   digest[8],  digest[9],  digest[10], digest[11],
                   digest[12], digest[13], digest[14], digest[15]];
    return [s lowercaseString];
}

//{
//code: 0,
//msg: "",
//data: {
//systemConfigList: [
//    {
//    key: "appSignKey",
//    value: "sheyuanhui"
//    }
//                   ]
//},
//timestamp: 1474188576648
//}

+ (void)requestKey{

    NSString * URLString = [[NSUserDefaults standardUserDefaults] objectForKey:@"GETURL"];
    
    if (URLString == nil || URLString.length == 0) { return; }
    
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *requst = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:10];
    //异步链接(形式1,较少用)
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
                               if (error) {
                                   NSLog(@"error->%@",[error description]);
                               }
                               else {
                                   // 解析
                                   id responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                       options:NSJSONReadingMutableContainers
                                                                                         error:nil];
                                   
                                   if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                       
                                       if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
                                           
                                           id objData = [responseObject objectForKey:@"data"];
                                           
                                           if (objData != nil) {
                                               
                                               NSArray * systemConfigList = [objData objectForKey:@"systemConfigList"];
                                           }
                                       }
                                   }
                               }
        
    }];
}

@end


