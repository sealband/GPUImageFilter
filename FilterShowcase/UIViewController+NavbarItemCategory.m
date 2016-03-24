//
//  UIViewController+NavbarItemCategory.m
//  shiritan
//
//  Created by Seamus on 14-7-2.
//  Copyright (c) 2014年 Seamus. All rights reserved.
//

#import "UIViewController+NavbarItemCategory.h"

@implementation UIViewController (NavbarItemCategory)

#define IMG(_name) [UIImage imageNamed:_name]
#define TITLECOLOR [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1]
#define F(_size) [UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:_size]
#define FB(_size) [UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:_size]

- (void)setRight:(SEL)action title:(NSString *)_t
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 60, 30);
    [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnBack setTitle:_t forState:UIControlStateNormal];
    [btnBack.titleLabel setFont:F(16)];
    [btnBack.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [btnBack setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    [btnBack addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.rightBarButtonItem = backButtonItem;
}

- (void)setRight:(SEL)action image:(NSString *)_imgname highlight:(NSString *)_himg
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 44);
    [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnBack setImage:IMG(_imgname) forState:UIControlStateNormal];
    if (_himg) {
        [btnBack setImage:IMG(_himg) forState:UIControlStateHighlighted];
    }
    [btnBack addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.rightBarButtonItem = backButtonItem;
}

- (void)setLeft:(SEL)action image:(NSString *)_imgname highlight:(NSString *)_himg
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 44);
    [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnBack setImage:IMG(_imgname) forState:UIControlStateNormal];
    if (_himg) {
        [btnBack setImage:IMG(_himg) forState:UIControlStateHighlighted];
    }
    [btnBack addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)setLeft:(SEL)action title:(NSString *)_t
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 44);
    [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnBack setTitle:_t forState:UIControlStateNormal];
    [btnBack.titleLabel setFont:F(16)];
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnBack addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)setBackSel:(SEL)action
{
    NSString *imgname = @"menu_btn_back";
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 44, 40);
    [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnBack setImage:IMG(imgname) forState:UIControlStateNormal];
    [btnBack addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)setBackToSearch:(SEL)action
{
    NSString *imgname = @"menu_btn_back";
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 24, 40);
    [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnBack setImage:IMG(imgname) forState:UIControlStateNormal];
    [btnBack addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)setTitleView:(UIView *)_vv
{
    self.navigationItem.titleView = _vv;
}

- (void)setSRTTitle:(NSString *)title
{
    UILabel *vv = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 24)];
    vv.backgroundColor = [UIColor clearColor];
    vv.textColor = TITLECOLOR;
    vv.font = FB(14);
    vv.text = title;
    vv.textAlignment = NSTextAlignmentCenter;
    [self setTitleView:vv];
}

- (void)setTitleImg:(NSString *)imgname
{
    UIImage *img = IMG(imgname);
    UIImageView *vv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    vv.image = img;
    [self setTitleView:vv];
}

@end
