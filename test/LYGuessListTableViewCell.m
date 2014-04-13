//
//  LYGuessListTableViewCell.m
//  finger
//
//  Created by zhao on 14-4-13.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "LYGuessListTableViewCell.h"

@implementation LYGuessListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_m_oStatusIcon release];
    [_m_oBetTitle release];
    [_m_oSymbolTitle release];
    [_m_oBetValue release];
    [_m_oCurrentValue release];
    [_m_oTransactionTime release];
    [super dealloc];
}
@end
