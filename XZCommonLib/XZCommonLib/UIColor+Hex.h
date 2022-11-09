//
//  UIColor+Hex.h
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (instancetype)colorWithHexString:(NSString *)hexString;

+ (instancetype)colorWithHex:(int)hexNumber alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
