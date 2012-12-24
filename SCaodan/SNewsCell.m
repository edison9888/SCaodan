//
//  SNewsCell.m
//  SCaodan
//
//  Created by SunJiangting on 12-11-16.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SNewsCell.h"

#define kNewsFont [UIFont fontWithName:@"Arial" size:16.0f]

#define kMinCellRect CGRectMake(0,0,320,40)

@interface SNewsCell ()

@end

@implementation SNewsCell

+ (CGFloat) heightForCellWithString:(NSString *) content {
    return [content sizeWithFont:kNewsFont constrainedToSize:CGSizeMake(320, 10000) lineBreakMode:NSLineBreakByWordWrapping].height + 20;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        _label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _label.backgroundColor = [UIColor clearColor];
        _label.font = kNewsFont;
        _label.lineBreakMode = UILineBreakModeWordWrap;
        _label.numberOfLines = 0;
        _label.textColor = UIColorWithRGB(0x666666);
        [self addSubview:_label];
    }
    return self;
}

@end
