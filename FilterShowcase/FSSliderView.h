//
//  SliderView.h
//  FilterShowcase
//
//  Created by seal on 3/18/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//

@protocol SRTEditorFilterSliderDelegate <NSObject>
- (void)filterSliderTag:(NSInteger)tag senderValue:(float)senderValue;
@end

@interface FSSliderView : UIView
{
    NSDictionary *myDic;

    UISlider *filterSlider;
    
    UILabel *valueLabel;
    UILabel *defaultValueLabel;
    
    CGRect mainFrame ;
    
    NSInteger senderTag;

}
@property(readwrite, unsafe_unretained, nonatomic) UISlider *filterSlider;
- (void)setDic:(NSDictionary *)dic tag:(NSInteger)tag;
@property (nonatomic) id <SRTEditorFilterSliderDelegate> delegate;

@end
