//
//  UIViewController+NavbarItemCategory.h
//  shiritan
//
//  Created by Seamus on 14-7-2.
//  Copyright (c) 2014年 Seamus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavbarItemCategory)
- (void)setRight:(SEL)action title:(NSString *)_t;
- (void)setRight:(SEL)action image:(NSString *)_imgname highlight:(NSString *)_himg;
- (void)setLeft:(SEL)action title:(NSString *)_t;
- (void)setLeft:(SEL)action image:(NSString *)_imgname highlight:(NSString *)_himg;
- (void)setBackSel:(SEL)action;
- (void)setBackToSearch:(SEL)action;
- (void)setSRTTitle:(NSString *)title;
- (void)setTitleImg:(NSString *)imgname;
@end
