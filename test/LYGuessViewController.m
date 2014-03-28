//
//  LYFirstViewController.m
//  test
//
//  Created by zhao on 14-3-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "LYGuessViewController.h"

@interface LYGuessViewController ()

@end

@implementation LYGuessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_oSymbolTitle release];
    [_m_oSymbol_Price release];
    [_m_oNavigationBar release];
    [_m_oUserIcon release];
    [_m_oUserName release];
    [_m_oUserMail release];
    [super dealloc];
}
- (void) initUI
{

    //1.status bar
    [self setNeedsStatusBarAppearanceUpdate];
    
    

}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
