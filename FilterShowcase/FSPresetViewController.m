//
//  FSPresetViewController.m
//  filtershow
//
//  Created by seal on 4/1/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//

#import "FSPresetViewController.h"

@interface FSPresetViewController ()

@end

@implementation FSPresetViewController
@synthesize arrFilterSource;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    horizontalTableView = [[UITableView alloc] init];
    horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    horizontalTableView.frame = CGRectMake(0, 0, DEVICEW, 117);
    horizontalTableView.delegate = self;
    horizontalTableView.dataSource = self;
    horizontalTableView.separatorStyle = UITableViewStylePlain;
    [self.view addSubview:horizontalTableView];
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 120, 60, 44);
        [btn setImage:IMG(@"btn_close") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btnPre = btn;
    }
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(DEVICEW-60, 120, 60, 44);
        [btn setImage:IMG(@"btn_confirm") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(nextDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btnNext = btn;
    }
    
    CHLine *line = [CHLine lineWithFrame:CGRectMake(0, 0, DEVICEW, 0.5) color:[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1]];
    [self.view addSubview:line];
    [self.view addSubview:[CHLine lineWithFrame:CGRectMake(0, 117, DEVICEW, 0.5) color:LINECOLOR]];
}

- (void)backDidClick:(id)sender
{
    [self.delegate notAdaptPresetFilters];
    [self dismiss];
}

- (void)nextDidClick:(id)sender
{
    [self dismiss];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, DEVICEH, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrFilterSource count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.frame = cell.frame;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [arrFilterSource[index] getValueForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];

    if (self.delegate && [self.delegate respondsToSelector:@selector(adaptPresetFiltersWithArr:)]) {
        [self.delegate adaptPresetFiltersWithArr:[arrFilterSource[index] getValueForKey:@"filter"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
