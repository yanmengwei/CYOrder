//
//  CY_Size_header.h
//  CYOrder
//
//  Created by ymw on 17/4/1.
//  Copyright © 2017年 ymw. All rights reserved.
//

#ifndef CY_Size_header_h
#define CY_Size_header_h
#define Main_Screen_Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define Main_Screen_Height CGRectGetHeight([UIScreen mainScreen].bounds)
/**
 *  默认字体
 *
 *  @return <#return value description#>
 */
#define CYDefaultTextFont(f) [UIFont fontWithName:@"STHeitiSC-Medium" size:f]
/**
 *  棕色边框
 *
 *  @return <#return value description#>
 */
#define CYBrownBorderColor [UIColor colorWithRed:180/255.0 green:99/255.0 blue:59/255.0 alpha:1]
/**
 *  字体颜色
 *
 *  @return <#return value description#>
 */
#define CYTextColor [UIColor colorWithRed:72/255.0 green:22/255.0 blue:13/255.0 alpha:1]
#endif /* CY_Size_header_h */
