//
//  LYGuessListTableViewCell.h
//  finger
//
//  Created by zhao on 14-4-13.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYGuessListTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *m_oStatusIcon;
@property (retain, nonatomic) IBOutlet UILabel *m_oBetTitle;
@property (retain, nonatomic) IBOutlet UILabel *m_oSymbolTitle;
@property (retain, nonatomic) IBOutlet UILabel *m_oBetValue;
@property (retain, nonatomic) IBOutlet UILabel *m_oCurrentValue;
@property (retain, nonatomic) IBOutlet UILabel *m_oTransactionTime;
@property (retain, nonatomic) IBOutlet UILabel *m_oTransactionStatus;
@property (retain, nonatomic) IBOutlet UILabel *m_ogain;

@end
