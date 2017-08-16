//
//  CYPackageModel.m
//  CYOrder
//
//  Created by ymw on 17/4/17.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYPackageModel.h"

@implementation CYPackageModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"package_id":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"packageLists": @"CYPackageListModel"};
}

@end
