//
//  PackageView.h
//  CYOrder
//
//  Created by ymw on 17/6/1.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PackageViewDelegate<NSObject>
//点击了单元格
- (void)didSeleceCellWithModel:(CYMenuModel *)model;
//点击了一键加入
- (void)didSelectAddBtn:(CYPackageModel *)packageModel;

@end


@interface PackageView : UIView
@property (nonatomic,strong) NSArray *packageModelArr;
@property (nonatomic,weak) id<PackageViewDelegate> delegate;
@end
