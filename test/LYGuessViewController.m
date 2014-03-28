//
//  LYFirstViewController.m
//  test
//
//  Created by zhao on 14-3-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "LYGuessViewController.h"
#import "LYMainWindowViewController.h"
#import "LYGlobalSettings.h"
@interface LYGuessViewController ()

@end

@implementation LYGuessViewController
@synthesize m_oLoginData;
@synthesize m_strSymbolTitle;
@synthesize m_strUserName;
@synthesize m_strUserMail;
@synthesize m_strUserUserIcon;
@synthesize m_dbl_Symbol_price;
@synthesize m_strTimeCountDown;
@synthesize m_nTransactionDirection;
@synthesize m_bSymbolSucceed;
@synthesize m_strSymbolReason;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self ResetUserData];
    [self ResetSymbolData];
    [self initUI];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)ResetTransactionData
{
    self.m_nTransactionDirection = TRANS_NONE_TRANS;
}

-(void)ResetUserData
{
    self.m_strUserName = [[NSString alloc]initWithFormat:@"未登录"];
    self.m_strUserMail = [[NSString alloc]initWithFormat:@""];
    self.m_oUserIcon.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"du" ofType:@"png"]];
    
}

-(void)ResetSymbolData
{
    self.m_strSymbolTitle = [[NSString alloc] initWithFormat:@"竞猜-没有数据"];
    self.m_dbl_Symbol_price = 0.0;
    self.m_strTimeCountDown = [[NSString alloc] initWithFormat:@"00:00:00"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_oSymbolTitle release];
    [_m_oSymbol_Price release];
    [_m_oUserIcon release];
    [_m_oUserName release];
    [_m_oUserMail release];
    [_m_oImgUp release];
    [_m_oImgDown release];
    [_m_oLblCountdown release];
    [super dealloc];
}
- (BOOL) ParseUserData:(NSDictionary *) apData
{
    BOOL lbRet = FALSE;
    if([apData isKindOfClass:[NSDictionary class]])
    {
        id loValue = [apData objectForKey:@"val"];
        if ([loValue isKindOfClass:[NSDictionary class]])
        {
            id loUserValue = [loValue objectForKey:@"user_name"];
            if ([loUserValue isKindOfClass:[NSString class]])
            {
                self.m_strUserName =[[NSString alloc] initWithFormat:@"%@",(NSString *)loUserValue];
                 loUserValue = [loValue objectForKey:@"user_email"];
                if ([loUserValue isKindOfClass:[NSString class]])
                {
                    self.m_strUserMail =[[NSString alloc] initWithFormat:@"%@",(NSString *)loUserValue];
                    loUserValue = [loValue objectForKey:@"user_avatar_url"];
                    if ([loUserValue isKindOfClass:[NSString class]])
                    {
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)loUserValue]]];
                        
                        if (nil == image)
                        {
                             self.m_oUserIcon.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"du" ofType:@"png"]];
                        }else
                        {
                             self.m_oUserIcon.image = image;
                        }
                        
                    }else
                    {
                         self.m_oUserIcon.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"du" ofType:@"png"]];
                    }
                    lbRet = TRUE;
                }
            }
        }
        
    }
    return lbRet;

}
- (enum TRANS_ACTION_TYPE) ParseTransaction:(NSDictionary *) apData
{
    enum TRANS_ACTION_TYPE lnRet = TRANS_NONE_TRANS;
    
     if([apData isKindOfClass:[NSDictionary class]])
     {
         id loValue = [apData objectForKey:@"val"];
         if ([loValue isKindOfClass:[NSDictionary class]])
         {
              id loTransValue = [loValue objectForKey:@"user_trans"];
             if ([loTransValue isKindOfClass:[NSDictionary class]])
             {
                 loTransValue = [loTransValue objectForKey:@"trans_direction"];
                  if ([loTransValue isKindOfClass:[NSString class]])
                  {
                      self.m_nTransactionDirection = [(NSString *)loTransValue intValue];
                      lnRet = self.m_nTransactionDirection;
                  }
             }
             
         }
     }
    return lnRet;
}
- (BOOL) ParseSymbolData:(NSDictionary *) apData
{
    BOOL lbRet = FALSE;
    if([apData isKindOfClass:[NSDictionary class]])
    {
        id loValue = [apData objectForKey:@"val"];
        if ([loValue isKindOfClass:[NSDictionary class]])
        {
            loValue = [loValue objectForKey:@"symbol"];
            if ([loValue isKindOfClass:[NSDictionary class]])
            {
                NSDictionary * lpSymbol = (NSDictionary *)loValue;
                id loSymbolValue = [lpSymbol objectForKey:@"symbol_name"];
                if ([loSymbolValue isKindOfClass:[NSString class]])
                {
                   self.m_strSymbolTitle = [[NSString alloc] initWithFormat:@"%@",(NSString *)loSymbolValue];
                    loSymbolValue = [lpSymbol objectForKey:@"symbol_current_value"];
                    if ([loSymbolValue isKindOfClass:[NSString class]])
                        
                    {
                        self.m_dbl_Symbol_price = [(NSString*)loSymbolValue doubleValue];
                        lbRet = TRUE;
                    }
                }
            }
        }
       
    }
     return lbRet;
}
- (void) initUI
{

    //1.status bar
    [self setNeedsStatusBarAppearanceUpdate];    
    
    //2.prepare data
    NSString * lpResponseData = [LYGlobalSettings GetSettingString:SETTING_KEY_SERVER_LOGININFO];
    self.m_oLoginData = [LYGlobalSettings GetJsonValue: lpResponseData];
    
    BOOL lbParseSucceed = [self ParseSymbolData:self.m_oLoginData];
    self.m_bSymbolSucceed = lbParseSucceed;
    
    //3.parse TransAction
    self.m_nTransactionDirection = [self ParseTransaction:self.m_oLoginData];
    
    if (self.m_nTransactionDirection == (TRANS_NONE_TRANS))
    {
        if (!lbParseSucceed)
        {
            self.m_oImgDown.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_gray" ofType:@"png"]];
            self.m_oImgUp.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_gray" ofType:@"png"]];
            
        }else
        {
            self.m_oImgDown.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down" ofType:@"png"]];
            self.m_oImgUp.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up" ofType:@"png"]];
        }
        
    }else if (self.m_nTransactionDirection == (TRANS_BET_DOWN))
    {
        
        if (!lbParseSucceed)
        {
            self.m_oImgDown.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_gray" ofType:@"png"]];
            self.m_oImgUp.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_gray" ofType:@"png"]];
            
        }else
        {
            self.m_oImgDown.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_selected" ofType:@"png"]];
            self.m_oImgUp.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_gray" ofType:@"png"]];
        }
    }else
    {
        if (!lbParseSucceed)
        {
            self.m_oImgDown.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_gray" ofType:@"png"]];
            self.m_oImgUp.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_gray" ofType:@"png"]];
            
        }else
        {
            self.m_oImgDown.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_gray" ofType:@"png"]];
            self.m_oImgUp.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"up_selected" ofType:@"png"]];
        }
    }



    lbParseSucceed =  [self ParseUserData:self.m_oLoginData];

    
    self.m_oLblCountdown.text = [[NSString alloc] initWithFormat:@"%@",self.m_strTimeCountDown];
    self.m_oSymbol_Price.text = [[NSString alloc] initWithFormat:@"%.2f",self.m_dbl_Symbol_price];
    self.m_oSymbolTitle.text = [[NSString alloc] initWithFormat:@"%@",self.m_strSymbolTitle];
    self.m_oUserName.text =[[NSString alloc] initWithFormat:@"%@",self.m_strUserName];
    self.m_oUserMail.text =[[NSString alloc] initWithFormat:@"%@",self.m_strUserMail];

}

- (UIImage *) convertToGreyscale:(UIImage *)i {
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen | kBlue | kRed;
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultUIImage;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
