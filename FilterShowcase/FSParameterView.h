//
//  FSParameterView.h
//  filtershow
//
//  Created by seal on 3/30/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FSParameterViewDelegate <NSObject>
@required
- (void)hideParameterView;
@end
@interface FSParameterView : UIView
{
    UIVisualEffectView *guideBlurView;
    NSArray *paraArr;
    NSString *imageType;
}
- (id)initWithFrame:(CGRect)frame btnArray:(NSArray*)arr;
@property (assign,nonatomic) id<FSParameterViewDelegate> delegate;
@end
