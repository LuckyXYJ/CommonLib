//
//  UIButton+PrivateValue.h
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (PrivateValue)
@property (nonatomic, copy) NSString *buttonKey;        //jsbridge调用，为了点击button后callback传参

@property (nonatomic, copy) NSString *callbackKey;      //jsbridge回调的key
@end

NS_ASSUME_NONNULL_END
