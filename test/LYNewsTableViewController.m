//
//  LYNewsTableViewController.m
//  finger
//
//  Created by zhao on 14-5-11.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "LYNewsTableViewController.h"
#import "LYWebViewController.h"
@interface NEWS()
@end

@implementation NEWS

@synthesize m_pNewsContent;
@synthesize m_pNewsUrl;
@end

@interface LYNewsTableViewController ()

@end

@implementation LYNewsTableViewController

@synthesize m_pNewslists;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)InitUI
{
    if (nil == self.m_pNewslists)
    {
        NEWS * lpNews = [[[NEWS alloc]init]autorelease];
        lpNews.m_pNewsContent = @"伦敦白银定盘价原有机制将被新电子化系统取代";
        lpNews.m_pNewsUrl = @"http://finance.sina.com.cn/money/nmetal/20140711/225319681780.shtml";
        
        

        self.m_pNewslists = [NSMutableArray arrayWithObject:lpNews];
        
        lpNews = [[[NEWS alloc]init]autorelease];
        lpNews.m_pNewsContent = @"兆丰恒业：多方面消息刺激 银价突破性上涨";
        lpNews.m_pNewsUrl = @"http://finance.sina.com.cn/money/nmetal/20140711/162319679904.shtml";
        
        [self.m_pNewslists addObject:lpNews];
    }
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self InitUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark table implement
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.m_pNewslists count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsTransView";
 
    UITableViewCell * lpCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    if (nil == lpCell)
    {
        NSInteger i= indexPath.row;
        if (i>=[self.m_pNewslists count])
        {
            assert(false);
            lpCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
            return lpCell;
        }
        lpCell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        lpCell.tag = i;
        lpCell.textLabel.text = ((NEWS *)[self.m_pNewslists objectAtIndex:i]).m_pNewsContent;
    }
    
//    UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleFingerEvent:)]autorelease];
//    
//     [lpCell addGestureRecognizer:tapGestureTel];
    
    return lpCell;
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                             bundle: nil];
    
    
    LYWebViewController  *WebViewController = (LYWebViewController *)[mainStoryboard
                                                               instantiateViewControllerWithIdentifier: @"LYWebViewController"];

    
    //And do here code for passing URL to  WebViewController
           int lnDataIndex = indexPath.row;
           NSString * lpStrUrl = ((NEWS *)[self.m_pNewslists objectAtIndex:lnDataIndex]).m_pNewsUrl;
    WebViewController.m_pNewsUrl =lpStrUrl;
   [self.navigationController pushViewController:WebViewController  animated:NO];
    
    
}

//- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
//{
//    if ([sender.view isKindOfClass:[UITableViewCell class]])
//    {
//        int lnDataIndex = sender.view.tag;
//        NSString * lpStrUrl = ((NEWS *)[self.m_pNewslists objectAtIndex:lnDataIndex]).m_pNewsUrl;
//        
//        WebViewController *WebViewController = [[TrackViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
//    }
//    
//}
//

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

@end
