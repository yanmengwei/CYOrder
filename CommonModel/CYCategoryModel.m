//
//  CYCategory.m
//  CYOrder
//
//  Created by ymw on 17/4/5.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYCategoryModel.h"

@implementation CYCategoryModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"category_id":@"id"};
}
@end
