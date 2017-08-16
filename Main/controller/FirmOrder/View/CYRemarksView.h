//
//  CYRemarksView.h
//  CYOrder
//
//  Created by ymw on 17/4/25.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CYRemarksViewDelegate <NSObject>
- (void)didChangeRemark:(NSArray *)arr;
@end
@interface CYRemarksView : UIView
@property (nonatomic,weak)id<CYRemarksViewDelegate>delegate;
@end
