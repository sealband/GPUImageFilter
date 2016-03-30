//
//  FSConfig.h
//  filtershow
//
//  Created by seal on 3/24/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//

#ifndef FSConfig_h
#define FSConfig_h

#import "FSParameterView.h"
#import "FSFilterSliderView.h"
#import "FSConsole.h"
#import "NSDictionary+GetValue.h"
#import "CHLine.h"
#import "FilterTypeDefination.h"
#import "UIViewController+NavbarItemCategory.h"
#define IMG(_name) [UIImage imageNamed:_name]
#define TITLECOLOR [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1]
#define LINECOLOR [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]
#define EDITORTEXTCOLOR [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1]
#define F(_size) [UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:_size]
#define FB(_size) [UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:_size]

#define ISTOUCH5 [[FSConsole mainConsole] isTouch5]
#define ISIP6 [[FSConsole mainConsole] isiP6]
#define ISIP4 [[FSConsole mainConsole] isiP4]
#define ISIP5 [[FSConsole mainConsole] isiP5]
#define ISIP6PLUS [[FSConsole mainConsole] isiP6Plus]
#define DEVICEOFFSETH (ISIP6?99.0:(ISIP6PLUS?168.0:0.0))
#define DEVICEOFFSETW (ISIP6?55.0:(ISIP6PLUS?94.0:0.0))
#define DEVICEW (ISIP6?375.0:(ISIP6PLUS?414.0:320.0))
#define DEVICEH (ISIP6?667.0:(ISIP6PLUS?736.0:(ISIP4?480.0:568.0)))

#endif /* FSConfig_h */
