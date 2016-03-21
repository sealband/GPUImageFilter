//
//  SliderView.h
//  FilterShowcase
//
//  Created by seal on 3/18/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDictionary+GetValue.h"



@protocol SRTEditorFilterSliderDelegate <NSObject>
- (void)filterSlider:(id)sender;
- (void)cancleCurrentFilter;
@end

@interface SliderView : UIView
{
    NSDictionary *myDic;

    UISlider *filterSlider;
    
    UILabel *valueLabel;
    
    CGRect mainFrame ;

}
@property(readwrite, unsafe_unretained, nonatomic) UISlider *filterSlider;
- (void)setDic:(NSDictionary *)dic tag:(NSInteger)tag;
@property (nonatomic) id <SRTEditorFilterSliderDelegate> delegate;

@end
