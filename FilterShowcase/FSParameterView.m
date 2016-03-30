//
//  FSParameterView.m
//  filtershow
//
//  Created by seal on 3/30/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//

#import "FSParameterView.h"

@implementation FSParameterView

- (id)initWithFrame:(CGRect)frame btnArray:(NSArray *)arr
{
    self = [super initWithFrame:frame];
    
    paraArr = [NSArray arrayWithArray:arr];
    
    //scrollview
    UIScrollView *guideScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICEW, DEVICEH)];
    guideScrollView.backgroundColor = [UIColor blackColor];
    guideScrollView.alpha = 0.5;
    
    //模糊视图
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
        UIView *guideBgView = [[UIView alloc] init];
        guideBgView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.9];
        guideBgView.frame = CGRectMake(0, 0, DEVICEW, DEVICEH);
        [self addSubview:guideBgView];
        [guideBgView addSubview:guideScrollView];
    } else {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        guideBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        guideBlurView.frame = CGRectMake(0, 0, DEVICEW, DEVICEH);
        guideBlurView.userInteractionEnabled = YES;
        [self addSubview:guideBlurView];
        [guideBlurView addSubview:guideScrollView];
    }
    
    //label
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICEW/2-50, 15, 100, 40)];
    tipLabel.font = F(16);
    tipLabel.textColor = [UIColor whiteColor];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    tipLabel.alpha = 0.3;
    tipLabel.text = @"Parameters";
    [guideScrollView addSubview:tipLabel];
    
    //button
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(DEVICEW-50, 15, 40, 40);
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btn setImage:IMG(@"btn_close_white") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hideGuideView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [guideScrollView addSubview:btn];
    }
    
    for (int i = 0; i < [paraArr count]; i++) {
        UILabel *lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(DEVICEW/2-100, 120+i*45, 200, 30);
        [guideScrollView setContentSize:CGSizeMake(DEVICEW, DEVICEH)];
        
        lbl.tag = i;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.font = F(13);
        lbl.textColor = [UIColor whiteColor];
        lbl.text = paraArr[i];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [guideScrollView addSubview:lbl];
    }
    return self;
}

- (void)hideGuideView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideParameterView)]) {
        [self.delegate hideParameterView];
    }
}

@end
