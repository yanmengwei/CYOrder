//
//  CYPackageListModel.m
//  CYOrder
//
//  Created by ymw on 17/4/17.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYPackageListModel.h"

@implementation CYPackageListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"package_list_id":@"id"};
}
@end
