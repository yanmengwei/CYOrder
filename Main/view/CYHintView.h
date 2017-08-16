//
//  CYHintView.h
//  CYOrder
//
//  Created by ymw on 17/4/28.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYHintView;
@protocol CYHintViewDelegate<NSObject>
- (void)hintView:(CYHintView *)hintview didSelcetBtnAtIndex:(NSInteger)index;
@end
@interface CYHintView : UIView
@property (nonatomic,weak) id<CYHintViewDelegate>delegate;
- (instancetype)initWithTitles:(NSString *)title buttonArr:(NSArray *)btnArr;
- (void)show;

@end
