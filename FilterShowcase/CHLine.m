//
//  CHLine.m
//  isoccer
//
//  Created by Seamus on 10/17/13.
//  Copyright (c) 2013 Chlova. All rights reserved.
//

#import "CHLine.h"

@implementation CHLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CHLine *)lineWithFrame:(CGRect)frame
{
    CHLine *l = [[CHLine alloc] initWithFrame:frame];
    l.backgroundColor = [UIColor whiteColor];
    return l;
}

+ (CHLine *)lineWithFrame:(CGRect)frame color:(UIColor *)color
{
    CHLine *l = [[CHLine alloc] initWithFrame:frame];
    l.backgroundColor = color;
    return l;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
