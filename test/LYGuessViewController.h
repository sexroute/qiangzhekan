//
//  LYFirstViewController.h
//  test
//
//  Created by zhao on 14-3-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYGuessViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *m_oSymbolTitle;
@property (retain, nonatomic) IBOutlet UILabel *m_oSymbol_Price;
@property (retain, nonatomic) IBOutlet UINavigationBar *m_oNavigationBar;
@property (retain, nonatomic) IBOutlet UIImageView *m_oUserIcon;
@property (retain, nonatomic) IBOutlet UILabel *m_oUserName;
@property (retain, nonatomic) IBOutlet UILabel *m_oUserMail;
- (void)initUI;
@end
