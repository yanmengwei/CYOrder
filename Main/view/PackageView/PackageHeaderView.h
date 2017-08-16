//
//  PackageHeaderView.h
//  CYOrder
//
//  Created by ymw on 17/6/1.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PackageHeaderViewDelegate <NSObject>

- (void)headerViewSelectIndex:(NSInteger)index;

@end

@interface PackageHeaderView : UIView

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic,weak)id<PackageHeaderViewDelegate> delegate;

@property (nonatomic,strong) NSArray *titleArr;
@end
