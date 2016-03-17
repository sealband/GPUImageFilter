//
//  NSDictionary+GetValue.m
//  
//
//  Created by Semaus Gao on 12-4-12.
//  Copyright (c) 2012年 Seamus. All rights reserved.
//

#import "NSDictionary+GetValue.h"

@implementation NSDictionary (GetValue)
- (id)getValueForKey:(NSString *)_key
{
    id obj= [self valueForKey:_key];
    if ([obj isKindOfClass:[NSNull class]] || ([obj isKindOfClass:[NSString class]] && ([obj length] == 0 || [obj isEqualToString:@"(null)"]))) {
        return nil;
    }
    return obj;
}

- (id)getValueForKeyPath:(NSString *)_path
{
    id obj= [self valueForKeyPath:_path];
    if ([obj isKindOfClass:[NSNull class]] || ([obj isKindOfClass:[NSString class]] && ([obj length] == 0 || [obj isEqualToString:@"(null)"]))) {
        return nil;
    }
    return obj;
}
@end
