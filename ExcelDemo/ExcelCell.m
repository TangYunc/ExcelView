//
//  ExcelCell.m
//  ExcelDemo
//
//  Created by tangyunchuan on 2019/2/22.
//  Copyright © 2019 tangyunchuan. All rights reserved.
//

#import "ExcelCell.h"
#import "ExcelView.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface ExcelCell ()<ExcelViewDelegate>
{
    ExcelView *_excelView;
}
@end

@implementation ExcelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:(arc4random()%200 + 55)/225.0f green:(arc4random()%200 + 55)/225.0f blue:(arc4random()%200 + 55)/225.0f alpha:1.0f];
        self.backgroundView = nil;
        //初始化子视图
        [self initSubviews];
    }
    return self;
}


//初始化子视图
- (void)initSubviews{
    CGFloat height = 4 * ((kScreenWidth - 30) / 8);
    _excelView = [[ExcelView alloc]initWithFrame:CGRectMake(15 , 0, kScreenWidth - 30, height)];
    [_excelView setBorderWidth:1.0f];
    [_excelView setDelegate:self];
//    [_excelView reloadData];
    [self.contentView addSubview:_excelView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
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

@end
