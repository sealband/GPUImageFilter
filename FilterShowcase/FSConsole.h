//
//  FSConsole.h
//  filtershow
//
//  Created by seal on 3/29/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSConsole : NSObject
+ (FSConsole *)mainConsole;
- (CGFloat)scale;
- (BOOL)isiP5;
- (BOOL)isiP6;
- (BOOL)isiP6Plus;
- (BOOL)isiP4;

@end
