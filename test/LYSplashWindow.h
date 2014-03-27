//
//  LuckyNumbersViewController.h
//  LuckyNumbers
//
//  Created by Dan Grigsby on 3/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "LYLoginCell.h"
#import "LYGlobalSettings.h"
#import "Thirdparty/ASIHTTPRequest/ASIFormDataRequest.h"
#define IS_RETINA       ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&([UIScreen mainScreen].scale == 2.0))
@interface LYSplashWindow : UIViewController<UIAlertViewDelegate,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate> {
	IBOutlet UILabel *label;
	NSMutableData * m_pResponseData;
    NSDictionary *m_oLoginData;
    UIViewController * m_pMainWindow;
    
    
}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *m_oActivityProgressbar;

@property (retain, nonatomic) IBOutlet UIImageView *m_oImageView;

@property (retain, nonatomic) IBOutlet UILabel *m_oLabelLogin;


@property (retain, nonatomic) IBOutlet UITableView *m_oLoginTableView;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@property (retain, nonatomic) IBOutlet UIView *m_oLogginButton;
@property (retain,nonatomic) NSMutableData * m_pResponseData;

@property (retain, nonatomic) NSDictionary *m_oLoginData;
@property (retain,nonatomic) ASIFormDataRequest * m_oRequest;
@end

