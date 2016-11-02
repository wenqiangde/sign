//
//  Sign.m
//  Sign
//
//  Created by zhangwenqiang on 16/6/19.
//  Copyright © 2016年 ishi. All rights reserved.
//

#import "Sign.h"
#import <CommonCrypto/CommonDigest.h>
//lipo -create 路径1/libPrintTest.a 路径2/libPrintTest.a -output 路径3/libPrintTest.a

@implementation Sign

SYHSignName const SYHSignAppKey = @"ios_syh_sign_app_key";
SYHSignName const SYHSignAppValue = @"ios_syh_sign_app_value";

+(NSString*)sign:(id)parameters{
    
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary * dic = parameters;
        
        NSMutableArray* allKeys = [NSMutableArray arrayWithArray:dic.allKeys];
        
        [allKeys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            return [obj1 compare:obj2];
        }];
        
        NSString * keyString = nil;
        
        NSString * valueString = nil;
        
        id keyObj = [[NSUserDefaults standardUserDefaults] objectForKey:SYHSignAppKey];
        
        id valueObj = [[NSUserDefaults standardUserDefaults] objectForKey:SYHSignAppValue];
        
        if ([keyObj isKindOfClass:[NSString class]]) {
            
            keyString = [NSString stringWithFormat:@"%@",keyObj];
        }
        else {
            
            NSLog(@"appKey is NULL"); return @"";
        }
        
        if ([valueObj isKindOfClass:[NSString class]]) {
            
            valueString = [NSString stringWithFormat:@"%@",valueObj];
        }
        else {
            
            NSLog(@"appValue is NULL"); return @"";
        }
        
        //NSString* apiKey = [NSString stringWithFormat:@"%@=%@",keyString,valueString];
        
        NSMutableString* sign = [NSMutableString string];
        
        [allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString* val = [NSString stringWithFormat:@"%@",[dic objectForKey:key]];
            
            if (!(val == nil || val.length == 0)) {
                
                [sign appendString:key];
                [sign appendString:@"="];
                [sign appendString:[val lowercaseString]];
                if (!(allKeys.count-1 == idx)) {
                    [sign appendString:@"&"];
                }
            }
        }];
        
        [sign appendString:/*apiKey*/valueString];
        
        //NSLog(@"sign-->%@,md5-->%@",sign,[Sign md5:[Sign md5:sign]]);
        
        return [Sign md5:[Sign md5:sign]];
    }
    
    return @"";
}

+(NSString*)MD5:(NSString*)string{
    //大写
    return [[Sign digest:string] uppercaseString];
    
}

+ (NSString*)md5:(NSString*)string{
    //小写
    return [[Sign digest:string] lowercaseString];
}

+ (NSString*)digest:(NSString*)string{

    NSNumber * number = [NSNumber numberWithLongLong:strlen([string UTF8String])];
    
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
    return s;
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
                                               
                                               //NSArray * systemConfigList = [objData objectForKey:@"systemConfigList"];
                                           }
                                       }
                                   }
                               }
                               
                           }];
}

@end


