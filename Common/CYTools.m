//
//  CYTools.m
//  CYOrder
//
//  Created by ymw on 17/4/26.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYTools.h"

@implementation CYTools

+(CGFloat)countWithArr:(NSArray *)menuArr{
    CGFloat count = 0.0;
    if (menuArr.count == 0) {
        return 0;
    }
    if ([menuArr[0] isKindOfClass:[CYMenuModel class]]) {
        for (CYMenuModel *menuModel in menuArr) {
            if (menuModel.discount_price > 0) {
//                count = count + menuModel.count * menuModel.discount_price;
                
            }else{
//                count = menuModel.count *menuModel.price + count;
            }
        }
    }
    if ([menuArr[0]isKindOfClass:[CYOrderListModel class]]) {
        //单点
        for (CYOrderListModel *orderListModel in menuArr) {
            
            if (orderListModel.menuModel.is_special > 0) {
                //特价
                count = count + orderListModel.count * orderListModel.menuModel.discount_price;
            }else{
                count = orderListModel.count * orderListModel.menuModel.price + count;
            }
        }
        //套餐
//        for (CYOrderListModel *orderListModel in ) {
//            <#statements#>
//        }
    }
    return count;

}

+ (CGFloat)countWithListArr:(NSArray <CYOrderModel *> *)orderListArr{
    CGFloat count = 0.0;
    if (orderListArr.count == 0) {
        return 0.f;
    }
    for (CYOrderModel *order in orderListArr) {
        
        count = count + order.total;
    }
    return count;
}
+ (CGFloat)countWithOrderArr:(NSArray *)orderArr{
    CGFloat price = 0.0;
    for (CYOrderModel *orderModel in orderArr) {
        price = price + [self countWithOrderModel:orderModel];
    }
    return price;
}
+ (CGFloat )countWithOrderModel:(CYOrderModel *)orderModel{
    CGFloat price = 0.f;
    for (CYOrderListModel *orderListModel in orderModel.orderListModelArr) {
        if (orderListModel.menuModel.is_special) {
            price = price + orderListModel.menuModel.discount_price * orderListModel.count;
        }else{
            price = price + orderListModel.menuModel.price * orderListModel.count;
        }
    }
    for (CYOrderListModel *packageOrderModel in orderModel.packageArr) {
        price = price + packageOrderModel.packageModel.price + packageOrderModel.count;
    }
    return price;
}
@end
