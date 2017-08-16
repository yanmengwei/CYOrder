//
//  CYFirmOrderViewController.h
//  CYOrder
//
//  Created by ymw on 17/4/19.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "BasePopViewController.h"

@interface CYFirmOrderViewController : BasePopViewController
//单点订单
@property (nonatomic,strong) NSArray *orderArr;
//套餐
@property (nonatomic,strong) NSArray *packageArr;


@property (nonatomic,strong) CYOrderModel *orderModel;
@end
