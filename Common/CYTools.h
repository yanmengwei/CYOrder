//
//  CYTools.h
//  CYOrder
//
//  Created by ymw on 17/4/26.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CYOrderListModel;
@interface CYTools : NSObject
/**
 *  根据菜单数组获得总价
 *
 *  @param menuArr <#menuArr description#>
 *
 *  @return <#return value description#>
 */
+ (CGFloat)countWithArr:(NSArray *)menuArr;
/**
 *  根据订单详情数组获得总价
 *
 *  @param orderListArr <#orderListArr description#>
 *
 *  @return <#return value description#>
 */

+ (CGFloat)countWithListArr:(NSArray <CYOrderModel *> *)orderListArr;


/**
 根据订单数组计算总价

 @param orderArr <#orderArr description#>
 @return <#return value description#>
 */
+ (CGFloat)countWithOrderArr:(NSArray *)orderArr;

/**
 根据订单计算订单总价

 @param orderModel <#orderModel description#>
 @return <#return value description#>
 */
+ (CGFloat )countWithOrderModel:(CYOrderModel *)orderModel;
@end
