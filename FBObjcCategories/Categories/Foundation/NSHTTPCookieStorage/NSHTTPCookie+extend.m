//
//  NSHTTPCookie+extend.m
//  FBObjcCategoriesDemo
//
//  Created by FB on 2018/1/28.
//  Copyright © 2018年 FB. All rights reserved.
//

#import "NSHTTPCookie+extend.h"

@implementation NSHTTPCookie (extend)
- (NSString *)getCookieString
{
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;expiresDate=%@;path=%@;sessionOnly=%@;isSecure=%@;isHTTPOnly=%@",
                        self.name,
                        self.value,
                        self.domain,
                        self.expiresDate,
                        self.path ?: @"/",
                        self.isSecure ? @"TRUE":@"FALSE",
                        self.sessionOnly ? @"TRUE":@"FALSE",
                        self.isHTTPOnly ? @"TRUE":@"FALSE"
                        ];
    
    return string;
}
@end
