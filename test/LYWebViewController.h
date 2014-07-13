//
//  LYWebViewController.h
//  finger
//
//  Created by zhao on 14-7-13.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYWebViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIWebView *m_pView;
@property (retain,nonatomic)  NSString * m_pNewsUrl;
@end
