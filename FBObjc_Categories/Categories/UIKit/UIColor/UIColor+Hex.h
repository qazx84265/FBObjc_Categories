//
//  UIColor+Hex.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
 *  Hex string to UIColor. eg. '0x1a2b3c' or '#1a2b3c' or '1a2b3c'"
 */
+ (UIColor*)ColorWithHexString:(NSString*)hexString;
+ (UIColor*)ColorWithHexString:(NSString*)hexString alpha:(CGFloat)alpha;
- (UIColor*)initWithHexString:(NSString*)hexString;
- (UIColor*)initWithHexString:(NSString*)hexString alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
- (NSString *)HEXString;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue;
@end
