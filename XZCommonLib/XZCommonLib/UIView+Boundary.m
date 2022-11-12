//
//  UIView+Boundary.m
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import "UIView+Boundary.h"

Boundary BoundaryMake(CGFloat left, CGFloat right, CGFloat top, CGFloat bottom)
{
    struct Boundary boundary;
    boundary.left = left;
    boundary.right = right;
    boundary.top = top;
    boundary.bottom = bottom;
    return boundary;
}

const Boundary BoundaryZero = {
    .left = 0,
    .right = 0,
    .top = 0,
    .bottom = 0
};

@implementation UIView (Boundary)

- (Boundary)boundary
{
    return BoundaryMake(self.left, self.right, self.top, self.bottom);
}

- (void)setBoundary:(Boundary)boundary
{
    [self setFrame:CGRectMake(boundary.left, boundary.top, boundary.right-boundary.left, boundary.bottom-boundary.top)];
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)point
{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

- (void)moveToTop:(CGFloat)top left:(CGFloat)left
{
    self.origin = CGPointMake(left, top);
}

- (void)moveToTop:(CGFloat)top right:(CGFloat)right
{
    self.origin = CGPointMake(right-self.width, top);
}

- (void)moveToBottom:(CGFloat)bottom left:(CGFloat)left
{
    self.origin = CGPointMake(left, bottom-self.height);
}

- (void)moveToBottom:(CGFloat)bottom right:(CGFloat)right
{
    self.origin = CGPointMake(right-self.width, bottom-self.height);
}

@end
