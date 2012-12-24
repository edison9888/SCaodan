//
//  SNewsCell.h
//  SCaodan
//
//  Created by SunJiangting on 12-11-16.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNewsCell : UITableViewCell

+ (CGFloat) heightForCellWithString:(NSString *) content;

@property (nonatomic, readonly) UILabel * label;

@end
