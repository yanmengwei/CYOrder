//
//  orderListView.h
//  CYOrder
//
//  Created by ymw on 17/4/5.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCell.h"
typedef NS_ENUM(NSInteger,CYOrderType){
    CYOrderTypeNormal = 0,//默认正常的
    CYOrderTypeAdd//已有下过的订单 可以加菜
};
@protocol OrderListViewDelegate<NSObject>
- (void)orderListViewDidClickSubmitBtnWithOrderModel:(CYOrderModel *)orderModel;
@end
@interface OrderListView : UIView
@property (nonatomic,weak) id<OrderListViewDelegate>delegate;
@property (nonatomic,assign) CYOrderType orderType;


/**
 *  已下的订单数组
 */
@property (nonatomic,strong) NSArray *orderArr;

/**
 *  往订单中添加食物
 *
 *  @param menuModel 
 */
- (void)addAFoodWithFoodModel:(CYMenuModel *)menuModel;
- (void)addPackageWithPackage:(CYPackageModel *)packageModel;
@end
