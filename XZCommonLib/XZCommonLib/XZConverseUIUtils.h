//
//  XZConverseUIUtils.h
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZConverseUIUtils : NSObject

extern UIView * _Nullable drawLine(UIColor *color);

extern UILabel * _Nullable createLabelWithText(NSString *_Nullable text, CGFloat fontSize, UIColor * _Nullable textColor);

extern UITextField * _Nullable createTextFieldWithPlaceholder(NSString *placeholder, UIColor * _Nullable textColor, BOOL enable);

extern UIButton * _Nullable createBtnWithTitle(NSString *title, UIColor *titleColor, NSString * _Nullable backgroundImage, NSString * _Nullable disableImage, BOOL enable);

@end

NS_ASSUME_NONNULL_END
