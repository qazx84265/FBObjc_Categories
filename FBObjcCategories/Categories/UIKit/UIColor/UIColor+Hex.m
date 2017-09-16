//
//  UIColor+Hex.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "UIColor+Hex.h"

#ifdef DEBUG
#define kColorConvertErrorHexStringFormat  @"Wrong hex string format.  Use like this:'0x1a2b3c' or '#1a2b3c' or '1a2b3c'"
#define kColorConvertErrorAlphaFormat      @"Wrong alpha value. Must be in [0.0, 1.0], otherwise will be set to 1.0"
#endif

CGFloat colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@implementation UIColor (Hex)


+ (UIColor*)ColorWithHexString:(NSString *)hexString {
    return [[UIColor alloc] initWithHexString:hexString];
}

+ (UIColor*)ColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    return [[UIColor alloc] initWithHexString:hexString alpha:alpha];
}

- (UIColor*)initWithHexString:(NSString *)hexString {
    return [self initWithHexString:hexString alpha:1.0];
}

- (UIColor*)initWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    CGFloat _red = 0.0;
    CGFloat _green = 0.0;
    CGFloat _blue = 0.0;
    CGFloat _alpha = 1.0;
    
    //rgb
    if (hexString.length >= 6) {
        NSString *tempString = [hexString lowercaseString];
        if ([tempString hasPrefix:@"0x"]) {
            tempString = [tempString substringFromIndex:2];
        } else if ([tempString hasPrefix:@"#"]) {
            tempString = [tempString substringFromIndex:1];
        } else {
            //--
        }
        
        if (tempString.length == 6) {
            NSScanner *scanner = [[NSScanner alloc] initWithString:tempString];
            uint64_t hexValue = 0;
            if ([scanner scanHexLongLong:&hexValue]) {
                _red = ((hexValue & 0xFF0000) >> 16)/255.0;
                _green = ((hexValue & 0x00FF00) >> 8)/255.0;
                _blue = (hexValue & 0x0000FF)/255.0;
            }
        } else {
#ifdef DEBUG
            NSLog(kColorConvertErrorHexStringFormat);
#endif
        }
    } else {
#ifdef DEBUG
        NSLog(kColorConvertErrorHexStringFormat);
#endif
    }
    
    //alpha
    if (alpha >= 0.0 && alpha <= 1.0) {
        _alpha = alpha;
    } else {
#ifdef DEBUG
        NSLog(kColorConvertErrorAlphaFormat);
#endif
    }
    
    return [self initWithRed:_red green:_green blue:_blue alpha:_alpha];
}



+ (UIColor *)colorWithHex:(UInt32)hex{
    return [UIColor colorWithHex:hex andAlpha:1];
}
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0
                           green:((hex >> 8) & 0xFF)/255.0
                            blue:(hex & 0xFF)/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = colorComponentFrom(colorString, 0, 1);
            green = colorComponentFrom(colorString, 1, 1);
            blue  = colorComponentFrom(colorString, 2, 1);
            break;
            
        case 4: // #ARGB
            alpha = colorComponentFrom(colorString, 0, 1);
            red   = colorComponentFrom(colorString, 1, 1);
            green = colorComponentFrom(colorString, 2, 1);
            blue  = colorComponentFrom(colorString, 3, 1);
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = colorComponentFrom(colorString, 0, 2);
            green = colorComponentFrom(colorString, 2, 2);
            blue  = colorComponentFrom(colorString, 4, 2);
            break;
            
        case 8: // #AARRGGBB
            alpha = colorComponentFrom(colorString, 0, 2);
            red   = colorComponentFrom(colorString, 2, 2);
            green = colorComponentFrom(colorString, 4, 2);
            blue  = colorComponentFrom(colorString, 6, 2);
            break;
            
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)HEXString{
    UIColor* color = self;
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha/1.0];
}

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
{
    return [self colorWithWholeRed:red
                             green:green
                              blue:blue
                             alpha:1.0];
}
@end
