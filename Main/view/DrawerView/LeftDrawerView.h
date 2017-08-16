//
//  LeftDrawerView.h
//  CYOrder
//
//  Created by ymw on 17/4/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

//服务悬浮窗 直接悬浮在窗口上

#import <UIKit/UIKit.h>
@class LeftDrawerView;
@protocol LeftDrawerViewDelegate<NSObject>
- (void)leftDrawerView:(LeftDrawerView *)leftView didSelectAtIndex:(NSInteger)index;
@end
@interface LeftDrawerView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) id<LeftDrawerViewDelegate>delegate;
-(instancetype)initLeftViewWithTitles:(NSArray *)titles;
@end
