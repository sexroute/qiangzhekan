//
//  LYFirstViewController.m
//  test
//
//  Created by zhao on 14-3-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "LYGuessViewController.h"
#import "LYMainWindowViewController.h"
#import "LYGlobalSettings.h"
@interface LYGuessViewController ()

@end

@implementation LYGuessViewController
@synthesize m_oLoginData;
@synthesize m_strSymbolTitle;
@synthesize m_strUserName;
@synthesize m_strUserMail;
@synthesize m_strUserUserIcon;
@synthesize m_dbl_Symbol_price;
@synthesize m_strTimeCountDown;
@synthesize m_nTransactionDirection;
@synthesize m_bSymbolSucceed;
@synthesize m_strSymbolReason;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self ResetUserData];
    [self ResetSymbolData];
    [self initUI];
	// Do any additional setup after loading the view, typically from a nib.
}
#pragma mark 重置操作
-(void)ResetTransactionData
{
    self.m_nTransactionDirection = TRANS_NONE_TRANS;
}

-(void)ResetUserData
{
    self.m_strUserName = [[NSString alloc]initWithFormat:@"未登录"];
    self.m_strUserMail = [[NSString alloc]initWithFormat:@""];
    self.m_oUserIcon.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"du" ofType:@"png"]];
    
}

-(void)ResetSymbolData
{
    self.m_strSymbolTitle = [[NSString alloc] initWithFormat:@"竞猜-没有数据"];
    self.m_dbl_Symbol_price = 0.0;
    self.m_strTimeCountDown = [[NSString alloc] initWithFormat:@"00:00:00"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_oSymbolTitle release];
    [_m_oSymbol_Price release];
    [_m_oUserIcon release];
    [_m_oUserName release];
    [_m_oUserMail release];
    [_m_oImgUp release];
    [_m_oImgDown release];
    [_m_oLblCountdown release];
    [super dealloc];
}
#pragma mark 解析json数据
- (BOOL) ParseUserData:(NSDictionary *) apData
{
    BOOL lbRet = FALSE;
    if([apData isKindOfClass:[NSDictionary class]])
    {
        id loValue = [apData objectForKey:@"val"];
        if ([loValue isKindOfClass:[NSDictionary class]])
        {
            id loUserValue = [loValue objectForKey:@"user_name"];
            if ([loUserValue isKindOfClass:[NSString class]])
            {
                self.m_strUserName =[[NSString alloc] initWithFormat:@"%@",(NSString *)loUserValue];
                 loUserValue = [loValue objectForKey:@"user_email"];
                if ([loUserValue isKindOfClass:[NSString class]])
                {
                    self.m_strUserMail =[[NSString alloc] initWithFormat:@"%@",(NSString *)loUserValue];
                    loUserValue = [loValue objectForKey:@"user_avatar_url"];
                    if ([loUserValue isKindOfClass:[NSString class]])
                    {
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)loUserValue]]];
                        
                        if (nil == image)
                        {
                             self.m_oUserIcon.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"du" ofType:@"png"]];
                        }else
                        {
                             self.m_oUserIcon.image = image;
                        }
                        
                    }else
                    {
                         self.m_oUserIcon.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"du" ofType:@"png"]];
                    }
                    lbRet = TRUE;
                }
            }
        }
        
    }
    return lbRet;

}
- (enum TRANS_ACTION_TYPE) ParseTransaction:(NSDictionary *) apData
{
    enum TRANS_ACTION_TYPE lnRet = TRANS_NONE_TRANS;
    
     if([apData isKindOfClass:[NSDictionary class]])
     {
         id loValue = [apData objectForKey:@"val"];
         if ([loValue isKindOfClass:[NSDictionary class]])
         {
              id loTransValue = [loValue objectForKey:@"user_trans"];
             if ([loTransValue isKindOfClass:[NSDictionary class]])
             {
                 loTransValue = [loTransValue objectForKey:@"trans_direction"];
                  if ([loTransValue isKindOfClass:[NSString class]])
                  {
                      self.m_nTransactionDirection = [(NSString *)loTransValue intValue];
                      lnRet = self.m_nTransactionDirection;
                  }
             }
             
         }
     }
    return lnRet;
}
- (BOOL) ParseSymbolData:(NSDictionary *) apData
{
    BOOL lbRet = FALSE;
    if([apData isKindOfClass:[NSDictionary class]])
    {
        id loValue = [apData objectForKey:@"val"];
        if ([loValue isKindOfClass:[NSDictionary class]])
        {
            loValue = [loValue objectForKey:@"symbol"];
            if ([loValue isKindOfClass:[NSDictionary class]])
            {
                NSDictionary * lpSymbol = (NSDictionary *)loValue;
                id loSymbolValue = [lpSymbol objectForKey:@"symbol_name"];
                if ([loSymbolValue isKindOfClass:[NSString class]])
                {
                   self.m_strSymbolTitle = [[NSString alloc] initWithFormat:@"%@",(NSString *)loSymbolValue];
                    loSymbolValue = [lpSymbol objectForKey:@"symbol_current_value"];
                    if ([loSymbolValue isKindOfClass:[NSString class]])
                        
                    {
                        self.m_dbl_Symbol_price = [(NSString*)loSymbolValue doubleValue];
                        lbRet = TRUE;
                    }
                }
            }
        }
       
    }
     return lbRet;
}
#pragma mark 初始化UI
- (void) initUI
{

    //1.status bar
    [self setNeedsStatusBarAppearanceUpdate];    
    
    //2.prepare data
    NSString * lpResponseData = [LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_LOGININFO];
    self.m_oLoginData = [LYGlobalSettings GetJsonValue: lpResponseData];
    
    BOOL lbParseSucceed = [self ParseSymbolData:self.m_oLoginData];
    self.m_bSymbolSucceed = lbParseSucceed;
    
    //3.parse TransAction
    self.m_nTransactionDirection = [self ParseTransaction:self.m_oLoginData];
    
    if (self.m_nTransactionDirection == (TRANS_NONE_TRANS))
    {
        if (!lbParseSucceed)
        {
            self.m_oImgDown.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_gray" ofType:@"png"]];
            self.m_oImgUp.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_gray" ofType:@"png"]];
            
        }else
        {
            self.m_oImgDown.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down" ofType:@"png"]];
            self.m_oImgUp.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up" ofType:@"png"]];
        }
        
    }else if (self.m_nTransactionDirection == (TRANS_BET_DOWN))
    {
        
        if (!lbParseSucceed)
        {
            self.m_oImgDown.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_gray" ofType:@"png"]];
            self.m_oImgUp.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_gray" ofType:@"png"]];
            
        }else
        {
            self.m_oImgDown.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_selected" ofType:@"png"]];
            self.m_oImgUp.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_gray" ofType:@"png"]];
        }
    }else
    {
        if (!lbParseSucceed)
        {
            self.m_oImgDown.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_gray" ofType:@"png"]];
            self.m_oImgUp.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_gray" ofType:@"png"]];
            
        }else
        {
            self.m_oImgDown.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_gray" ofType:@"png"]];
            self.m_oImgUp.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_selected" ofType:@"png"]];
        }
    }



    lbParseSucceed =  [self ParseUserData:self.m_oLoginData];

    
    self.m_oLblCountdown.text = [[NSString alloc] initWithFormat:@"%@",self.m_strTimeCountDown];
    self.m_oSymbol_Price.text = [[NSString alloc] initWithFormat:@"%.2f",self.m_dbl_Symbol_price];
    self.m_oSymbolTitle.text = [[NSString alloc] initWithFormat:@"%@",self.m_strSymbolTitle];
    self.m_oUserName.text =[[NSString alloc] initWithFormat:@"%@",self.m_strUserName];
    self.m_oUserMail.text =[[NSString alloc] initWithFormat:@"%@",self.m_strUserMail];
    
    //4.增加涨跌按钮消息处理器

    UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleFingerEvent:)]autorelease];
    
    self.m_oImgDown.userInteractionEnabled = YES;
    [self.m_oImgDown addGestureRecognizer:tapGestureTel];
    
   UITapGestureRecognizer *tapGestureTel2 = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleFingerEvent:)]autorelease];
    self.m_oImgUp.userInteractionEnabled = YES;
    [self.m_oImgUp addGestureRecognizer:tapGestureTel2];


}

#pragma mark 涨跌按钮点击操作

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    if (!self.m_bSymbolSucceed)
    {
        [self alertWrongLogin:self.m_strSymbolReason];
        return;
    }else
    {
        if(sender.view == self.m_oImgUp)
        {
            if (self.m_nTransactionDirection == TRANS_BET_DOWN)
            {
                [self alertWrongLogin:[[NSString alloc] initWithFormat:@"已经选涨,未结算前不能改变选择"]];
                return;
            }
            else if (self.m_nTransactionDirection == TRANS_BET_UP)
                
            {
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"结算确认" message:@"确认要完成结算么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil] autorelease];
                alertView.tag = 1;
                [alertView show];
            }
            else
            {
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"竞猜确认" message:@"确认猜涨么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil] autorelease];
                alertView.tag = 2;
                [alertView show];
            }
        }else
        if(sender.view == self.m_oImgDown)
        {
          if (self.m_nTransactionDirection == TRANS_BET_UP)
          {
                    [self alertWrongLogin:[[NSString alloc] initWithFormat:@"已经选涨,未结算前不能改变选择"]];
                    return;
           }
          else if (self.m_nTransactionDirection == TRANS_BET_DOWN)
                    
          {
                    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"结算确认" message:@"确认要完成结算么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil] autorelease];
                    alertView.tag = 3;
                    [alertView show];
          }else
          {
              UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"竞猜确认" message:@"确认猜跌么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil] autorelease];
              alertView.tag = 4;
              [alertView show];
          }
        }
    }
}

#pragma mark Transaction
-(void) doCloseRemoteTransaction
{
    
}

-(void) doBetUpTransaction
{
    
}

-(void) doBetDownTransaction
{
    
}

#pragma mark 错误提醒
- (void) alertWrongLogin:(NSString *) apError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:apError
												   delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    alert.tag = 0;
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        //完成结算
        if (buttonIndex == 1)
        {
            [self doCloseRemoteTransaction];
        }
    }else if(alertView.tag ==2)
    {
        //压涨
        if (buttonIndex == 1)
        {
            [self doBetUpTransaction];
        }
    }else if(alertView.tag ==3)
    {
        //完成结算
        if (buttonIndex == 1)
        {
            [self doCloseRemoteTransaction];
        }
    }
    else if(alertView.tag ==4)
    {
        //压跌
        if (buttonIndex == 1)
        {
            [self doBetDownTransaction];
        }
    }
    
}



- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}





@end
