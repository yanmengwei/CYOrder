//
//  CYOrderListModel.h
//  CYOrder
//
//  Created by ymw on 17/4/26.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , MenuStatus)
{
    MenuStatusNone = 0,  //排队中
    MenuStatusMaking,  //制作中
    MenuStatusComplete,  //配送
};
typedef NS_ENUM(NSInteger , EvaluateStatus)
{
    EvaluateStatusCai = 0,  //踩
    EvaluateStatusZan,  //赞
};
@interface CYOrderListModel : UIView

/**
 *  订单详情id
 */
@property (nonatomic,copy) NSString *Id;
/**
 *  订单id
 */
@property (nonatomic,copy) NSString *order_id;
/**
 *  菜id
 */
@property (nonatomic,copy) NSString *menu_id;

@property (nonatomic,copy) NSString *package_id;
/**
 *  数量
 */
@property (nonatomic,assign)NSInteger count;
/**
 *  状态 
 0-排队中
 1-制作中
 2-配送中
 */
@property (nonatomic,assign) MenuStatus status;
/**
 *  上菜时间
 */
@property (nonatomic,copy)  NSString *serve_time;
/**
 *  开始制作时间
 */
@property (nonatomic,copy) NSString *start_process_time;
/**
 *  制作完成时间
 */
@property (nonatomic,copy) NSString *ready_time;
/**
 *  <#Description#>
 */
@property (nonatomic,copy) NSString *create_time;

/**
 *  评分
 */
@property (nonatomic,assign) EvaluateStatus evaluate;

@property (nonatomic,assign) BOOL is_evaluation;

//'is_evaluation',int,
//'evaluate',int,
@property (nonatomic,strong) CYMenuModel *menuModel;


@property (nonatomic,strong)CYPackageModel *packageModel;
+ (NSMutableArray *)orderListArrWithMenuArr:(NSArray<CYMenuModel *>*)menuModelArr;
+ (CYOrderListModel *)orderListModelWithMenuArr:(CYMenuModel *)menuModel;
+ (CYOrderListModel *)orderListModelWithPack:(CYPackageModel *)packModel;

@end
