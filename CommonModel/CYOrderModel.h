//
//  CYOrderModel.h
//  CYOrder
//
//  Created by ymw on 17/4/26.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYOrderListModel.h"
@interface CYOrderModel : UIView
/**
 *  订单id
 */
@property (nonatomic,copy) NSString *Id;
/**
 *  订单号
 */
@property (nonatomic,copy) NSString *number;
/**
 *  服务员ID
 */
@property (nonatomic,copy) NSString *waiter_id;
/**
 *  总价
 */
@property (nonatomic,assign) CGFloat total;
/**
 *  折扣
 */
@property (nonatomic,assign) CGFloat discount;
/**
 *  实收价
 */
@property (nonatomic,assign) CGFloat paid;
/**
 *  支付状态
 */
@property (nonatomic,assign) BOOL pay_status;
/**
 *  支付方式
 */
@property (nonatomic,copy) NSString *pay_id;
/**
 *  支付时间
 */
@property (nonatomic,copy) NSString *pay_time;
/**
 *  备注
 */
@property (nonatomic,copy) NSString *remarks;
/**
 *  创建时间
 */
@property (nonatomic,copy) NSString *create_time;

/**
 *  订单中的数据详情
 */
@property (nonatomic,strong) NSMutableArray *orderListModelArr;

/**
 套餐详情
 */
@property (nonatomic,strong) NSMutableArray *packageArr;

/**
 *  是否评价过
 */
@property (nonatomic,assign) BOOL is_star;
@end
