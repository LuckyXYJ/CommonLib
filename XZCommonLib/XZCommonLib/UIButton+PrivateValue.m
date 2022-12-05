//
//  UIButton+PrivateValue.m
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import "UIButton+PrivateValue.h"
#import <objc/runtime.h>

@implementation UIButton (PrivateValue)

- (NSString *)buttonKey {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setButtonKey:(NSString *)buttonKey {
    objc_setAssociatedObject(self, @selector(buttonKey), buttonKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)callbackKey {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCallbackKey:(NSString *)callbackKey {
    objc_setAssociatedObject(self, @selector(callbackKey), callbackKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
