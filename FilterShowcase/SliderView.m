//
//  SliderView.m
//  FilterShowcase
//
//  Created by seal on 3/18/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//

#import "SliderView.h"

@implementation SliderView

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
    
    mainFrame =  [[UIScreen mainScreen] bounds];

    
    self.backgroundColor = [UIColor whiteColor];
    
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    float totalheight = CGRectGetHeight(self.frame);
    //    float toolwidth = DEVICEW;
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, totalheight-47, 60, 44);
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn setImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];

        [btn addTarget:self action:@selector(backDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.size.width-60, totalheight-47, 60, 44);
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn setImage:[UIImage imageNamed:@"btn_confirm"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(nextDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-25, self.frame.size.height-40, 50, 25)];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont systemFontOfSize:15];
    valueLabel.textColor = [UIColor blackColor];
    [valueLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:valueLabel];

    float offsety = totalheight-50;
//    [self addSubview:[CHLine lineWithFrame:CGRectMake(0, 0, DEVICEW, 0.5) color:[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1]]];
//    [self addSubview:[CHLine lineWithFrame:CGRectMake(0, offsety, DEVICEW, 0.5) color:LINECOLOR]];
    
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, offsety+2, self.frame.size.width, 49)];
//    lab.text = @"";
//    lab.font = F(18);
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.backgroundColor = [UIColor clearColor];
//    lab.textColor = EDITORTEXTCOLOR;
//    [self addSubview:lab];
//    labTitel = lab;
    
//    {
//        UILabel *lab = [[UILabel alloc] init];
//        lab.textColor = [UIColor colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1];
//        lab.font = F(13);
//        lab.textAlignment = NSTextAlignmentCenter;
//        lab.backgroundColor = [UIColor clearColor];
//        [self addSubview:lab];
//        labValue = lab;
//    }
    
//    sliderView = [[SRTFilterSliderView alloc] initWithFrame:CGRectMake(35, (totalheight-44)/2.0-17.5, DEVICEW-70, 35)];
//    [sliderView addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
//    [sliderView addTarget:self action:@selector(sliderDidCancel:) forControlEvents:UIControlEventTouchDragExit];
//    [self addSubview:sliderView];
    
    filterSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 30)];
    [filterSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [filterSlider addTarget:self action:@selector(sliderDidCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:filterSlider];
    
    
    
    
    
//    CHLine *l = [[CHLine alloc] initWithFrame:CGRectMake(0,0,DEVICEW,totalheight-49)];
//    l.backgroundColor = [UIColor clearColor];
//    l.userInteractionEnabled = YES;
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
//    [l addGestureRecognizer:pan];
//    [self addSubview:l];
}

- (void)dismiss
{
//    if ([[myDic getValueForKey:@"id"] intValue] == 5) {
//        //模糊
//        [circle removeFromSuperview];
//        circle = nil;
//        [blurView removeFromSuperview];
//        blurView = nil;
//    }
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(0, mainFrame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)backDidClick:(id)sender
{
//    [self.delegate filterSlider:self valueChange:[[myDic getValueForKey:@"value"] intValue]];
//    [self.delegate cancleCurrentFilter];
    [self dismiss];
}

- (void)nextDidClick:(id)sender
{
    [self dismiss];
}

- (void)setDic:(NSDictionary *)dic
{
    myDic = dic;
    filterSlider.maximumValue = [[dic getValueForKey:@"max"] intValue];
    filterSlider.minimumValue = [[dic getValueForKey:@"min"] intValue];
//    filterSlider.defaultValue = [[dic getValueForKey:@"defaultvalue"] intValue];
    filterSlider.value = [[dic getValueForKey:@"defaultvalue"] intValue];
    
    valueLabel.text = [[dic getValueForKey:@"defaultvalue"] stringValue];
    
    
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
//    labValue.text = [NSString stringWithFormat:@"%ld",sliderView.value];
//    [labValue sizeToFit];
//    labValue.center = CGPointMake(SLIDEROFFSET+1.0*(sliderView.value-sliderView.minimumValue)/(sliderView.maximumValue-sliderView.minimumValue)*(sliderView.frame.size.width-SLIDEROFFSET*2)+sliderView.frame.origin.x, sliderView.frame.origin.y-5);
}


-(void)sliderValueChanged:(id)sender
{
    NSString *currentValue = [NSString stringWithFormat:@"%.2f",[(UISlider*)sender value]];
    valueLabel.text = currentValue;
    
    [self.delegate filterSlider:sender];
}
- (void)sliderValueDidChange:(id)sender
{
    [self updateLabValue];
}

- (void)sliderDidCancel:(id)sender
{
//    [self updateLabValue];
//    if ([[myDic getValueForKey:@"id"] intValue] == 5) {
//        //模糊
//        [self blurCircleDidChange];
//    }
//    else
//    {
//        [self.delegate filterSlider:self valueChange:sliderView.value];
//    }
    [self.delegate filterSlider:sender];
}

#pragma mark - circle delegate
- (void)blurCircleDidChange
{
//    CGFloat x = (circle.center.x/blurView.bounds.size.width);
//    CGFloat y = (circle.center.y/blurView.bounds.size.height);
//    [self.delegate filterSlider:self valueChange:sliderView.value size:CGSizeMake(x, y)];
}

@end
