//
//  EvaluateRestaurantView.h
//  CYOrder
//
//  Created by ymw on 17/6/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYRestuarantEvaluateModel;
@protocol EvaluateRestaurantViewDelegate <NSObject>
- (void)didChangeResEvaWithModel:(CYRestuarantEvaluateModel *)resModel;
@end
@interface EvaluateRestaurantView : UIView
@property (nonatomic,weak) id<EvaluateRestaurantViewDelegate>delegate;

@end
