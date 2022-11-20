//
//  Dimens.h
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#ifndef Dimens_h
#define Dimens_h


static inline BOOL isFullScreen() {
    if (@available(iOS 11.0, *)) {
        UIWindow *w = [UIApplication sharedApplication].windows[0];
        return (UIEdgeInsetsEqualToEdgeInsets(w.safeAreaInsets, UIEdgeInsetsMake(44, 0, 34, 0)));
    }
    return NO;
}

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenScale (ScreenWidth <= 320 ? (ScreenWidth / 375.0) : 1)
#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define NavigationBarHeight 44.f
#define BoundsHeight ScreenHeight - StatusBarHeight - NavigationBarHeight
#define HeaderHeight (StatusBarHeight + NavigationBarHeight)
#define TabbarHeight 48.f
#define BottomCornerHeight (StatusBarHeight > 20 ? 38.f : 0.f)
#define BottomTabbarHeight (TabbarHeight + BottomCornerHeight)

#endif /* Dimens_h */
