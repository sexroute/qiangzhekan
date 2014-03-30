//
//  LYAccountViewController.h
//  finger
//
//  Created by zhao on 14-3-30.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
@interface LYAccountViewController : UITableViewController<MBProgressHUDDelegate>
{
     MBProgressHUD *HUD;
}
@property (retain, nonatomic) IBOutlet UITextField *m_totalAsset;
@property (retain, nonatomic) IBOutlet UITextField *m_oCash;
@property (retain, nonatomic) IBOutlet UITextField *m_oBet;
@property (retain, nonatomic) IBOutlet UITextField *m_oAmount;
@property (retain, nonatomic) IBOutlet UITextField *m_oLastAsset;
@property (retain, nonatomic) IBOutlet UIButton *m_oQuit;
@property (retain,nonatomic) ASIFormDataRequest * m_oRequest;
@property (retain, nonatomic) NSDictionary *m_oLoginData;
@property (retain,nonatomic) NSMutableData * responseData;
@end
