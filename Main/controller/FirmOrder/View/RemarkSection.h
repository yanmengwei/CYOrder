//
//  RemarkSection.h
//  CYOrder
//
//  Created by ymw on 17/4/25.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RemarkSection;
@protocol RemarkSectionDelegate <NSObject>

- (void)remarkSection:(RemarkSection *)section didSelectBtnWithArr:(NSArray *)arr;

@end
@interface RemarkSection : UIView

@property (nonatomic,strong) NSArray *titles;
/**
 *  是否是单选
 */
@property (nonatomic,assign) BOOL isSingle;

@property (nonatomic,weak) id<RemarkSectionDelegate>delegate;


@end
