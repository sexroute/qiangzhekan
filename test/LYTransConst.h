//
//  LY.h
//  finger
//
//  Created by zhao on 14-4-13.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYTransConst : NSObject
{
    enum TransStatus
    {
        STATUS_TRANS_ADD_PENDING = 0,
        STATUS_TRANS_RUNNING = 1,
        STATUS_TRANS_TRANS_CLOSE = 2,
        STATUS_TRANS_FAILED = 3,
        STATUS_TRANS_TRANS_CANCEL = 4,
        STATUS_TRANS_CANCEL_PENDING = 5,
        STATUS_TRANS_CLOSE_PENDING = 6,
    };
   
}
 +(NSString *)GetTransStatusReason:(int)anTransStatusCode;
@end
