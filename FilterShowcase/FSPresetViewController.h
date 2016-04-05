//
//  FSPresetViewController.h
//  filtershow
//
//  Created by seal on 4/1/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FSPresetViewDelegate <NSObject>
@required
- (void)adaptPresetFiltersWithArr:(NSMutableArray*)arr;
- (void)notAdaptPresetFilters;
@end

@interface FSPresetViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *btnNext;
    UIButton *btnPre;
    
    UITableView *horizontalTableView;
    NSMutableArray *arrFilterSource;
}
@property (nonatomic)NSMutableArray *arrFilterSource;
@property (assign,nonatomic) id<FSPresetViewDelegate> delegate;
@end
