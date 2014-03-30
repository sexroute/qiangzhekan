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
#import "JSON.h"
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
@synthesize m_strSymbolId;
@synthesize m_oRequest;
@synthesize responseData;
@synthesize m_strTransactionId;
@synthesize m_oTimerCountDown;
@synthesize m_oTimerUpdate;
#pragma mark 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self ResetUserData];
    [self ResetSymbolData];
    [self initUI];
    [self InitTimer];
    [self onTimerCountDown];
	// Do any additional setup after loading the view, typically from a nib.
}
#pragma mark 重置操作
-(void)ResetTransactionData
{
    self.m_nTransactionDirection = TRANS_NONE_TRANS;
}

-(void)ResetUserData
{
    self.m_strUserName = [[[NSString alloc]initWithFormat:@"未登录"]autorelease];
    self.m_strUserMail = [[[NSString alloc]initWithFormat:@""]autorelease];
    self.m_oUserIcon.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"du" ofType:@"png"]]autorelease];
    
}

-(void)ResetSymbolData
{
    self.m_strSymbolTitle = [[[NSString alloc] initWithFormat:@"竞猜-没有数据"]autorelease];
    self.m_dbl_Symbol_price = 0.0;
    self.m_strTimeCountDown = [[[NSString alloc] initWithFormat:@"00:00:00"]autorelease];
    
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
    [m_oRequest release];
    
    [_m_oTimer release];
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
                self.m_strUserName =[[[NSString alloc] initWithFormat:@"%@",(NSString *)loUserValue]autorelease];
                 loUserValue = [loValue objectForKey:@"user_email"];
                if ([loUserValue isKindOfClass:[NSString class]])
                {
                    self.m_strUserMail =[[[NSString alloc] initWithFormat:@"%@",(NSString *)loUserValue]autorelease];
                    loUserValue = [loValue objectForKey:@"user_avatar_url"];
                    if ([loUserValue isKindOfClass:[NSString class]])
                    {
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)loUserValue]]];
                        
                        if (nil == image)
                        {
                             self.m_oUserIcon.image =[ [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"du" ofType:@"png"]]autorelease];
                        }else
                        {
                             self.m_oUserIcon.image = image;
                        }
                        
                    }else
                    {
                         self.m_oUserIcon.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"du" ofType:@"png"]]autorelease];
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
               loValue = [loValue objectForKey:@"user_trans"];
             if ([loValue isKindOfClass:[NSDictionary class]])
             {
                 id loTransValue = [loValue objectForKey:@"trans_direction"];
                  if ([loTransValue isKindOfClass:[NSString class]])
                  {
                      self.m_nTransactionDirection = [(NSString *)loTransValue intValue];
                      lnRet = self.m_nTransactionDirection;
                  }
                 loTransValue = [loValue objectForKey:@"id"];
                 if ([loTransValue isKindOfClass:[NSString class]])
                 {
                     self.m_strTransactionId = [[[NSString alloc] initWithFormat:@"%@",(NSString *)loTransValue]autorelease];
                 }
             }
             
         }
     }
    return lnRet;
}
- (int) ParseResponse:(NSDictionary *) apData apError:(NSString**)apError
{
    int lbRet = -1;
    if([apData isKindOfClass:[NSDictionary class]])
    {
        id loRet =[apData objectForKey:@"ret"];
        if([loRet isKindOfClass:[NSDictionary class]])
        {
            id loRetCode = [loRet objectForKey:@"error_code"];
            lbRet = [loRetCode intValue];
            *apError = (NSString*)[loRet objectForKey:@"error"];
            return  lbRet;
            
        }
    }
    return lbRet;
}
- (int) ParseSymbolData:(NSDictionary *) apData
{
    int lbRet = -1;
    if([apData isKindOfClass:[NSDictionary class]])
    {
        id loRet =[apData objectForKey:@"ret"];
        if([loRet isKindOfClass:[NSDictionary class]])
        {
            loRet = [loRet objectForKey:@"error_code"];
            lbRet = [loRet intValue];
          
            
        }
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
                   self.m_strSymbolTitle = [[[NSString alloc] initWithFormat:@"%@",(NSString *)loSymbolValue]autorelease];
                    loSymbolValue = [lpSymbol objectForKey:@"symbol_current_value"];
                    if ([loSymbolValue isKindOfClass:[NSString class]])
                        
                    {
                        self.m_dbl_Symbol_price = [(NSString*)loSymbolValue doubleValue];
                       // lbRet = TRUE;
                    }
                    
                    loSymbolValue = [lpSymbol objectForKey:@"id"];
                    if ([loSymbolValue isKindOfClass:[NSString class]])
                    {
                        self.m_strSymbolId = [[[NSString alloc] initWithFormat:@"%@",(NSString *)loSymbolValue]autorelease];
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
    NSDictionary * loRet = [LYGlobalSettings GetJsonValue: lpResponseData];

    int lnParseSucceed = [self ParseSymbolData:loRet];
    BOOL lbParseSucceed = (lnParseSucceed==0);
    self.m_bSymbolSucceed = lbParseSucceed;
    if (lbParseSucceed)
    {
        self.m_oLoginData = loRet;
    }
    
    //3.parse TransAction
    self.m_nTransactionDirection = [self ParseTransaction:loRet];
    
    if (self.m_nTransactionDirection == (TRANS_NONE_TRANS))
    {
        if (!lbParseSucceed)
        {
            self.m_oImgDown.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_gray" ofType:@"png"]]autorelease];
            self.m_oImgUp.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_gray" ofType:@"png"]]autorelease];
            
        }else
        {
            self.m_oImgDown.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down" ofType:@"png"]]autorelease];
            self.m_oImgUp.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up" ofType:@"png"]]autorelease];
        }
        
    }else if (self.m_nTransactionDirection == (TRANS_BET_DOWN))
    {
        
        if (!lbParseSucceed)
        {
            self.m_oImgDown.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_gray" ofType:@"png"]]autorelease];
            self.m_oImgUp.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_gray" ofType:@"png"]]autorelease];
            
        }else
        {
            self.m_oImgDown.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_selected" ofType:@"png"]]autorelease];
            self.m_oImgUp.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_gray" ofType:@"png"]]autorelease];
        }
    }else
    {
        if (!lbParseSucceed)
        {
            self.m_oImgDown.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_gray" ofType:@"png"]]autorelease];
            self.m_oImgUp.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_gray" ofType:@"png"]]autorelease];
            
        }else
        {
            self.m_oImgDown.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_gray" ofType:@"png"]]autorelease];
            self.m_oImgUp.image = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_selected" ofType:@"png"]]autorelease];
        }
    }



    lbParseSucceed =  [self ParseUserData:self.m_oLoginData];

    
    self.m_oLblCountdown.text = [[[NSString alloc] initWithFormat:@"%@",self.m_strTimeCountDown]autorelease];
    self.m_oSymbol_Price.text = [[[NSString alloc] initWithFormat:@"%.2f",self.m_dbl_Symbol_price]autorelease];
    self.m_oSymbolTitle.text = [[[NSString alloc] initWithFormat:@"%@",self.m_strSymbolTitle]autorelease];
    self.m_oUserName.text =[[[NSString alloc] initWithFormat:@"%@",self.m_strUserName]autorelease];
    self.m_oUserMail.text =[[[NSString alloc] initWithFormat:@"%@",self.m_strUserMail]autorelease];
    
    //4.增加涨跌按钮消息处理器

    UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleFingerEvent:)]autorelease];
    
    self.m_oImgDown.userInteractionEnabled = YES;
    [self.m_oImgDown addGestureRecognizer:tapGestureTel];
    
   UITapGestureRecognizer *tapGestureTel2 = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleFingerEvent:)]autorelease];
    self.m_oImgUp.userInteractionEnabled = YES;
    [self.m_oImgUp addGestureRecognizer:tapGestureTel2];

    //5.下拉刷新
    if (_refreshHeaderView == nil)
    {
        
        int lnHeight =self.view.bounds.size.height;
        int lnWidth = self.view.frame.size.width;
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - lnHeight,lnWidth , lnHeight)];
        view.delegate = self;
        [self.view addSubview:view];
        _refreshHeaderView = view;
        [view release];
        [_refreshHeaderView refreshLastUpdatedDate];
         
       
    }
}
#pragma mark table ui
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
      return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma pull refesh
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self doRefreshRemoteData:TRUE];
    //[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma mark 涨跌按钮点击操作

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    if (!self.m_bSymbolSucceed)
    {
        [self alertWrong:self.m_strSymbolReason];
        return;
    }else
    {
        if(sender.view == self.m_oImgUp)
        {
            if (self.m_nTransactionDirection == TRANS_BET_DOWN)
            {
                [self alertWrong:[[[NSString alloc] initWithFormat:@"已经选涨,未结算前不能改变选择"]autorelease]];
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
                    [self alertWrong:[[[NSString alloc] initWithFormat:@"已经选涨,未结算前不能改变选择"]autorelease]];
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
-(void) doRefreshRemoteData:(BOOL)abHud
{
    if(abHud)
    {
        [self PopulateIndicator];
    }
    self.responseData = [NSMutableData data];
    
    NSString * lpPostData = [NSString stringWithFormat:@"user_token=%@",[LYGlobalSettings GetSettingString:SETTING_KEY_USER_TOKEN]];
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/index.php/Trans/get/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    
    NSURL* url = [NSURL URLWithString:lpServerAddress];
    NSLog(@"%@",lpServerAddress);
    
    [self.m_oRequest setCachePolicy: ASIDoNotWriteToCacheCachePolicy | ASIDoNotReadFromCacheCachePolicy];
    self.m_oRequest = [ASIFormDataRequest  requestWithURL:url];
    [self.m_oRequest setRequestMethod:@"POST"];
    [self.m_oRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableData *requestBody = [[[NSMutableData alloc] initWithData:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    [self.m_oRequest appendPostData:requestBody];
    [self.m_oRequest setDelegate:self];
    [self.m_oRequest setTimeOutSeconds:NETWORK_TIMEOUT];
   	[self.m_oRequest startAsynchronous];
    


}
-(void) doCloseRemoteTransaction
{
    [self PopulateIndicator];
    self.responseData = [NSMutableData data];
    
    NSString * lpPostData = [NSString stringWithFormat:@"user_token=%@&id=%@",[LYGlobalSettings GetSettingString:SETTING_KEY_USER_TOKEN],self.m_strTransactionId];
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/index.php/Trans/close/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    
    NSURL* url = [NSURL URLWithString:lpServerAddress];
    NSLog(@"%@",lpServerAddress);
    
   [self.m_oRequest setCachePolicy: ASIDoNotWriteToCacheCachePolicy | ASIDoNotReadFromCacheCachePolicy];
    self.m_oRequest = [ASIFormDataRequest  requestWithURL:url];
    [self.m_oRequest setRequestMethod:@"POST"];
    [self.m_oRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableData *requestBody = [[[NSMutableData alloc] initWithData:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    [self.m_oRequest appendPostData:requestBody];
    [self.m_oRequest setDelegate:self];
    [self.m_oRequest setTimeOutSeconds:NETWORK_TIMEOUT];
   	[self.m_oRequest startAsynchronous];
    
    if (nil != HUD)
    {
      //  [HUD hide:YES afterDelay:0];
    }
}

-(void) doBetUpTransaction
{
    [self PopulateIndicator];
    self.responseData = [NSMutableData data];
    
    NSString * lpPostData = [NSString stringWithFormat:@"user_token=%@&trans_amount=%d&id=%@&trans_symbol_id=%@&trans_direction=1",[LYGlobalSettings GetSettingString:SETTING_KEY_USER_TOKEN],10,self.m_strTransactionId,self.m_strSymbolId];
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/index.php/Trans/add/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    
    NSURL* url = [NSURL URLWithString:lpServerAddress];
    NSLog(@"%@",lpServerAddress);
    
    [self.m_oRequest setCachePolicy: ASIDoNotWriteToCacheCachePolicy | ASIDoNotReadFromCacheCachePolicy];
    self.m_oRequest = [ASIFormDataRequest  requestWithURL:url];
    [self.m_oRequest setRequestMethod:@"POST"];
    [self.m_oRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableData *requestBody = [[[NSMutableData alloc] initWithData:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    [self.m_oRequest appendPostData:requestBody];
    [self.m_oRequest setDelegate:self];
    [self.m_oRequest setTimeOutSeconds:NETWORK_TIMEOUT];
   	[self.m_oRequest startAsynchronous];
    
    if (nil != HUD)
    {
      //  [HUD hide:YES afterDelay:0];
    }
}

-(void) doBetDownTransaction
{
    [self PopulateIndicator];
    self.responseData = [NSMutableData data];
    
    NSString * lpPostData = [NSString stringWithFormat:@"user_token=%@&trans_amount=%d&id=%@&trans_symbol_id=%@&trans_direction=0",[LYGlobalSettings GetSettingString:SETTING_KEY_USER_TOKEN],10,self.m_strTransactionId,self.m_strSymbolId];
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/index.php/Trans/add/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    
    NSURL* url = [NSURL URLWithString:lpServerAddress];
    NSLog(@"%@",lpServerAddress);
    
    [self.m_oRequest setCachePolicy: ASIDoNotWriteToCacheCachePolicy | ASIDoNotReadFromCacheCachePolicy];
    self.m_oRequest = [ASIFormDataRequest  requestWithURL:url];
    [self.m_oRequest setRequestMethod:@"POST"];
    [self.m_oRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableData *requestBody = [[[NSMutableData alloc] initWithData:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    [self.m_oRequest appendPostData:requestBody];
    [self.m_oRequest setDelegate:self];
    [self.m_oRequest setTimeOutSeconds:NETWORK_TIMEOUT];
   	[self.m_oRequest startAsynchronous];
    
    if (nil != HUD)
    {
      //  [HUD hide:YES afterDelay:0];
    }
}

#pragma network response
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    self.responseData =[NSMutableData dataWithData:[request responseData]] ;
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",responseString);
    
    NSDictionary * loRet = [LYGlobalSettings GetJsonValue: responseString];
    NSString * lpError = nil;
    int lnRet = [self ParseResponse:loRet apError:&lpError];
    self.responseData = nil;
    [LYGlobalSettings SetSettingString:SETTING_KEY_SERVER_LOGININFO apVal:responseString];
    [responseString release];
    
    
    
    if (lnRet !=0)
    {
        [self alertWrong:lpError];
    }else
    {
        [self initUI];
    }
    
    if (nil != HUD)
    {
        [HUD hide:YES afterDelay:0];
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    self.responseData = nil;
    if (nil!=HUD)
    {
        [HUD hide:YES];
    }
}





#pragma mark 错误提醒
- (void) alertWrong:(NSString *) apError
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



- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark timer
-(void) InitTimer
{
    self.m_oTimerCountDown = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimerCountDown) userInfo:nil repeats:YES];
    
    self.m_oTimerUpdate = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(UpdateData) userInfo:nil repeats:YES];
    
}
-(void)StartTimer
{
    if (nil!= self.m_oTimerCountDown)
    {
        [self.m_oTimerCountDown fire];
    }
    
    if (nil!=self.m_oTimerUpdate)
    {
        [self.m_oTimerUpdate fire];
    }
}
-(void)StopTimer
{
    if (nil!= self.m_oTimerCountDown)
    {
        [self.m_oTimerCountDown invalidate];
    }
    
    if (nil!=self.m_oTimerUpdate)
    {
         [self.m_oTimerUpdate invalidate];
    }
}
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}
-(void)onTimerCountDown
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];


    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MM/dd/YYYY HH:mm:ss" options:0 locale:nil];
    NSString *dateFormat2= [NSDateFormatter dateFormatFromTemplate:@"YYYY-MM-dd" options:0 locale:nil];
    
    [formatter setDateFormat:dateFormat2];
    NSDate *Now = [NSDate date];
    NSString * End1 = [formatter stringFromDate:Now];
    
   
    [formatter setDateFormat:dateFormat];
    NSLocale *locale = [NSLocale currentLocale];
    [formatter setLocale:locale];
    NSString *end = [[[NSString alloc ]initWithFormat:@"%@ 21:01:00",End1] autorelease];
   
    NSDate *End = [formatter dateFromString:end];
    NSTimeInterval loDiff=  [End timeIntervalSinceNow];
    if (loDiff>0)
    {
        NSString *intervalString = [self stringFromTimeInterval:loDiff];
        [self.m_oTimer setText:intervalString];
        if (loDiff<3600)
        {
            UIColor *testColor1= [UIColor colorWithRed:240/255.0 green:0/255.0 blue:0/255.0 alpha:1];
            [self.m_oTimer setTextColor:testColor1];
        }else
        {
            UIColor *testColor1= [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
            [self.m_oTimer setTextColor:testColor1];
        }
    }else
    {
        [self.m_oTimer setText:@"00:00:00"];
        UIColor *testColor1= [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        [self.m_oTimer setTextColor:testColor1];
    }
}
-(void)UpdateData
{
    [self doRefreshRemoteData:FALSE];
}

#pragma mark hud
- (void)OnHudCallBack
{
	// Do something usefull in here instead of sleeping ...
    sleep(NETWORK_TIMEOUT*2);
}

- (void)hudWasHidden:(MBProgressHUD *)apHud
{
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
    
}



- (void)PopulateIndicator
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    
	[self.navigationController.view addSubview:HUD];
    
	HUD.dimBackground = YES;
    HUD.labelText = @"刷新中";
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(OnHudCallBack) onTarget:self withObject:nil animated:YES];
    [self.navigationController.view bringSubviewToFront:HUD];
}


@end
