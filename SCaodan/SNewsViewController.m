//
//  SNewsViewController.m
//  SCaodan
//
//  Created by SunJiangting on 12-11-15.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SNewsViewController.h"

#define kLoadOffset 76.0f

@interface SNewsViewController ()

@property (nonatomic, strong) SNewsModel * model;

@property (nonatomic, assign) STableViewState loadMoreState;

@end

@implementation SNewsViewController

- (id) init {
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:1];
        self.tabBarItem.title = @"最新";
        self.model = [[SNewsModel alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Fucking day";
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [self refresh];
}

- (void) viewDidUnload {
    [super viewDidUnload];
    
}

- (void) refresh {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
    [self.model startWithCompletion:^(BOOL complete) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        [self.tableView reloadData];
    }];
}


#pragma mark === TableView DataSource ===


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model.newsArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNewsItem * item = (SNewsItem *)[self.model.newsArray objectAtIndex:indexPath.row];
    
    return [SNewsCell heightForCellWithString:item.content];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SNewsItem * item = (SNewsItem *)[self.model.newsArray objectAtIndex:indexPath.row];
    
    static NSString * cellName = @"CELLNAME";
    SNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[SNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.label.text = item.content;
    return cell;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    if (scrollPosition > 0) {
        return;
    }
    if (self.loadMoreState != STableViewLoading) {
        if (scrollPosition < -kLoadOffset ) {
            self.loadMoreState = STableViewReleaseToLoad;
            NSLog(@"松开可以加载");
        } else {
            self.loadMoreState = STableViewPullCanLoad;
            NSLog(@"继续拽可以加载");
        }
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.loadMoreState == STableViewReleaseToLoad) {
        NSLog(@"正在加载你妹...");
        self.loadMoreState = STableViewLoading;
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, kLoadOffset, 0);
        [self.model loadMoreWithCompletion:^(BOOL complete) {
            self.loadMoreState = STableViewPullCanLoad;
            self.tableView.contentInset = UIEdgeInsetsZero;
//            NSDate * date = [NSDate date];
            [self.tableView reloadData];
//            NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:date];
//            NSLog(@"TableView reloadData 耗时 %@",@(time));
        }];
    }
}

@end
