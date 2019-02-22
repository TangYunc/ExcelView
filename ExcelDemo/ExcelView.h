//
//  ExcelView.h
//  ExcelDemo
//
//  Created by tangyunchuan on 2019/2/21.
//  Copyright © 2019 tangyunchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define IF_T_FF(s,r,section,row) if(r == row && s == section)
#define EF_T_FF(s,r,section,row) else if(r == row && s == section)
#define IF_FF(x,m) if(x == m)
#define EF_FF(x,m) else if(x == m)


@class ExcelView;

@protocol ExcelViewDelegate
@optional
////表单行数
- (NSInteger)rowForList:(ExcelView*)list;
////表单列数
- (NSInteger)columnForList:(ExcelView*)list;
////表单显示范围
- (CGRect)boundsForList:(ExcelView*)list;
////表单某一格的边框颜色
- (UIColor*)listChart:(ExcelView*)list borderColorForRow:(NSInteger)row column:(NSInteger)column;
/////表单某一行的背景颜色
- (UIColor*)listChart:(ExcelView*)list backgroundColorForRow:(NSInteger)row column:(NSInteger)column;
/////表单某一格的大小
- (CGSize)listChart:(ExcelView*)list itemSizeForRow:(NSInteger)row column:(NSInteger)column;
/////表单某一格字体的大小
- (UIFont*)listChart:(ExcelView*)list fontForRow:(NSInteger)row column:(NSInteger)column;
/////表单某一格字体的颜色
- (UIColor*)listChart:(ExcelView*)list textColorForRow:(NSInteger)row column:(NSInteger)column;
/////表单某一格的文字
- (NSString*)listChart:(ExcelView*)list textForRow:(NSInteger)row column:(NSInteger)column;
////点击触发事件
-(void)listChart:(ExcelView*)list clickForRow:(NSInteger)row column:(NSInteger)column;

@end
#define DelegateResponds(selector) (self.delegate != nil && [(NSObject*)self.delegate respondsToSelector:selector])

@interface ExcelView : UIView

@property(nonatomic,strong)UIColor *listBackgroundColor;
@property(nonatomic,strong)UIColor *borderColor;
@property(nonatomic,assign)CGFloat borderWidth;
@property(nonatomic,assign)CGFloat cornerRadius;
@property(nonatomic,strong)UIFont *textFont;
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,assign)NSTextAlignment alignment;
@property(nonatomic,assign)id<ExcelViewDelegate> delegate;

-(CGSize)itemDefaultSize;
-(void)reloadData;

@end

NS_ASSUME_NONNULL_END
