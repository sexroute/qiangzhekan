//
//  LYSecondViewController.m
//  test
//
//  Created by zhao on 14-3-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "LYTransActionViewController.h"
#import "LYGuessListTableViewCell.h"
#include <stdlib.h>
@interface LYTransActionViewController ()

@end

@implementation LYTransActionViewController
@synthesize responseData;
@synthesize m_oRequest;
@synthesize m_pTranslists;
@synthesize m_pHeader;
@synthesize m_pFooter;
#pragma mark init

- (void)viewDidLoad
{
    [super viewDidLoad];
    self->m_nPageSize = 10;
    self->m_nCurrentPage = 1;
    self->m_nLoadedItemCount = 0;
    self->_reloading = false;
    self.m_pTranslists = [[[NSMutableArray alloc]init]autorelease];
    [self InitUI];
    [self LoadMoreData:TRUE];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) doCloseRemoteTransaction:(int)anTransID
{
    [self PopulateIndicator];
    self.responseData = [NSMutableData data];
    
    NSString * lpPostData = [NSString stringWithFormat:@"user_token=%@&id=%d",[LYGlobalSettings GetSettingString:SETTING_KEY_USER_TOKEN],anTransID];
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/index.php/Trans/close/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    
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
    self.m_oRequest.tag = 3;
   	[self.m_oRequest startAsynchronous];
    
    if (nil != HUD)
    {
        //  [HUD hide:YES afterDelay:0];
    }
}
-(void)InitUI
{
    //1.拖拽刷新
    if (self.m_pHeader == nil)
    {
        self.m_pHeader = [[MJRefreshHeaderView header]autorelease];
        self.m_pHeader.scrollView = self.tableView;
        self.m_pHeader.delegate = self;
    }
    
    if (self.m_pFooter == nil)
    {
        self.m_pFooter = [[MJRefreshFooterView footer]autorelease];
        self.m_pFooter.scrollView = self.tableView;
        self.m_pFooter.delegate = self;
    }
    self.navigationItem.title = @"战绩";
    self.navigationController.title = @"战绩";
    //4.navigation item
    
}

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    
    [self RefreshData:TRUE];
    _reloading = YES;
    
    
    
}

- (void)doneLoadingTableViewData
{
    if (self.m_pHeader)
    {
        [self.m_pHeader endRefreshing];
    }
    
    if (self.m_pFooter)
    {
        [self.m_pFooter endRefreshing];
    }
    
}

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----开始进入刷新状态", refreshView.class);
    
    // 1.添加假数据

    
    // 2.2秒后刷新表格UI
    if (refreshView == self.m_pHeader)
    {
         [self RefreshData:TRUE];
    }
    else
    {
        [self LoadMoreData:TRUE];
    }
}

#pragma mark 刷新完毕
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----刷新完毕", refreshView.class);
}

#pragma mark 监听刷新状态的改变
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    switch (state) {
        case MJRefreshStateNormal:
            NSLog(@"%@----切换到：普通状态", refreshView.class);
            break;
            
        case MJRefreshStatePulling:
            NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
            break;
            
        case MJRefreshStateRefreshing:
            NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    //[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark table implement
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
     return [self.m_pTranslists count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    if ([sender.view isKindOfClass:[UIImageView class]])
    {
    
        UIImageView * lpImagg = (UIImageView *)sender.view;
        int lnDataIndex = lpImagg.tag;
        id loTrans = [self.m_pTranslists objectAtIndex:lnDataIndex];
        int lnTransId  = [[loTrans objectForKey:@"id"]integerValue];
        int lnTransStatus =[[loTrans objectForKey:@"trans_status"]integerValue];
        if ([LYTransConst IsStatusPending:lnTransStatus])
        {
            [self alertWrong:@"交易处理中，请稍候"];
            return;
        }else if ([LYTransConst IsStatusFinish:lnTransStatus])
        {
            [self alertWrong:@"交易已结束"];
            return;
        }
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"结算确认" message:@"确认结算么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil] autorelease];
        alertView.tag = lnTransId;
        [alertView show];
       
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TransView";
    LYGuessListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSInteger i= indexPath.row;
        if (i>=[self.m_pTranslists count])
        {
            assert(false);
            cell = [[[LYGuessListTableViewCell alloc]init]autorelease];
            return cell;
        }
        
        if(!cell)
        {
            //加载自定义表格
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"guset_list_cell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                if([currentObject isKindOfClass:[LYGuessListTableViewCell class]])
                {
                    cell = (LYGuessListTableViewCell *)currentObject;
                    
                    NSDictionary * loTrans = (NSDictionary *)[self.m_pTranslists objectAtIndex:i];
                    NSString * lpStrSymbolTitle = [loTrans  objectForKey:@"symbol_name"];
                    //1.symbol_name
                    cell.m_oSymbolTitle.text = [NSString stringWithFormat:@"%@",lpStrSymbolTitle];
                    //2.涨跌
                    int lnDirection = [[loTrans objectForKey:@"trans_direction"]intValue];
                    if (lnDirection>0)
                    {
                        cell.m_oBetTitle.text = [NSString stringWithFormat:@"%@",@"看涨:"];
                    }else
                    {
                        cell.m_oBetTitle.text = [NSString stringWithFormat:@"%@",@"看跌:"];
                    }
                    
                    //8.交易状态
                    int lnTransStatus = [[loTrans objectForKey:@"trans_status"]doubleValue];
                    
                    //3.当前价
                    double ldblCurrentValue = [[loTrans objectForKey:@"symbol_current_value"]doubleValue];
                    cell.m_oCurrentValue.text = [NSString stringWithFormat:@"%.2f",ldblCurrentValue];
                    
                    if ([LYTransConst IsStatusFinish:lnTransStatus])
                    {
                        ldblCurrentValue = [[loTrans objectForKey:@"trans_finish_symbol_value"]doubleValue];
                    }
                    
                    //4.下注价
                    double ldblBetValue = [[loTrans objectForKey:@"trans_symbol_value"]doubleValue];
                    cell.m_oBetValue.text = [NSString stringWithFormat:@"%.2f",ldblBetValue];
                    
                    //5.下注额度
                    double ldblBetAmount = [[loTrans objectForKey:@"trans_amount"]doubleValue];
                    //6.赔率
                    double ldblBetRatio = [[loTrans objectForKey:@"trans_ratio"]doubleValue];
                    

                    //7.收益
                    double ldblGain = (ldblCurrentValue - ldblBetValue)* lnDirection*ldblBetAmount*ldblBetRatio;
                    
                    cell.m_ogain.text = [NSString stringWithFormat:@"%.2f",ldblGain];
                    
      
                    
                    NSString * lpStatus = [LYTransConst GetTransStatusReason:lnTransStatus];
                    cell.m_oTransactionStatus.text = [NSString stringWithString:lpStatus];
                    
                    cell.m_oStatusIcon.userInteractionEnabled = YES;
                    cell.m_oStatusIcon.tag = indexPath.row;
                    UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleFingerEvent:)]autorelease];
                   [cell.m_oStatusIcon addGestureRecognizer:tapGestureTel];
                    
                    if (lnTransStatus != STATUS_TRANS_TRANS_CLOSE)
                    {
                        if (ldblGain == 0)
                        {
                            cell.m_ogain.textColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
                            cell.m_oStatusIcon.image =[ [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guess_win" ofType:@"png"]]autorelease];
                            
                        }else if(ldblGain >0)
                        {
                            cell.m_ogain.textColor =  [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1];
                            cell.m_oStatusIcon.image =[ [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guess_win" ofType:@"png"]]autorelease];
                            
                        }else
                        {
                            cell.m_ogain.textColor =  [UIColor colorWithRed:0/255.0 green:255/255.0 blue:0/255.0 alpha:1];
                            cell.m_oStatusIcon.image =[ [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guess_cancel" ofType:@"png"]]autorelease];
                            
                        }
                    }else
                    {
                        if (ldblGain >= 0)
                        {
                            cell.m_ogain.textColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
                            cell.m_oStatusIcon.image =[ [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guess_win_gray" ofType:@"png"]]autorelease];
                            
                        }else if(ldblGain >0)
                        {
                            cell.m_ogain.textColor =  [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1];
                            cell.m_oStatusIcon.image =[ [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guess_win_gray" ofType:@"png"]]autorelease];
                            
                        }else
                        {
                            cell.m_ogain.textColor =  [UIColor colorWithRed:0/255.0 green:255/255.0 blue:0/255.0 alpha:1];
                            cell.m_oStatusIcon.image =[ [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guess_lose" ofType:@"png"]]autorelease];
                            
                        }
                    }
                    
                    //交易时间 [TBC]
                     NSString *   lpTransTime = [loTrans objectForKey:@"trans_start_time"];
                    cell.m_oTransactionTime.text = [NSString stringWithString:lpTransTime];
                    break;
                    
                    
                }
            }
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    //cell.text = lpResult;
    
    return cell;
}
#pragma mark loadData
-(void) LoadMoreData:(BOOL)abHud
{
    if(abHud)
    {
        [self PopulateIndicator];
    }
    self.responseData = [NSMutableData data];
    
    NSString * lpPostData = [NSString stringWithFormat:@"user_token=%@&page_cur_pos=%d&page_count=%d",[LYGlobalSettings GetSettingString:SETTING_KEY_USER_TOKEN],self->m_nCurrentPage,(self->m_nPageSize+self->m_nLoadedItemCount)];
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/index.php/Trans/listAll/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    
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
   	[self.m_oRequest startSynchronous];
    self.m_oRequest.tag = REQUEST_TYPE_MORE;
}

-(void) RefreshData:(BOOL)abHud
{
    if(abHud)
    {
        [self PopulateIndicator];
    }
    self.responseData = [NSMutableData data];
    NSString * lpPostData = [NSString stringWithFormat:@"user_token=%@&page_cur_pos=%d&page_count=%d&r=%f",[LYGlobalSettings GetSettingString:SETTING_KEY_USER_TOKEN],self->m_nCurrentPage,(self->m_nLoadedItemCount>self->m_nPageSize?self->m_nLoadedItemCount:self->m_nPageSize),(arc4random_uniform(1000)/1000.0)];
    NSString * lpServerAddress = [NSString stringWithFormat:@"%@/index.php/Trans/listAll/",[LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_ADDRESS]];
    
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
    self.m_oRequest.tag = REQUEST_TYPE_REFRESH;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    self.responseData =[NSMutableData dataWithData:[request responseData]] ;
    
    if (request.tag == 3)
    {
        
    }else
    {
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    DLog(@"%@",responseString);
    
    NSDictionary * loRet = [LYGlobalSettings GetJsonValue: responseString];
    NSString * lpError = nil;
    int lnRet = [self ParseResponseForMoreData:loRet apError:&lpError];
    self.responseData = nil;
    [LYGlobalSettings SetSettingString:SETTING_KEY_SERVER_LOGININFO apVal:responseString];
    [responseString release];
    if (lnRet !=0)
    {
        [self alertWrong:lpError];
    }else
    {
        
    }
    }
    
    [self.m_oRequest removeTemporaryDownloadFile ];
    
    if (nil != HUD)
    {
        [HUD hide:YES afterDelay:0];
    }
    [self doneLoadingTableViewData];
    [self.tableView reloadData];
}

-(int)ParseResponseForMoreData:(NSDictionary * )apData apError:(NSString**)apError
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
            
            if([loRetCode intValue]==0)
            {
                loRet = [apData objectForKey:@"val"];
                if([loRet isKindOfClass:[NSArray class]])
                {
                     NSArray* lpResponseData = (NSArray *)loRet;
                    if ([lpResponseData count]>0)
                    {
                        
                        if (self.m_oRequest.tag == REQUEST_TYPE_MORE)
                        {
                            [self.m_pTranslists addObjectsFromArray:loRet];
                            self->m_nLoadedItemCount +=[lpResponseData count];
                        }
                        else
                        {
                            [self.m_pTranslists removeAllObjects];
                            [self.m_pTranslists addObjectsFromArray:loRet];
                            self->m_nLoadedItemCount =0;
                            self->m_nLoadedItemCount +=[lpResponseData count];
                        }
                    }
     
                }
            }
            return  lbRet;
            
        }
    }
    *apError = [[NSString alloc]initWithString:@"未知错误"];
    return -1234;
}



- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    self.responseData = nil;
    if (nil!=HUD)
    {
        [HUD hide:YES];
    }
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
    if (buttonIndex == 1)
    {
        [self doCloseRemoteTransaction:alertView.tag];
    }
   
    
}

#pragma mark 析构
- (void)viewDidUnload
{
    self.m_oRequest = nil;
    self.m_pTranslists = nil;
    self.m_pFooter =nil;
    self.m_pHeader = nil;
    
}

- (void)dealloc
{
    self.m_pTranslists = nil;
    self.m_oRequest = nil;
    _refreshHeaderView = nil;
    self.m_pFooter =nil;
    self.m_pHeader = nil;
    [super dealloc];
}
@end
