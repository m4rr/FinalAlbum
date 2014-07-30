//
//  UIImageView+Popup.h
//  POPO
//
//  Created by Final on 14-7-29.
//  Copyright (c) 2014年 FinalProject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Popup)
@property (nonatomic) BOOL popupable;
@property (nonatomic,strong) UIView *popupBackgroundView;
@property (nonatomic,strong) UIImageView *popupImageView;
@property (nonatomic,strong) UITapGestureRecognizer *popupTap;
-(void)popup;
-(void)dismiss;
@end
