//
//  LYWebViewController.m
//  finger
//
//  Created by zhao on 14-7-13.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "LYWebViewController.h"

@interface LYWebViewController ()

@end

@implementation LYWebViewController
@synthesize m_pNewsUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
    //创建UIActivityIndicatorView背底半透明View
   
    //[activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   // [activityIndicator stopAnimating];
     NSLog(@"webViewDidFinishLoad");
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleBlackTranslucent;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
    //  [view removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.m_pNewsUrl!=nil)
    {
      //  self.m_pView.delegate = self;
        if (nil!=self.m_pView)
        {
           // [self.m_pView setDelegate:self];
            
             NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.m_pNewsUrl]];
            [self.m_pView   loadRequest:request];
        }
    }
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
