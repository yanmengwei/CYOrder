//
//  dishesModel.m
//  CYOrder
//
//  Created by ymw on 17/3/31.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYMenuModel.h"

@implementation CYMenuModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"food_id":@"id"};
}
- (void)setImg_address:(NSString *)img_address{
    if ([img_address containsString:@"http"]) {
        _img_address = img_address;
    }else{
        NSMutableString *str = [NSMutableString stringWithString:@"http://192.168.68.236/"];
        [str appendString:img_address];
        _img_address = str;
    }
}
@end
