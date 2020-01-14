//
//  ViewController.m
//  LHPangestureDemo
//
//  Created by 罗浩 on 2019/11/26.
//  Copyright © 2019 listen. All rights reserved.
//

#import "ViewController.h"
#import "LHGenericPanGestureHandle.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) LHGenericPanGestureHandle *handle;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"点我，疯狂点我" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor greenColor]];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(80, 50, 150, 80);
        [self.view addSubview:button];
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate =self;
        tableView.dataSource = self;
        tableView.rowHeight = 50;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        
        LHGenericPanGestureHandle *handle = [[LHGenericPanGestureHandle alloc]initWithContainerView:self.view TableView:tableView MinY:80 MaxY:420];
        handle.orShowCorners = YES;
        handle.cornersValue = 5;
        _handle = handle;
    }

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_handle scrollViewDidScroll:scrollView];
}

- (void)btnClick:(UIButton *)button{
    CGFloat color = arc4random()%255;
    [button setTitleColor:[UIColor colorWithRed:color/255 green:color/255 blue:color/255 alpha:1] forState:UIControlStateNormal];
    NSLog(@"111");
}
#pragma mark -delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @"😘😘😘";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

