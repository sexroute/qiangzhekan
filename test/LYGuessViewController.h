//
//  LYFirstViewController.h
//  test
//
//  Created by zhao on 14-3-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYGuessViewController : UIViewController
{
    
}
@property (retain, nonatomic) IBOutlet UILabel *m_oSymbolTitle;
@property (retain, nonatomic) IBOutlet UILabel *m_oSymbol_Price;
@property (retain, nonatomic) IBOutlet UIImageView *m_oUserIcon;
@property (retain, nonatomic) IBOutlet UILabel *m_oUserName;
@property (retain, nonatomic) IBOutlet UILabel *m_oUserMail;
@property (retain, nonatomic) IBOutlet UIImageView *m_oImgUp;
@property (retain, nonatomic) IBOutlet UIImageView *m_oImgDown;
@property (retain, nonatomic) IBOutlet UILabel *m_oLblCountdown;


@property (retain, nonatomic) NSDictionary *m_oLoginData;
@property (retain, nonatomic) NSString *m_strSymbolTitle;
@property (retain, nonatomic) NSString *m_strUserName;
@property (retain, nonatomic) NSString *m_strUserMail;
@property (retain, nonatomic) NSString *m_strUserUserIcon;
@property (retain, nonatomic) NSString *m_strTimeCountDown;
@property  double m_dbl_Symbol_price;

- (void)initUI;
@end
