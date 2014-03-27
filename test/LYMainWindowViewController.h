//
//  LYMainWindowViewController.h
//  finger
//
//  Created by zhao on 14-3-27.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYMainWindowViewController : UITabBarController
{
    NSDictionary *m_oLoginData;
}
@property (retain, nonatomic) NSDictionary *m_oLoginData;
@end
