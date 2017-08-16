//
//  DataBase.h
//  CYOrder
//
//  Created by ymw on 17/3/31.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  CYOrderListModel;
@class  CYOrderModel;
@class CYPackageModel;
@class CYRestuarantEvaluateModel;

@interface DataBase : NSObject
+(instancetype)shareDataBase;
/**
 *  更新数据库
 */
- (void)updateDataBase;

- (void)applicationWillTerminate;

/**
 *  更新菜系
 */
- (void)updateCategoryCommpelete:(void(^)(BOOL result))complete;
/**
 *  更新菜单
 */
- (void)updataAllFood:(void(^)(BOOL result))complete;
/**
 *  获取所有的菜系
 *
 *  @return 菜系数组
 */
- (NSMutableArray *)getAllCategory;

/**
 *  根据菜系id获取菜单表
 *
 *  @param categoryId 菜系id
 *
 *  @return 菜单数组
 */
- (NSMutableArray *)getMenusWithCategryId:(NSString *)categoryId;

/**
 根据套餐id获取套餐详情

 @param packageId
 @return <#return value description#>
 */
- (CYPackageModel *)getPackageWithPackageId:(NSString *)packageId;

/**         
 *  获取所有的套餐
 *
 *  @return
 */
- (NSMutableArray *)getAllPackage;

/**
 *  根据套餐id获取套餐里的菜品
 *
 *  @param packageId 套餐id
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)getPackageListWithPackageId:(NSString *)packageId;

/**
 *  添加订单
 *
 *  @param orderModel 订单模型
 *  @param listArr    订单详情模型数组
 *  return  返回值  yes 插入数据成功  否则失败
 */
- (BOOL)insertOrder:(CYOrderModel *)orderModel;

/**
 *  订单列表
 *
 *  @return 返回的是所有未付款的订单数组 订单中包含订单详情
 */
- (NSArray *)getOrderList;

/**
 *  根据菜id获取详情
 *
 *  @param menu_id
 *
 *  @return
 */
- (CYMenuModel *)getMenuWithMenuId:(NSString *)menu_id;

/**
 *  评价
 *
 *  @param orderArr 订单数组
 *
 *  @return YES/NO
 */
- (BOOL)completeCommentWithOrder:(NSArray *)orderListArr;

/**
 评价餐厅

 @param resModel 餐厅model
 @return <#return value description#>
 */
- (BOOL)evaluateRestuarantWithResModel:(CYRestuarantEvaluateModel *)resModel;

/**
 支付

 @return <#return value description#>
 */
- (BOOL)pay;
@end
