//
//  UIView+Boundary.h
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

struct Boundary {
    CGFloat left;
    CGFloat right;
    CGFloat top;
    CGFloat bottom;
};
typedef struct Boundary Boundary;

extern Boundary BoundaryMake(CGFloat left, CGFloat right, CGFloat top, CGFloat bottom);

extern const Boundary BoundaryZero;

@interface UIView (Boundary)

@property (nonatomic) Boundary boundary;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint origin;

- (void)moveToTop:(CGFloat)top left:(CGFloat)left;
- (void)moveToTop:(CGFloat)top right:(CGFloat)right;
- (void)moveToBottom:(CGFloat)bottom left:(CGFloat)left;
- (void)moveToBottom:(CGFloat)bottom right:(CGFloat)right;

@end

NS_ASSUME_NONNULL_END
