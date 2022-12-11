//
//  NSString+Calculation.h
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Calculation)

- (CGRect)calculateLabelRectWithSize:(CGSize)size font:(UIFont *)font;
- (CGRect)calculateLabelRectWithWidth:(float)width fontsize:(float)fontsize;
- (CGRect)calculateLabelRectWithHeight:(float)height fontSize:(float)fontsize;
- (CGFloat)calculateLabelWidthWithHeight:(float)height fontSize:(float)fontsize;
- (CGFloat)calculateLabelHeightWithWidth:(float)width fontsize:(float)fontsize;
- (CGFloat)calculateLabelHeightWithWidth:(float)width font:(UIFont*)font;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

//计算NSString中英文字符串的字符长度。ios 中一个汉字算2字符数
- (int)charCount;

//小写转大写
- (NSString *)stringToUpper:(NSString *)str;
//判断是否是字母
- (BOOL)stringLetter:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
