//
//  UIColor+Hex.m
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (instancetype)colorWithHex:(int)hexNumber alpha:(CGFloat)alpha {
    
    if (hexNumber > 0xFFFFFF) return nil;
    
    CGFloat red   = ((hexNumber >> 16) & 0xFF) / 255.0;
    CGFloat green = ((hexNumber >> 8) & 0xFF) / 255.0;
    CGFloat blue  = (hexNumber & 0xFF) / 255.0;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    return color;
    
}

+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha{
    
    hexString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    UIColor *defaultColor = [UIColor clearColor];
    
    if (hexString.length < 6) return defaultColor;
    if ([hexString hasPrefix:@"#"]) hexString = [hexString substringFromIndex:1];
    if ([hexString hasPrefix:@"0X"]) hexString = [hexString substringFromIndex:2];
    if (hexString.length != 6) return defaultColor;
    
    //method1
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned int hexNumber;
    if (![scanner scanHexInt:&hexNumber]) return defaultColor;
    
    //method2
    const char *char_str = [hexString cStringUsingEncoding:NSASCIIStringEncoding];
    int hexNum;
    sscanf(char_str, "%x", &hexNum);
    
    return [UIColor colorWithHex:hexNumber alpha:alpha];
}

+ (instancetype)colorWithHexString:(NSString *)hexString{
    return [UIColor colorWithHexString:hexString alpha:1.0f];
}

@end
