//
//  FSConsole.m
//  filtershow
//
//  Created by seal on 3/29/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//

#import "FSConsole.h"

@implementation FSConsole
static  FSConsole*_console;

+ (FSConsole *)mainConsole
{
    if (!_console) {
        _console = [[FSConsole alloc] init];
    }
    return _console;
}

- (BOOL)isiP4
{
    static int isip4 = -1;
    if (isip4 == -1) {
        if (CGRectEqualToRect([[UIScreen mainScreen] bounds], CGRectMake(0, 0, 320, 480))) {
            isip4 = 1;
        }
        else
        {
            isip4 = 0;
        }
    }
    return isip4;
}

- (BOOL)isiP5
{
    static int isip5 = -1;
    if (isip5 == -1) {
        if (CGRectEqualToRect([[UIScreen mainScreen] bounds], CGRectMake(0, 0, 320, 568))) {
            isip5 = 1;
        }
        else
        {
            isip5 = 0;
        }
    }
    return isip5;
}

- (BOOL)isiP6
{
    static int isip6 = -1;
    if (isip6 == -1) {
        if (CGRectEqualToRect([[UIScreen mainScreen] bounds], CGRectMake(0, 0, 375, 667))) {
            isip6 = 1;
        }
        else
        {
            isip6 = 0;
        }
    }
    return isip6;
}

- (BOOL)isiP6Plus
{
    static int isip6plus = -1;
    if (isip6plus == -1) {
        if (CGRectEqualToRect([[UIScreen mainScreen] bounds], CGRectMake(0, 0, 414, 736))) {
            isip6plus = 1;
        }
        else
        {
            isip6plus = 0;
        }
    }
    return isip6plus;
}

@end
