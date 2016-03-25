//
//  OutputTableViewController.h
//  FilterShowcase
//
//  Created by seal on 3/14/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//


@interface FSOutputTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *parametersArr;
}
- (id)initWithFilterArr:(NSMutableArray*)arr;



@end
