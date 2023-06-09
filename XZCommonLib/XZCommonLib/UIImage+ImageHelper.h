//
//  UIImage+ImageHelper.h
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ImageHelper)

+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image;

+ (UIImage *)imageWithBgColor:(UIColor *)color;

+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage;

@end

NS_ASSUME_NONNULL_END
