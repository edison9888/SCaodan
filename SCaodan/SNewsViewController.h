//
//  SNewsViewController.h
//  SCaodan
//
//  Created by SunJiangting on 12-11-15.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SNewsModel.h"
#import "SNewsCell.h"

typedef enum STableViewState {
    STableViewReleaseToLoad,
    STableViewLoading,
    STableViewPullCanLoad
} STableViewState;

@interface SNewsViewController : UITableViewController

@end
