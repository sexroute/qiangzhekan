//
//  LuckyNumbersViewController.m
//  LuckyNumbers
//
//  Created by Dan Grigsby on 3/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "LYSplashWindow.h"
#import "JSON.h"
#import "LYGlobalSettings.h"
#import "ASIFormDataRequest.h"
#import "LYUtility.h"
#import "LYMainWindowViewController.h"


@implementation LYSplashWindow
@synthesize m_oActivityProgressbar;
@synthesize m_oImageView;
@synthesize m_oLoginData;
@synthesize m_pResponseData;
@synthesize m_oRequest;

UITextField * g_pTextUserName = nil;
UITextField * g_pTextPassword = nil;

#pragma mark 登陆框UI处理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait; // etc
}

- (BOOL) textFieldShouldReturn:(UITextField *)tf
{
    switch (tf.tag) {
        case 0:
            [LYGlobalSettings SetSettingString:SETTING_KEY_USER apVal:tf.text];
            [LYGlobalSettings SetSettingString:SETTING_KEY_PASSWORD apVal:g_pTextPassword.text];
            [g_pTextPassword becomeFirstResponder];
            break;
        case 1:
            [self.m_oActivityProgressbar setHidden:NO];
            [self.m_oActivityProgressbar startAnimating];
            [LYGlobalSettings SetSettingString:SETTING_KEY_USER apVal:g_pTextUserName.text];
            [LYGlobalSettings SetSettingString:SETTING_KEY_PASSWORD apVal:tf.text];
            [self.m_oLoginTableView setHidden:YES];
            [self.m_oLogginButton setHidden:TRUE];
            [self LoadData];
            [g_pTextPassword resignFirstResponder];
            break;
        default:
            [tf resignFirstResponder];
            break;
    }
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"Cell";
    UITableViewCell *cell = [self.m_oLoginTableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([indexPath section] == 0) {
            UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 8, 185, 40)];
            playerTextField.adjustsFontSizeToFitWidth = YES;
            playerTextField.textColor = [UIColor blackColor];
            if ([indexPath row] == 0)
            {
                playerTextField.placeholder = @"用户名";
                playerTextField.returnKeyType = UIReturnKeyNext;
                playerTextField.tag = 0;
                g_pTextUserName = playerTextField;
                NSString * lpVal = [LYGlobalSettings GetSettingString:SETTING_KEY_USER];
                if ([lpVal length]>0)
                {
                    //playerTextField.text = lpVal;
                }
            }
            else
            {
                playerTextField.placeholder = @"密码";
                playerTextField.keyboardType = UIKeyboardTypeDefault;
                playerTextField.returnKeyType = UIReturnKeyGo;
                playerTextField.secureTextEntry = YES;
                playerTextField.tag = 1;
                g_pTextPassword = playerTextField;
                NSString * lpVal = [LYGlobalSettings GetSettingString:SETTING_KEY_PASSWORD];
                if ([lpVal length]>0)
                {
                    //playerTextField.text = lpVal;
                }
                
            }
            playerTextField.backgroundColor = [UIColor whiteColor];
            playerTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            playerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
            playerTextField.textAlignment = UITextAlignmentLeft;
            
            playerTextField.delegate = self;
            
            playerTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
            [playerTextField setEnabled: YES];
            
            [cell.contentView addSubview:playerTextField];
            
            [playerTextField release];
        }
    }
    if ([indexPath section] == 0)
    {
    }
    else
    {
        
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


#pragma mark 视图初始化
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self InitUI];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if ([self IsLogin])
    {
        [self.m_oLoginTableView setHidden:YES];
        [self.m_oLabelLogin setHidden:YES];
        [self.m_oLogginButton setHidden:YES];
    }else
    {
        [self.m_oLoginTableView setHidden:NO];
        [self.m_oLabelLogin setHidden:NO];
        [self.m_oLogginButton setHidden:NO];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.m_oRequest setDelegate:nil];
    [self.m_oRequest cancel];
    self.m_oRequest = nil;
}
-(void) InitUI
{
    //1.根据分辨率和设备类型处理背景图片
    int lnHeight = [[UIScreen mainScreen] bounds].size.height ;
    int lnWeight = [[UIScreen mainScreen] bounds].size.width;
    self.m_oImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,lnWeight,lnHeight)]autorelease];
    CGRect frame =self.m_oLoginTableView.frame;
    
    switch (lnHeight)
    {
        case 480:
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                self.m_oImageView.image = [UIImage imageNamed:@"Default@2x.png"];
            }
            else
            {
                self.m_oImageView.image = [UIImage imageNamed:@"Default.png"];
            }
            
            frame.origin.x = self.m_oLoginTableView.frame.origin.x;
            
            
            self.m_oLoginTableView.frame = frame;
            break;
            
        case 568:
            self.m_oImageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
            frame =self.m_oLoginTableView.frame;
            frame.origin.x = self.m_oLoginTableView.frame.origin.x;
            frame.origin.y = 160;
            self.m_oLoginTableView.frame = frame;
            break;
            
        case 1024:
            
            frame =self.m_oLoginTableView.frame;
            frame.origin.x = self.m_oLoginTableView.frame.origin.x;
            if(IS_RETINA)
            {
                frame.origin.y = 60;
                self.m_oImageView.image = [UIImage imageNamed:@"Default-Portrait@2x~ipad.png"];
            }else
            {
                self.m_oImageView.image = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
                frame.origin.y = 30;
            }
            self.m_oLoginTableView.frame = frame;
            break;
        default:
            self.m_oImageView.image = [UIImage imageNamed:@"Default.png"];
            break;
    }
    
    
    [self.view insertSubview:self.m_oImageView atIndex:0];
    
    frame = self.m_oActivityProgressbar.frame;
    frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = self.view.frame.size.height /2 - frame.size.height / 2;
    self.m_oActivityProgressbar.frame = frame;
    //2.判断是否已经登陆
    self.m_oLoginTableView.bounds  =CGRectMake(164, 220, 240, 80);
    if ([self IsLogin])
    {
        [self.m_oActivityProgressbar setHidden:NO];
        [self.m_oLoginTableView setHidden:YES];
        self.m_oLoginTableView.delegate = self;
        self.m_oLoginTableView.dataSource = self;
        [self LoadData];
        
    }else
    {
        [self.m_oActivityProgressbar setHidden:YES];
        [self.m_oActivityProgressbar stopAnimating];
        [self.m_oLoginTableView setHidden:NO];
        self.m_oLoginTableView.delegate = self;
        self.m_oLoginTableView.dataSource = self;
        
        
        [self.m_oLogginButton setHidden:NO];
    }
    
    
    //3.登录按钮处理
    UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleFingerEvent:)]autorelease];
    
    
    [self.m_oLabelLogin addGestureRecognizer:tapGestureTel];
    [self.m_oLogginButton addGestureRecognizer:tapGestureTel];
    
    frame = self.m_oLogginButton.frame;
    frame.origin.x = self.m_oLoginTableView.frame.origin.x;
    frame.origin.y = self.m_oLoginTableView.frame.origin.y+self.m_oLoginTableView.frame.size.height+5;
    self.m_oLogginButton.frame = frame;
    
    
    //4.navigation bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(float)34/255.0 green:(float)(199)/255.0 blue:((float)253)/255.0 alpha:1.0]];
    
    
    NSShadow *shadow = [[[NSShadow alloc] init]autorelease];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           nil, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    //5.status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}


- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    if (nil == g_pTextUserName.text)
    {
        g_pTextUserName.text = @"";
    }
    
    if (nil == g_pTextPassword.text)
    {
        g_pTextPassword.text = @"";
    }
    [LYGlobalSettings SetSettingString:SETTING_KEY_USER apVal:g_pTextUserName.text];
    [LYGlobalSettings SetSettingString:SETTING_KEY_PASSWORD apVal:g_pTextPassword.text];
    [self.m_oLoginTableView setHidden:YES];
    [self.m_oActivityProgressbar setHidden:NO];
    [self.m_oActivityProgressbar startAnimating];
    [self LoadData];
    [g_pTextPassword resignFirstResponder];
    [self.m_oLogginButton setHidden:TRUE];
    
}
-(BOOL)IsLogin
{
    NSString * lpLogin = [LYGlobalSettings GetSettingString:SETTING_KEY_LOGIN];
    BOOL lbLogin = NO;
    if (nil != lpLogin)
    {
        lpLogin = [lpLogin stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([lpLogin caseInsensitiveCompare:@"1"] == NSOrderedSame)
        {
            lbLogin = YES;
        }
    }
    
    
    return lbLogin;
}
- (void)LoadData
{
    [self LoadDataASIHTTPRequest];
}
#pragma mark ASIHTTPRequest Methods 
- (void)LoadDataASIHTTPRequest
{

    self.m_pResponseData = [NSMutableData data];
    
    NSString * lpPostData = [NSString stringWithFormat:@"user_name=%@&user_password=%@",[LYGlobalSettings GetSettingString:SETTING_KEY_USER],[LYGlobalSettings GetSettingString:SETTING_KEY_PASSWORD]];
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/index.php/Reg/login/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    
    NSURL* url = [NSURL URLWithString:lpServerAddress];
    DLog(@"%@",lpServerAddress);
    
    self.m_oRequest = [ASIFormDataRequest  requestWithURL:url];
    [self.m_oRequest setRequestMethod:@"POST"];
    [self.m_oRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSMutableData *requestBody = [[[NSMutableData alloc] initWithData:[lpPostData dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    [self.m_oRequest appendPostData:requestBody];
    [self.m_oRequest setDelegate:self];
    [self.m_oRequest setTimeOutSeconds:NETWORK_TIMEOUT];
   	[self.m_oRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.m_pResponseData  =[NSMutableData dataWithData:[request responseData]] ;
    
    NSString *responseString = [[[NSString alloc] initWithData:self.m_pResponseData  encoding:NSUTF8StringEncoding]autorelease];

    DLog(@"%@",responseString);
	
	NSError *error = nil;
	SBJSON *json = [[SBJSON new] autorelease];
	self.m_oLoginData = [json objectWithString:responseString error:&error];
    NSString * lpError = nil;
	if (![LYUtility IsReturnDataValid:self.m_oLoginData apError:&lpError])
	{
        BOOL isNetworkError = NO;
        //1.网络等错误
        if ([error isKindOfClass:[NSError class]])
        {
            label.text = [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
            isNetworkError=YES;
        }
        
        if (isNetworkError)
        {
            [self alertLoadFailed];
            [LYGlobalSettings SetSettingString:SETTING_KEY_SERVER_LOGININFO apVal:@""];
        }else
        {
            [self alertWrongLogin:lpError];
            [self.m_oLoginTableView setHidden:NO];
            [LYGlobalSettings SetSettingString:SETTING_KEY_LOGIN apVal:@"0"];
            [LYGlobalSettings SetSettingString:SETTING_KEY_SERVER_LOGININFO apVal:@""];
        }
        
    }
	else
    {
        id lpVal = [self.m_oLoginData objectForKey:@"val"];
        if ([lpVal isKindOfClass:[NSDictionary class]])
        {
             lpVal = [lpVal objectForKey:@"user_token"];
            if ([lpVal isKindOfClass:[NSString class]])
            {
                [LYGlobalSettings SetSettingString:SETTING_KEY_USER_TOKEN apVal:lpVal];
                [LYGlobalSettings SetSettingString:SETTING_KEY_LOGIN apVal:@"1"];
                [self.m_oLoginTableView setHidden:YES];
                [self navigateToMainWindow];
                [LYGlobalSettings SetSettingString:SETTING_KEY_SERVER_LOGININFO apVal:responseString];
                return;
            }

        }
        
        
        {
            [self alertWrongLogin:@"网络错误"];
            [self.m_oLoginTableView setHidden:NO];
            [LYGlobalSettings SetSettingString:SETTING_KEY_LOGIN apVal:@"0"];
            [LYGlobalSettings SetSettingString:SETTING_KEY_SERVER_LOGININFO apVal:@""];

        }
        

	}
    self.m_pResponseData  = nil;

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
        [self alertLoadFailed];
}

#define kDuration 0.7   // 动画持续时间(秒)
- (void) startAnimate:(UIView *) apDstView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:kDuration];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:apDstView cache:YES];
    
    [UIView setAnimationDelegate:self];
    
}

#pragma mark 错误提醒
- (void) alertWrongLogin:(NSString *) apError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆错误" message:apError
												   delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    alert.tag = 0;
    [alert show];
    [alert release];
}

- (void) alertLoadFailed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法获取数据, 重试?"
												   delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 1;
    [alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (nil!=actionSheet && actionSheet.tag== 1)
    {
        if (buttonIndex == 0)
        {
            if ([self IsLogin])
            {
                [self navigateToMainWindow];
                
            }else
            {
                [self.m_oActivityProgressbar setHidden:TRUE];
                [self.m_oLoginTableView setHidden:NO];
                [self.m_oLogginButton setHidden:NO];
            }
            
        }
        else
        {
            [self.m_oActivityProgressbar startAnimating];
            [self LoadData];
        }
    }else
    {
        
        [self.m_oActivityProgressbar setHidden:TRUE];
        [self.m_oLoginTableView setHidden:NO];
        [self.m_oLogginButton setHidden:NO];
    }
    
}


#pragma mark 导航到设备

- (void) navigateToMainWindow
{
    self.m_oActivityProgressbar.hidesWhenStopped = TRUE;
    label.text = @"";
    [self.m_oActivityProgressbar stopAnimating];
    
    //2. load view
    if (nil == self->m_pMainWindow)
    {

        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                                 bundle: nil];
        
        
        UIViewController  *lpviewController = (UIViewController *)[mainStoryboard
                                                                               instantiateViewControllerWithIdentifier: @"MainWindow"];
        
        if ([lpviewController isKindOfClass:[LYMainWindowViewController class]])
        {
            
            LYMainWindowViewController * lpController = (LYMainWindowViewController*)lpviewController;
            
            lpController.m_oLoginData = self.m_oLoginData;
            
            lpviewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            
            [self presentViewController:lpviewController animated:YES completion:nil];
            
            [UIView commitAnimations];
            
            
        }
        return;
    }
}




#pragma mark 析构

- (void)dealloc {
    
    [m_oActivityProgressbar release];
    self.m_oImageView = nil;
    
    self.m_pResponseData = nil;
    
    [_m_oLoginTableView release];
    [_m_oLogginButton release];
    [_m_oLabelLogin release];
    [super dealloc];
}



- (void)viewDidUnload {
    
    [self setM_oActivityProgressbar:nil];
    self.m_oImageView = nil;
    [self setM_oImageView:nil];
    [self setM_oImageView:nil];
    self.m_pResponseData = nil;
    
    [self setM_oLoginTableView:nil];
    [self setM_oLogginButton:nil];
    [self setM_oLabelLogin:nil];
    [super viewDidUnload];
}
@end
