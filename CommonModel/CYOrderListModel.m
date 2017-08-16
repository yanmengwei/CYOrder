//
//  CYOrderListModel.m
//  CYOrder
//
//  Created by ymw on 17/4/26.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYOrderListModel.h"

@implementation CYOrderListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}
+ (NSMutableArray *)orderListArrWithMenuArr:(NSArray<CYMenuModel *>*)menuModelArr{
    NSMutableArray *orderArr = [NSMutableArray array];
    for (CYMenuModel *menuModel in menuModelArr) {
        CYOrderListModel *order = [[CYOrderListModel alloc]init];
        order.menu_id = menuModel.food_id;
        order.menuModel = menuModel;
        [orderArr addObject:order];
    }
    return orderArr;
}
+ (CYOrderListModel *)orderListModelWithMenuArr:(CYMenuModel *)menuModel{
    CYOrderListModel *order = [[CYOrderListModel alloc]init];
    order.menu_id = menuModel.food_id;
    order.menuModel = menuModel;
    return order;
}
+ (CYOrderListModel *)orderListModelWithPack:(CYPackageModel *)packModel{
    CYOrderListModel *order = [[CYOrderListModel alloc]init];
    order.package_id = packModel.package_id;
    order.packageModel = packModel;
    return order;
}
@end
