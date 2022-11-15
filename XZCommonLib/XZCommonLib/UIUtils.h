//
//  UIUtils.h
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIUtils : NSObject

/**
 *  获取当前正被展示的页面控制器
 *
 *  @return 控制器对象
 */
extern UIViewController * _Nullable CurrentDisplayController(void);

/**
 *  获取当前应用被展示的Window
 *
 *  @return Window对象
 */
extern UIWindow * _Nullable CurrentAppWindow(void);

/**
 *  获取某页面控制器栈顶的控制器对象
 *
 *  @param viewController 目标查询控制器对象
 *
 *  @return 栈顶控制器对象
 */
extern UIViewController * _Nonnull GetTopViewController(UIViewController * _Nonnull viewController);


@end

NS_ASSUME_NONNULL_END
