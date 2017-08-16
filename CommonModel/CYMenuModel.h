//
//  dishesModel.h
//  CYOrder
//
//  Created by ymw on 17/3/31.
//  Copyright © 2017年 ymw. All rights reserved.
//
//菜单表
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CYMenuModel : NSObject
/**
 *  菜品id
 */
@property (nonatomic,copy) NSString *food_id;
/**
 *  菜名
 */
@property (nonatomic,copy) NSString *name;
/**
 *  价格
 */
@property (nonatomic,assign) CGFloat price;
/**
 *  菜系
 */
@property (nonatomic,copy) NSString *category_id;

/**
 *  特价价格
 */
@property (nonatomic,assign) CGFloat discount_price;
/**
 *  简介
 */
@property (nonatomic,copy) NSString *brief;

/**
 *  是否可点
 */
@property (nonatomic,assign) BOOL is_enable;

/**
 *  图片地址
 */
@property (nonatomic,copy) NSString *img_address;

/**
 *  创建时间
 */
@property (nonatomic,copy) NSString *create_time;



@property (nonatomic,assign) BOOL is_special;


@property (nonatomic,assign) CGFloat good_precent;

/**
 是否是评价
 */
@property (nonatomic,assign) BOOL is_Eva;
@end
