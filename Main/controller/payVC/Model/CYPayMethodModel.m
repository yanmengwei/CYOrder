//
//  CYPayMethodModel.m
//  CYOrder
//
//  Created by ymw on 17/4/27.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYPayMethodModel.h"

@implementation CYPayMethodModel
+(NSArray *)getMethods{
    CYPayMethodModel *vip = [[CYPayMethodModel alloc]init];
    vip.name = @"会员卡";
    vip.imageName = @"pay_vip";
    
    CYPayMethodModel *ali = [[CYPayMethodModel alloc]init];
    ali.name = @"支付宝";
    ali.imageName = @"pay_alipay";
    
    CYPayMethodModel *wechat = [[CYPayMethodModel alloc]init];
    wechat.name = @"会员卡";
    wechat.imageName = @"pay_wechat";

    return [NSArray arrayWithObjects:vip,ali,wechat, nil];
}
@end
