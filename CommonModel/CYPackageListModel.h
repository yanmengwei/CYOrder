//
//  CYPackageListModel.h
//  CYOrder
//
//  Created by ymw on 17/4/17.
//  Copyright © 2017年 ymw. All rights reserved.
//
//套餐详情表
#import <Foundation/Foundation.h>

@interface CYPackageListModel : NSObject
/**
 *  套餐id
 */
@property (nonatomic,copy) NSString *package_list_id;
/**
 *  套餐id
 */
@property (nonatomic,copy) NSString *package_id;
/**
 *  菜id
 */
@property (nonatomic,copy) NSString *menu_id;
/**
 *  数量
 */
@property (nonatomic,assign) NSInteger count;
@end
