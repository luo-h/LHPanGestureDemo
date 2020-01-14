//
//  LHGenericPanGestureHandle.h
//  PanGestureDemo
//
//  Created by 罗浩 on 2019/11/12.
//  Copyright © 2019 listen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface LHGenericPanGestureHandle : NSObject

/// 默认不显示圆角    默认10
@property (nonatomic, assign) BOOL orShowCorners;
@property (nonatomic, assign) float cornersValue;

/// 容器高度    默认传入containerView的高度
@property (nonatomic, assign)CGFloat    height;

/// 初始化
/// @param containerView 容器，可以是self.view
/// @param tableView tableView
/// @param minY 顶部的y值
/// @param maxY 底部的y值
- (instancetype)initWithContainerView:(UIView *)containerView TableView:(UIScrollView *)tableView MinY:(CGFloat)minY MaxY:(CGFloat)maxY;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end

NS_ASSUME_NONNULL_END
