//
//  NSDictionary+GetValue.h
//
//
//  Created by Semaus Gao on 12-4-12.
//  Copyright (c) 2012年 Seamus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GetValue)
- (id)getValueForKey:(NSString *)_key;
- (id)getValueForKeyPath:(NSString *)_path;
@end
