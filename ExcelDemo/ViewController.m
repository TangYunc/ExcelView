//
//  ViewController.m
//  ExcelDemo
//
//  Created by tangyunchuan on 2019/2/21.
//  Copyright © 2019 tangyunchuan. All rights reserved.
//

#import "ViewController.h"
#import "ExcelView.h"
#import "ExcelTabelView.h"

@interface ViewController ()<ExcelViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollView;  // 滑动视图
    UIPageControl *_pageControl;// 页码控件
}

@property (nonatomic)CGFloat width;
@property (nonatomic, strong)ExcelTabelView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self demo1];
//    [self demo2];
    [self demo3];
    
}

- (void)demo3{
    //左右滑，需要设置tableview的宽高
    self.width = self.view.frame.size.width - 30;
    CGFloat height = 4 * (self.width / 8);
    self.tableView.frame = CGRectMake(100, 100, height, self.view.frame.size.width);
    [self.view addSubview:self.tableView];
    [self.tableView setTransform:CGAffineTransformMakeRotation(-M_PI/2)];
    [self.tableView setPagingEnabled:YES];//按整页翻动
    self.tableView.isVertical = YES;
}

- (void)demo2{
    //上下滑
    [self.view addSubview:self.tableView];
}

- (void)demo1{
    [self setupSubviews];
}


-(ExcelTabelView *)tableView
{
    if (!_tableView) {
        self.width = self.view.frame.size.width - 30;
        CGFloat height = 4 * (self.width / 8);
        _tableView = [[ExcelTabelView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, height) style:UITableViewStylePlain];
        
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}


- (void)setupSubviews{
    self.width = self.view.frame.size.width - 30;
    CGFloat height = 4 * (self.width / 8);
    
    
    
    // 1.创建滑动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, height)];
    // 2.设置滑动视图的子视图
    // 设置滑动视图内容视图的大小
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 16, height);
    // 循环创建所有的子视图
    for (int i = 0 ; i < 16; i++) {
        ExcelView *excelView = [[ExcelView alloc]initWithFrame:CGRectMake((i + 1) * 15 + i * (self.width + 15), 0, self.width, height)];
        [excelView setBorderWidth:1.0f];
        [excelView setDelegate:self];
        [excelView reloadData];
        [_scrollView addSubview:excelView];
    }
    // 3.设置滑动视图的属性
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    // 4.设置代理对象
    _scrollView.delegate = self;
    // 添加到视图上
    [self.view addSubview:_scrollView];
    
    // 5.创建页码控件
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 200 + height + 20, self.view.frame.size.width, 20)];
    // 设置页码控制的页数
    _pageControl.numberOfPages = 16;
    // 设置样式
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor greenColor];
    
    [self.view addSubview:_pageControl];
}

-(NSInteger)rowForList:(ExcelView *)list
{
    return 4;
}
-(NSInteger)columnForList:(ExcelView *)list
{
    return 8;
}

-(UIColor*)listChart:(ExcelView *)list textColorForRow:(NSInteger)row column:(NSInteger)column
{
    if (column == (row + 1))
    {
        return [UIColor redColor];
    }
    return nil;
}

//-(CGSize)listChart:(ExcelView *)list itemSizeForRow:(NSInteger)row column:(NSInteger)column
//{
//    return CGSizeMake(100.0f, 60.0f);
//}

-(NSString*)listChart:(ExcelView *)list textForRow:(NSInteger)row column:(NSInteger)column
{
    if (row == 0)
    {
        IF_T_FF(row, column, 0, 0){return @"";}
        EF_T_FF(row, column, 0, 1){return @"周一\n12-31";}
        EF_T_FF(row, column, 0, 2){return @"周二\n1-1";}
        EF_T_FF(row, column, 0, 3){return @"周三\n1-2";}
        EF_T_FF(row, column, 0, 4){return @"周四\n1-3";}
        EF_T_FF(row, column, 0, 5){return @"周五\n1-4";}
        EF_T_FF(row, column, 0, 6){return @"周六\n1-5";}
        EF_T_FF(row, column, 0, 7){return @"周日\n1-6";}
    }
    else if (column == 0)
    {
        IF_T_FF(row, column, 1, 0){return @"上午";}
        EF_T_FF(row, column, 2, 0){return @"下午";}
        EF_T_FF(row, column, 3, 0){return @"晚上";}
    }
    return [NSString stringWithFormat:@"%@",@"专家预约"];
}
-(UIColor*)listChart:(ExcelView *)list backgroundColorForRow:(NSInteger)row column:(NSInteger)column
{
    if (row == 0 || column == 0)
    {
        return [UIColor colorWithRed:(arc4random()%200 + 55)/225.0f green:(arc4random()%200 + 55)/225.0f blue:(arc4random()%200 + 55)/225.0f alpha:1.0f];
    }
    return nil;
}

- (void)listChart:(ExcelView *)list clickForRow:(NSInteger)row column:(NSInteger)column{
    NSLog(@"%ld---%ld",(long)row,(long)column);
}

#pragma mark - UIScrollViewDelegate
// 滑动视图滑动的时候调用的方法，时时调用用的
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前内容视图的位置
    NSLog(@"x:%f",scrollView.contentOffset.x);
}

// 手指离开滑动视图的时候调用的协议方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // decelerate:  时候有减速效果
    NSLog(@"手指离开滑动视图，当前减速效果:%d",decelerate);
    if (decelerate == NO) {
        // 视图停止滑动的时候执行一些操作
        [self scrollDidSroll];
    }
}

// 减速结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"停止减速，滑动视图停止了");
    
    // 视图停止滑动的时候执行一些操作
    [self scrollDidSroll];
}

// 当前滑动视图停止滑动的时候执行一些操作
- (void)scrollDidSroll
{
    NSLog(@"滑动视图停止滑动的时候执行一些操作");
    // 获取当前滑动视图的页数
    int pageIndex = (int)_scrollView.contentOffset.x / self.view.frame.size.width;
    // 设置到页码上
    _pageControl.currentPage = pageIndex;
}





@end
