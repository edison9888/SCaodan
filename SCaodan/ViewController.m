//
//  ViewController.m
//  SCaodan
//
//  Created by SunJiangting on 12-11-15.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) SNewsModel * model;

@property (nonatomic, strong) NSArray * segmentedArray;
@property (nonatomic, strong) UISegmentedControl * segmentedControl;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITableView * tempTableView;

@end

@implementation ViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.segmentedArray = @[@"最新",@"最衰",@"最该",@"随机"];
        self.model = [[SNewsModel alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat height = self.view.frame.size.height;
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems: self.segmentedArray];
    self.segmentedControl.frame = CGRectMake(20, 10, 280, 40);
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.segmentedControl];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 60, 300, height - 60) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.model startWithCompletion:^(BOOL complete) {
        [self.tableView reloadData];
    }];
}

- (void) viewDidUnload {
    [super viewDidUnload];
    self.segmentedControl = nil;
    
}


#pragma mark === TableView DataSource ===

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model.newsArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellName = @"CELLNAME";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    return cell;
}

@end
