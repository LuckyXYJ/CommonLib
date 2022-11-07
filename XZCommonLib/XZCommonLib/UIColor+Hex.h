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

@end

NS_ASSUME_NONNULL_END
