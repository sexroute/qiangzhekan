//
//  LYAccountViewController.m
//  finger
//
//  Created by zhao on 14-3-30.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "LYAccountViewController.h"
#import "LYGlobalSettings.h"
#import "JSON.h"
#import "LYUtility.h"
@interface LYAccountViewController ()

@end

@implementation LYAccountViewController

@synthesize m_oRequest;
@synthesize m_oLoginData;
@synthesize responseData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self doRefreshRemoteData:TRUE];
    [self.m_totalAsset setUserInteractionEnabled:false];
     [self.m_oCash setUserInteractionEnabled:false];
     [self.m_oBet setUserInteractionEnabled:false];
     [self.m_oAmount setUserInteractionEnabled:false];
    [self.m_oLastAsset setUserInteractionEnabled:false];
 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   // [self doRefreshRemoteData:TRUE];

    UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleFingerEvent:)]autorelease];
    
    [self.m_oQuit addGestureRecognizer:tapGestureTel];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) initUI
{
    [self ParseAccountData:  [LYGlobalSettings GetJsonValue: [LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_LOGININFO]]];
    self.navigationItem.title = @"账号信息";
    
}

- (int) ParseAccountData:(NSDictionary *) apData
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
            id loValueAccount = [loValue objectForKey:@"account"];
            if ([loValueAccount isKindOfClass:[NSDictionary class]])
            {
                NSDictionary * lpSymbol = (NSDictionary *)loValueAccount;
                id loSymbolValue = [lpSymbol objectForKey:@"account_cash"];
                double ldblValueCash = [loSymbolValue doubleValue];
                loSymbolValue = [NSString stringWithFormat:@"%.2f",ldblValueCash];
                [self.m_oCash setText:(NSString*)loSymbolValue];

                
                loSymbolValue = [lpSymbol objectForKey:@"account_asset_last"];
                double ldblAccount_asset_last = [loSymbolValue doubleValue];
                loSymbolValue = [NSString stringWithFormat:@"%.2f",ldblAccount_asset_last];
                 [self.m_oLastAsset setText:(NSString*)loSymbolValue];
                
                loSymbolValue = [lpSymbol objectForKey:@"account_guess_asset"];
                double ldblAccount_guess_asset = [loSymbolValue doubleValue];
                loSymbolValue = [NSString stringWithFormat:@"%.2f",ldblAccount_guess_asset];
                 [self.m_oBet setText:(NSString*)loSymbolValue];
                
                loSymbolValue = [lpSymbol objectForKey:@"account_asset"];
                double ldblaccount_asset = ldblValueCash+ldblAccount_guess_asset;
                loSymbolValue = [NSString stringWithFormat:@"%.2f",ldblaccount_asset];
                [self.m_totalAsset setText:(NSString*)loSymbolValue];
                
            }
            loValueAccount = [loValue objectForKey:@"account"];
            if ([loValueAccount isKindOfClass:[NSDictionary class]])
            {
                NSDictionary * lpSymbol = (NSDictionary *)loValueAccount;
                id loSymbolValue = [lpSymbol objectForKey:@"account_cash_in_guess"];
                double ldblValue = [loSymbolValue doubleValue];
                
                if (ldblValue <= 0)
                {
                    
                    
                    loSymbolValue = [lpSymbol objectForKey:@"account_cash"];
                    ldblValue = [loSymbolValue doubleValue];
                    loSymbolValue = [NSString stringWithFormat:@"%.2f",ldblValue];
                    [self.m_totalAsset setText:(NSString*)loSymbolValue];
                    ldblValue = 0;

                }
                 loSymbolValue = [NSString stringWithFormat:@"%.2f",ldblValue];
                [self.m_oAmount setText:(NSString*)loSymbolValue];
            }else
            {
                [self.m_oAmount setText:(NSString*)@"0.00"];

            }
        }
        
    }
    return lbRet;
}

- (void) alertlogout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认要退出当前账户么"
												   delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 1;
    [alert show];
    [alert release];
}

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    
    [self alertlogout];
}

-(void)navigatToLogin
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                             bundle: nil];
    
    
    UIViewController  *lpviewController = (UIViewController *)[mainStoryboard
                                                               instantiateViewControllerWithIdentifier: @"LYSplashWindow"];
    
    if ([lpviewController isKindOfClass:[UIViewController class]])
    {
        
        UIViewController * lpController = (UIViewController*)lpviewController;
        
        lpviewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        [self presentViewController:lpviewController animated:YES completion:nil];
        
        [UIView commitAnimations];
        
        
    }
    return;
}

-(void)doLogoOut
{
    
    //1.将登录状态设置为0
    [LYGlobalSettings SetSettingString:SETTING_KEY_USER_TOKEN apVal:@"0"];
    [LYGlobalSettings SetSettingString:SETTING_KEY_LOGIN apVal:@"0"];
    [LYGlobalSettings SetSettingString:SETTING_KEY_USER apVal:@"0"];
    [LYGlobalSettings SetSettingString:SETTING_KEY_PASSWORD apVal:@"0"];
    //2.导航至splash window
    [self navigatToLogin];
    
}

#pragma network response
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    self.responseData =[NSMutableData dataWithData:[request responseData]] ;
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    DLog(@"%@",responseString);
    
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

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (nil!=actionSheet && actionSheet.tag== 1)
    {
        if (buttonIndex==1)
        {
            [self doLogoOut];
        }
    }else
    {
        
        
    }
    
}



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
    DLog(@"%@",lpServerAddress);
    
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

- (void)dealloc {
    [_m_totalAsset release];
    [_m_oCash release];
    [_m_oBet release];
    [_m_oAmount release];
    [_m_oLastAsset release];
    [_m_oQuit release];
    self.m_oRequest = nil;
    self.m_oLoginData = nil;
    
    [super dealloc];
}
@end
