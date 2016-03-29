//
//  SliderView.m
//  FilterShowcase
//
//  Created by seal on 3/18/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//

#import "FSSliderView.h"

@implementation FSSliderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

//- (void)gestureRecognizer:(UIPanGestureRecognizer *)gesture
//{
//    CGPoint p = [gesture locationInView:self];
//    float offset = (DEVICEW-320)/2;
//    float x = MIN(MAX(offset, p.x),DEVICEW-offset);
//    x = x-offset;
//    float s = x/320.0;
//    [sliderView setValue:(int)(sliderView.minimumValue+(sliderView.maximumValue-sliderView.minimumValue)*s)];
//    
//    if (gesture.state == UIGestureRecognizerStateEnded) {
//        //        [self.delegate filterSlider:self valueChange:sliderView.value];
//        [self sliderDidCancel:nil];
//    }
//}

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    float totalheight = CGRectGetHeight(self.frame);
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, totalheight-47, 60, 44);
        [btn setImage:IMG(@"btn_close") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(DEVICEW-60, totalheight-47, 60, 40);
        [btn setImage:[UIImage imageNamed:@"btn_confirm"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(nextDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    float offsety = totalheight-50;
    [self addSubview:[CHLine lineWithFrame:CGRectMake(0, 0, DEVICEW, 0.5) color:[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1]]];
    [self addSubview:[CHLine lineWithFrame:CGRectMake(0, offsety, DEVICEW, 0.5) color:LINECOLOR]];

    sliderView = [[UISlider alloc] initWithFrame:CGRectMake(10, 15, self.frame.size.width-20, 30)];
    [sliderView setMinimumTrackTintColor:[UIColor darkGrayColor]];
    [sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [sliderView addTarget:self action:@selector(sliderDidCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sliderView];
//    sliderView = [[FSFilterSliderView alloc] initWithFrame:CGRectMake(35, (totalheight-44)/2.0-17.5, DEVICEW-70, 35)];
//    [sliderView addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
//    [sliderView addTarget:self action:@selector(sliderDidCancel:) forControlEvents:UIControlEventTouchDragExit];
//    [self addSubview:sliderView];

//    CHLine *l = [[CHLine alloc] initWithFrame:CGRectMake(0,0,DEVICEW,totalheight-49)];
//    l.backgroundColor = [UIColor clearColor];
//    l.userInteractionEnabled = YES;
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
//    [l addGestureRecognizer:pan];
//    [self addSubview:l];

    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-85, self.frame.size.height-34, 100, 25)];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont systemFontOfSize:14];
    valueLabel.textColor = [UIColor grayColor];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [valueLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:valueLabel];
    
    defaultValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2+10, self.frame.size.height-34, 60, 25)];
    defaultValueLabel.backgroundColor = [UIColor clearColor];
    defaultValueLabel.font = [UIFont systemFontOfSize:14];
    defaultValueLabel.textColor = [UIColor grayColor];
    defaultValueLabel.textAlignment = NSTextAlignmentCenter;
    [defaultValueLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:defaultValueLabel];
    
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, DEVICEH, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)backDidClick:(id)sender
{
    [self.delegate filterSliderTag:senderTag senderValue:[[myDic getValueForKey:@"value"] floatValue]];
    [self dismiss];
}

- (void)nextDidClick:(id)sender
{
    [self dismiss];
}

- (void)setDic:(NSDictionary *)dic tag:(NSInteger)tag
{
    myDic = dic;
    sliderView.maximumValue = [[dic getValueForKey:@"max"] floatValue];
    sliderView.minimumValue = [[dic getValueForKey:@"min"] floatValue];
//    filterSlider.defaultValue = [[dic getValueForKey:@"defaultvalue"] intValue];
    sliderView.value = [[dic getValueForKey:@"value"] floatValue];
//    filterSlider.tag = tag;
    
    senderTag = tag;
    valueLabel.text = [NSString stringWithFormat:@"now:%@",[[dic getValueForKey:@"value"] stringValue]];
    defaultValueLabel.text = [NSString stringWithFormat:@"def:%@",[[dic getValueForKey:@"defaultvalue"] stringValue]];
    
    
//    if ([[myDic getValueForKey:@"id"] intValue] == 5) {
//        //模糊
//        if (!blurView) {
//            CGRect r = self.imageRect;
//            if (r.size.height-r.size.width>20) {
//                r = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height-35);
//            }
//            blurView = [[UIView alloc] initWithFrame:r];
//            blurView.clipsToBounds = YES;
//            float w = MIN(self.imageRect.size.width, self.imageRect.size.height);
//            circle = [[SRTBlurCircle alloc] initWithFrame:CGRectMake(0, 0, w*0.6, w*0.6)];
//            circle.center = CGPointMake(CGRectGetWidth(blurView.frame)/2, CGRectGetHeight(blurView.frame)/2);
//            [blurView addSubview:circle];
//            [circle flushAnim];
//            circle.delegate = self;
//        }
//        [self.window addSubview:blurView];
//    }
}

- (void)updateLabValue
{
    NSString *currentValue = [NSString stringWithFormat:@"%.2f",sliderView.value];
    valueLabel.text = [NSString stringWithFormat:@"now:%@",currentValue];
}

-(void)sliderValueChanged:(id)sender
{
    
    [self updateLabValue];
    
//    [self.delegate filterSlider:sender];
}
- (void)sliderValueDidChange:(id)sender
{
    [self updateLabValue];
}

- (void)sliderDidCancel:(id)sender
{
    [self updateLabValue];
//    if ([[myDic getValueForKey:@"id"] intValue] == 5) {
//        //模糊
//        [self blurCircleDidChange];
//    }
//    else
//    {
//        [self.delegate filterSlider:self valueChange:sliderView.value];
//    }
    [self.delegate filterSliderTag:senderTag senderValue:[(UISlider*)sender value]];
}

#pragma mark - circle delegate
- (void)blurCircleDidChange
{
//    CGFloat x = (circle.center.x/blurView.bounds.size.width);
//    CGFloat y = (circle.center.y/blurView.bounds.size.height);
//    [self.delegate filterSlider:self valueChange:sliderView.value size:CGSizeMake(x, y)];
}

@end
