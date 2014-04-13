//
//  LY.m
//  finger
//
//  Created by zhao on 14-4-13.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "LYTransConst.h"

@implementation LYTransConst
+(NSString *)GetTransStatusReason:(int)anTransStatusCode
{
    
    switch (anTransStatusCode)
    {
        case STATUS_TRANS_ADD_PENDING :
            return @"新增交易待处理"  ;
           break;
        case STATUS_TRANS_RUNNING :
            return @"交易进行中";
            break;
        case STATUS_TRANS_TRANS_CLOSE :
            return @"交易结束";
            break;
        case STATUS_TRANS_FAILED :
            return @"交易失败";
            break;
        case STATUS_TRANS_TRANS_CANCEL :
            return @"交易取消";
            break;
        case STATUS_TRANS_CANCEL_PENDING :
            return @"交易取消待处理";
            break;
        case STATUS_TRANS_CLOSE_PENDING :
            return @"交易关闭待处理";
            break;
        default:
            return @"未知状态";
            break;
    }
}
@end
