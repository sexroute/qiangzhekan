//
//  LYNewsTableViewController.h
//  finger
//
//  Created by zhao on 14-5-11.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LYNewsTableViewController : UITableViewController
@property (retain,nonatomic) NSMutableArray * m_pNewslists;
@end



@interface NEWS : NSObject
@property (retain,nonatomic) NSString * m_pNewsContent;
@property (retain,nonatomic) NSString * m_pNewsUrl;
@end