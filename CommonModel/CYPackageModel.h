//
//  CYPackageModel.h
//  CYOrder
//
//  Created by ymw on 17/4/17.
//  Copyright © 2017年 ymw. All rights reserved.
//
/**
 *  套餐表
 */
#import <Foundation/Foundation.h>

@interface CYPackageModel : NSObject
/**
 *  套餐id
 */
@property (nonatomic,copy) NSString *package_id;
/**
 *  套餐名
 */
@property (nonatomic,copy) NSString *name;
/**
 *  适合人数
 */
@property (nonatomic,assign) NSInteger suggest_persons;
/**
 *  总价
 */
@property (nonatomic,assign) CGFloat price;

/**
 *  套餐详情
 */
@property (nonatomic,strong) NSArray *packageLists;




@end
