//
//  UIImageView+Popup.m
//  POPO
//
//  Created by Final on 14-7-29.
//  Copyright (c) 2014年 FinalProject. All rights reserved.
//

#import "UIImageView+Popup.h"
#import <objc/runtime.h>
const CGFloat kAnimationDuration = 0.3f;
const CGFloat kBackgroundAlpha = 0.5f;

const static void *PopupableKey = &PopupableKey;
const static void *PopupBackgroundViewKey = &PopupBackgroundViewKey;
const static void *PopupImageViewKey = &PopupImageViewKey;
const static void *PopupTapKey = &PopupTapKey;

@implementation UIImageView (Popup)
//all property use lazy getter

-(BOOL)popupable
{
    return [objc_getAssociatedObject(self, PopupableKey) boolValue];
}

-(void)setPopupable:(BOOL)popupable
{
    objc_setAssociatedObject(self, PopupableKey, [NSNumber numberWithBool:popupable], OBJC_ASSOCIATION_ASSIGN);
    if (popupable) {
        [self addGestureRecognizer:self.popupTap];
        self.userInteractionEnabled = YES;
    }else{
        [self removeGestureRecognizer:self.popupTap];
        self.userInteractionEnabled = NO;
    }
}

-(UIView *)popupBackgroundView
{
    UIView *backgroundView = objc_getAssociatedObject(self, PopupBackgroundViewKey);
    if (nil == backgroundView) {
        backgroundView = [UIView new];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:kBackgroundAlpha];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        doubleTap.numberOfTapsRequired = 2;
        [backgroundView addGestureRecognizer:doubleTap];
        [backgroundView addSubview:self.popupImageView];
        self.popupBackgroundView = backgroundView;
    }
    return backgroundView;
}

-(void)setPopupBackgroundView:(UIView *)popupBackgroundView
{
    objc_setAssociatedObject(self, PopupBackgroundViewKey, popupBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImageView *)popupImageView
{
    UIImageView *imageView = objc_getAssociatedObject(self, PopupImageViewKey);
    if (nil == imageView) {
        imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.popupImageView = imageView;
    }
    return imageView;
}

-(void)setPopupImageView:(UIImageView *)popupImageView
{
    objc_setAssociatedObject(self, PopupImageViewKey, popupImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UITapGestureRecognizer *)popupTap
{
    UITapGestureRecognizer *tap = objc_getAssociatedObject(self, PopupTapKey);
    if (nil == tap) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popup)];
        tap.numberOfTapsRequired = 1;
        self.popupTap = tap;
    }
    return tap;
}

-(void)setPopupTap:(UITapGestureRecognizer *)popupTap
{
    objc_setAssociatedObject(self, PopupTapKey, popupTap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)popup
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIScreen *screen = [UIScreen mainScreen];
    CGRect originFrame = [self convertRect:self.bounds toView:window];
    
    self.popupBackgroundView.frame = screen.bounds;
    self.popupBackgroundView.hidden = YES;
    self.popupImageView.frame = originFrame;
    self.popupImageView.image = self.image;
    [window addSubview:self.popupBackgroundView];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.popupBackgroundView.hidden = NO;
        CGFloat width = CGRectGetWidth(screen.bounds);
        CGFloat height = CGRectGetHeight(screen.bounds);
        CGFloat viewHeight = self.image.size.height / self.image.size.width * width;
        self.popupImageView.frame = CGRectMake(0, (height - viewHeight) / 2, width, viewHeight);
    }];
}

-(void)dismiss
{
    CGRect originFrame = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.popupImageView.frame = originFrame;
    } completion:^(BOOL finished) {
        //unload all view
        self.popupBackgroundView.hidden = YES;
        [self.popupImageView removeFromSuperview];
        [self.popupBackgroundView removeFromSuperview];
        self.popupImageView = nil;
        self.popupBackgroundView = nil;
    }];
}
@end
