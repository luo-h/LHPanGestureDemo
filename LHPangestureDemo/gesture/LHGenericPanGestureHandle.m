//
//  LHGenericPanGestureHandle.m
//  PanGestureDemo
//
//  Created by 罗浩 on 2019/11/12.
//  Copyright © 2019 listen. All rights reserved.
//

#import "LHGenericPanGestureHandle.h"
#import "UIView+Extension.h"
@interface LHGenericPanGestureHandle ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topGuideView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign)CGFloat    minY;
@property (nonatomic, assign)CGFloat    maxY;
@property (nonatomic, assign)CGFloat    containerWidth,containerHeight;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation LHGenericPanGestureHandle

- (instancetype)initWithContainerView:(UIView *)containerView TableView:(UITableView *)tableView MinY:(CGFloat)minY MaxY:(CGFloat)maxY{
    self = [super init];
    if (self) {
        //tableView.delegate = self;
        self.tableView = tableView;
        self.minY = minY;
        self.maxY = maxY;
        
        self.containerWidth = CGRectGetWidth(containerView.frame);
        self.containerHeight = CGRectGetHeight(containerView.frame);
        
        [self initUIWithContainerView:containerView];
        [self.contentView addGestureRecognizer:self.panGestureRecognizer];
    }
    return self;
}


- (void)initUIWithContainerView:(UIView  *)containerView{
    self.bgView.frame = CGRectMake(0, 0, self.containerWidth, self.maxY);
    [containerView addSubview:self.bgView];
    
    
    self.contentView.frame = CGRectMake(0, self.maxY, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame) - self.minY);
    [containerView addSubview:self.contentView];
    
    self.tableView.frame = CGRectMake(0, CGRectGetHeight(self.topGuideView.frame), self.containerWidth, CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.topGuideView.frame));
    [self.contentView addSubview:self.topGuideView];
    [self.contentView addSubview:self.tableView];
}
#pragma mark -pan
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //手向上滑
    if (scrollView.contentOffset.y>0) {
        self.panGestureRecognizer.enabled = NO;
        scrollView.scrollEnabled = YES;
    }else{
        self.panGestureRecognizer.enabled = YES;
        //scrollView.scrollEnabled = NO;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

- (void)didPanOnView:(UIPanGestureRecognizer *)panGestureRecognizer{
    if (!panGestureRecognizer.enabled) {
        return;
    }
    //手指在视图上的位置（x,y）就是手指在视图本身坐标系的位置。
    //CGPoint location = [panGestureRecognizer locationInView:panGestureRecognizer.view.superview];
    //手指在视图上移动的位置（x,y）向下和向右为正，向上和向左为负
    
    //滑动速度  .y<0 手向上滑    >0 手向下滑
    CGPoint velocity = [panGestureRecognizer velocityInView:self.contentView];
    NSLog(@"sudu:%.2f",velocity.y);
    
    CGPoint translation = [panGestureRecognizer translationInView:self.contentView];
    
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"FlyElephant---视图拖动开始");
        //如果要contentVIew和tableView一起滑动可以设置为YES
        if (self.contentView.y <= self.minY &&
            velocity.y <= 0) {
            self.tableView.scrollEnabled = YES;
            return;
        }else{
            self.tableView.scrollEnabled = NO;
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.contentView.y += translation.y;
        [panGestureRecognizer setTranslation:CGPointZero inView:self.contentView];
        
        CGFloat alpha = 0;
        alpha = (self.maxY - self.contentView.y)/(self.maxY+50);
        alpha = alpha>.5?.5:alpha;
        self.bgView.hidden = NO;
        if (self.contentView.y < self.minY) {
            self.contentView.y = self.minY;
        }
        if (self.contentView.y > self.maxY) {
            self.contentView.y = self.maxY;
        }
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"FlyElephant---视图拖动结束");
        NSLog(@"速度:%.2f",velocity.y);
        
        panGestureRecognizer.enabled = YES;
        self.tableView.scrollEnabled = YES;
        if (self.contentView.y < (self.maxY - self.minY)*0.5 + self.minY) {
            [UIView animateWithDuration:.3 animations:^{
                self.contentView.y = self.minY;
            }];
        }else{
            [UIView animateWithDuration:.3 animations:^{
                self.contentView.y = self.maxY;
                self.bgView.hidden = YES;
            }];
        }
    }
}
#pragma mark -setter
- (void)setOrShowCorners:(BOOL)orShowCorners{
    if (!orShowCorners) {
        return;
    }
    [self setCornersValue:10];
}
- (void)setCornersValue:(float)cornersValue{
    if (cornersValue <= 0) {
        return;
    }
    UIBezierPath *bgViewmaskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners: UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(cornersValue, cornersValue)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bgViewmaskPath.bounds;
    maskLayer.path = bgViewmaskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
    self.contentView.clipsToBounds = YES;
}
- (void)setHeight:(CGFloat)height{
    _height = height;
    _containerHeight = height;
    
    CGRect rect = self.contentView.frame;
    rect.size.height = _containerHeight - self.minY;
    self.contentView.frame = rect;
    
    CGRect tableViewRect = self.tableView.frame;
    tableViewRect.size.height = CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.topGuideView.frame);
    self.tableView.frame = tableViewRect;
}
#pragma mark -lazy
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _bgView.hidden = YES;
    }
    return _bgView;
}
- (UIView *)topGuideView{
    if (!_topGuideView) {
        _topGuideView = [UIView new];
        _topGuideView.userInteractionEnabled = YES;
        _topGuideView.backgroundColor = [UIColor whiteColor];
        _topGuideView.frame = CGRectMake(0, 0, self.containerWidth, 24);
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor grayColor];
        [_topGuideView addSubview:lineView];
        lineView.centerY = _topGuideView.centerY;
        lineView.centerX = _topGuideView.centerX;
        lineView.bounds = CGRectMake(0, 0, 28, 4);
        lineView.layer.cornerRadius = 2;
        lineView.layer.masksToBounds = YES;
    }
    return _topGuideView;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanOnView:)];
        _panGestureRecognizer.minimumNumberOfTouches = 1;
        _panGestureRecognizer.maximumNumberOfTouches = 1;
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}

@end
