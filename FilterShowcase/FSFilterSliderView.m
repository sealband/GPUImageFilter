//
//  SRTFilterSliderView.m
//  shiritan
//
//  Created by Seamus on 16/2/27.
//  Copyright © 2016年 Seamus. All rights reserved.
//

#import "FSFilterSliderView.h"

@implementation FSFilterSliderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //height:35
        self.backgroundColor = [UIColor clearColor];
        
        self.maximumValue = 10;
        self.minimumValue = 0;
        self.defaultValue = 0;
        self.value = 0;
        
        defaultIcon = [[UIImageView alloc] initWithImage:IMG(@"edit_slider_white")];
        defaultIcon.userInteractionEnabled = NO;
        [self addSubview:defaultIcon];
        
        sliderIcon = [[UIImageView alloc] initWithImage:IMG(@"edit_slider_yellow")];
        sliderIcon.frame = CGRectMake(SLIDEROFFSET+0, 0, 35, 35);
        sliderIcon.contentMode = UIViewContentModeCenter;
        sliderIcon.userInteractionEnabled = NO;
        [self addSubview:sliderIcon];
        
        [self layoutIcon];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)setMaximumValue:(NSInteger)maximumValue
{
    _maximumValue = maximumValue;
}

- (void)setMinimumValue:(NSInteger)minimumValue
{
    _minimumValue = minimumValue;
}

- (void)setDefaultValue:(NSInteger)defaultValue
{
    _defaultValue = defaultValue;
}

- (void)setValue:(NSInteger)value
{
    if (value <= self.maximumValue && value >= self.minimumValue) {
        _value = value;
    }
    [self setNeedsDisplay];
    [self layoutIcon];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setFrame:(CGRect)frame
{
    CGRect r = CGRectMake(frame.origin.x-SLIDEROFFSET, frame.origin.y, frame.size.width+SLIDEROFFSET*2, frame.size.height);
    [super setFrame:r];
}

- (void)layoutIcon
{
    float w = CGRectGetWidth(self.frame)-SLIDEROFFSET*2;
    
    defaultIcon.center = CGPointMake(SLIDEROFFSET+1.0*(self.defaultValue-self.minimumValue)/(self.maximumValue-self.minimumValue)*w, 17.5);
    sliderIcon.center = CGPointMake(SLIDEROFFSET+1.0*(self.value-self.minimumValue)/(self.maximumValue-self.minimumValue)*w, 17.5);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    {
        CGContextSetRGBStrokeColor(context, 212/255.0, 212/255.0, 212/255.0, 1.0);
        CGContextSetLineWidth(context, 1.5/[[FSConsole mainConsole] scale]);
        CGContextMoveToPoint(context, SLIDEROFFSET+0.0, 17.25);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect)-SLIDEROFFSET, 17.25);
        CGContextStrokePath(context);
    }
    {
        CGContextSetRGBStrokeColor(context, 253/255.0, 241/255.0, 135/255.0, 1.0);
        CGContextSetLineWidth(context, 4/[[FSConsole mainConsole] scale]);
        CGContextMoveToPoint(context, SLIDEROFFSET+1.0*(self.defaultValue-self.minimumValue)/(self.maximumValue-self.minimumValue)*(CGRectGetWidth(rect)-SLIDEROFFSET*2), 17.25);
        CGContextAddLineToPoint(context, SLIDEROFFSET+1.0*(self.value-self.minimumValue)/(self.maximumValue-self.minimumValue)*(CGRectGetWidth(rect)-SLIDEROFFSET*2), 17.25);
        CGContextStrokePath(context);
    }
    
}

- (void)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    static BOOL selected = NO;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:self];
        selected = YES;
        CGFloat s = (p.x-SLIDEROFFSET)/(CGRectGetWidth(self.frame)-SLIDEROFFSET*2);
        self.value = (int)(self.minimumValue+(self.maximumValue-self.minimumValue)*s);
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        if (selected) {
            CGPoint p = [gestureRecognizer locationInView:self];
//            sliderIcon.center = CGPointMake(MAX(0, MIN(CGRectGetWidth(self.frame),p.x)), sliderIcon.center.y);
            //比例
            CGFloat s = (p.x-SLIDEROFFSET)/(CGRectGetWidth(self.frame)-SLIDEROFFSET*2);
            self.value = (int)(self.minimumValue+(self.maximumValue-self.minimumValue)*s);
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (selected) {
            selected = NO;
            
            //比例
            CGPoint p = [gestureRecognizer locationInView:self];
            CGFloat s = (p.x-SLIDEROFFSET)/(CGRectGetWidth(self.frame)-SLIDEROFFSET*2);
            self.value = (int)(self.minimumValue+(self.maximumValue-self.minimumValue)*s);
            
            [self sendActionsForControlEvents:UIControlEventTouchDragExit];
        }
    }
}

@end
