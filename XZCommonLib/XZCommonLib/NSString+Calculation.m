//
//  NSString+Calculation.m
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import "NSString+Calculation.h"
#import "CommonFont.h"
#import "Dimens.h"

@implementation NSString (Calculation)

- (CGRect)calculateLabelRectWithWidth:(float)width fontsize:(float)fontsize {
    return [self calculateLabelRectWithSize:CGSizeMake(width, MAXFLOAT) font:Font(fontsize)];
}

- (CGRect)calculateLabelRectWithSize:(CGSize)size font:(UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName : font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    return [self boundingRectWithSize:size options:(NSStringDrawingOptions)options attributes:attributes context:nil];
}

- (CGRect)calculateLabelRectWithHeight:(float)height fontSize:(float)fontsize {
    return [self calculateLabelRectWithSize:CGSizeMake(MAXFLOAT, height) font:Font(fontsize)];
}

- (CGFloat)calculateLabelWidthWithHeight:(float)height fontSize:(float)fontsize {
    CGRect rect = [self calculateLabelRectWithSize:CGSizeMake(MAXFLOAT, height) font:Font(fontsize)];
    return ceil(rect.size.width);
}

- (CGFloat)calculateLabelHeightWithWidth:(float)width fontsize:(float)fontsize {
    CGRect rect = [self calculateLabelRectWithSize:CGSizeMake(width, MAXFLOAT) font:Font(fontsize)];
    return ceil(rect.size.height);
}
- (CGFloat)calculateLabelHeightWithWidth:(float)width font:(UIFont*)font {
    CGRect rect = [self calculateLabelRectWithSize:CGSizeMake(width, MAXFLOAT) font:font];
    return ceil(rect.size.height);
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (int)charCount {
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return strlength;
}

//小写转大写
- (NSString *)stringToUpper:(NSString *)str {
    for (NSInteger i = 0; i < str.length; i++) {
        if ([str characterAtIndex:i] >= 'a' & [str characterAtIndex:i] <= 'z') {
            char temp = [str characterAtIndex:i] - 32;
            NSRange range = NSMakeRange(i, 1);
            str = [str stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return str;
}

//判断是否是字母
- (BOOL)stringLetter:(NSString *)str {
    NSString *regex = @"[A-Za-z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([predicate evaluateWithObject:str]) {
        return YES;
    }else {
        return NO;
    }
}

@end
