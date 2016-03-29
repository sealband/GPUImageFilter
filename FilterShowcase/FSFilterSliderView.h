//
//  SRTFilterSliderView.h
//  shiritan
//
//  Created by Seamus on 16/2/27.
//  Copyright © 2016年 Seamus. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SLIDEROFFSET 20
@interface FSFilterSliderView : UIControl
{
    UIImageView *defaultIcon;
    UIImageView *sliderIcon;
}
@property (nonatomic,assign) NSInteger maximumValue;
@property (nonatomic,assign) NSInteger minimumValue;
@property (nonatomic,assign) NSInteger value;
@property (nonatomic,assign) NSInteger defaultValue;
@end
