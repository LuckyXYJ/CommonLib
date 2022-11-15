//
//  UIUtils.m
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import "UIUtils.h"

@implementation UIUtils

UIViewController * CurrentDisplayController(){
    UIWindow *window = CurrentAppWindow();
    if (!window) return nil;
    UIViewController *viewController = [window rootViewController];
    if (!viewController) return nil;
    return GetTopViewController(viewController);
}

UIWindow *CurrentAppWindow(){
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWindow in windows) {
            if (tmpWindow.windowLevel == UIWindowLevelNormal) {
                return tmpWindow;
            }
        }
    }
    return window;
}

UIViewController *GetTopViewController(UIViewController *viewController){
    UIViewController *result;
    if ([viewController presentedViewController]) {
        UIViewController *controller = viewController.presentedViewController;
        result = GetTopViewController(controller);
    }else if ([viewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *nvc  = (UINavigationController *)viewController;
        UIViewController *controller = nvc.visibleViewController;
        result = GetTopViewController(controller);
    }else if ([viewController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController *)viewController;
        UIViewController *controller = tab.selectedViewController;
        result = GetTopViewController(controller);
    }else{
        result = viewController;
    }
    return result;
}

@end
