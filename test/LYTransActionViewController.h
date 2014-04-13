//
//  LYSecondViewController.h
//  test
//
//  Created by zhao on 14-3-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "LYGlobalSettings.h"
#import "ASIFormDataRequest.h"
#import "LYUtility.h"
#import "LYTransConst.h"
#import "EGORefreshTableHeaderView.h"

@interface LYTransActionViewController : UITableViewController<EGORefreshTableHeaderDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    int m_nCurrentPage;
    int m_nPageSize;
    int m_nLoadedItemCount;
    enum REQUEST_TYPE
    {
        REQUEST_TYPE_REFRESH = 1,
        REQUEST_TYPE_MORE = 2,
    };
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;


}
@property (retain,nonatomic) NSMutableData * responseData;
@property (retain,nonatomic) ASIFormDataRequest * m_oRequest;
@property (retain,nonatomic) NSMutableArray * m_pTranslists;

@end
