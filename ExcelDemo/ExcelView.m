//
//  ExcelView.m
//  ExcelDemo
//
//  Created by tangyunchuan on 2019/2/21.
//  Copyright © 2019 tangyunchuan. All rights reserved.
//

#import "ExcelView.h"

@interface FormItemCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *textContentLabel;
@property(nonatomic,strong)UIImageView *borderLeftLine;
@property(nonatomic,strong)UIImageView *borderTopLine;
@property(nonatomic,strong)UIImageView *borderRightLine;
@property(nonatomic,strong)UIImageView *borderBottomLine;

-(void)configurationContentText:(NSString*)content;
-(void)configurationBorder:(BOOL)haveLeft haveRight:(BOOL)haveRight haveTop:(BOOL)haveTop haveBottom:(BOOL)haveBottom lineWidth:(CGFloat)lineWidth borderColor:(UIColor*)borderColor itemSize:(CGSize)itemSize
;

@end

@interface MixFormContentSizeCollectionView : UICollectionView

-(void)resetContentSize;

@end

@interface MixFormContentSizeFlowLayout : UICollectionViewFlowLayout

@property(nonatomic,copy)NSInteger (^sectionCountBlock)(void);
@property(nonatomic,copy)NSInteger (^itemCountBlock)(NSInteger section);
@property(nonatomic,copy)CGSize (^itemSizeBlock)(NSIndexPath *indexPath);
@property(nonatomic,assign)CGRect oldBounds;
@property(nonatomic,strong)NSMutableArray *itemAttributesDataArray;

-(void)refreshLayoutAttributes;

@end


@interface ExcelView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)MixFormContentSizeCollectionView *formContentView;
@property(nonatomic,strong)MixFormContentSizeFlowLayout *formLayout;

@end

@implementation ExcelView

///单元格文字
- (NSString*)text:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:textForRow:column:)))
    {
        NSString *text = [self.delegate listChart:self textForRow:row column:column];
        if (text)
        {
            return text;
        }
        return @"";
    }
    return @"";
}
///单元格文字颜色
- (UIColor*)textColor:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:textColorForRow:column:)))
    {
        UIColor *color = [self.delegate listChart:self textColorForRow:row column:column];
        if (color)
        {
            return color;
        }
        return self.textColor;
    }
    return self.textColor;
}
////单元格文字字体
- (UIFont*)textFont:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:fontForRow:column:)))
    {
        UIFont *font = [self.delegate listChart:self fontForRow:row column:column];
        if (font)
        {
            return font;
        }
        return self.textFont;
    }
    return self.textFont;
}
///单元格文本位置
- (CGRect)textRect:(NSInteger)row column:(NSInteger)column
{
    return CGRectInset([self rect:row column:column], 2.5f, 2.5f);
}
///单元格背景色
- (UIColor*)color:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:backgroundColorForRow:column:)))
    {
        UIColor *color = [self.delegate listChart:self backgroundColorForRow:row column:column];
        if (color)
        {
            return color;
        }
        return self.listBackgroundColor;
    }
    return self.listBackgroundColor;
}
///表单范围
- (CGRect)itemsBounds
{
    CGRect listBounds = self.bounds;
    if (DelegateResponds(@selector(boundsForList:)))
    {
        listBounds = [self.delegate boundsForList:self];
    }
    return listBounds;
}
////单元格大小
- (CGSize)size:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:itemSizeForRow:column:)))
    {
        return [self.delegate listChart:self itemSizeForRow:row column:column];
    }
    return CGSizeMake([self itemsBounds].size.width/[self columns], [self itemsBounds].size.height/[self rows]);
}
///单元格位置
- (CGRect)rect:(NSInteger)row column:(NSInteger)column
{
    CGFloat x = [self itemsBounds].origin.x;
    CGFloat y = [self itemsBounds].origin.y;
    for (NSInteger i=0; i<row; i++)
    {
        y += [self size:i column:column].height;
    }
    for (NSInteger j=0; j<column; j++)
    {
        x += [self size:row column:j].width;
    }
    CGSize size = [self size:row column:column];
    return CGRectMake(x, y, size.width, size.height);
}
///单元格边框颜色
- (UIColor*)borderColor:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:borderColorForRow:column:)))
    {
        UIColor *color = [self.delegate listChart:self borderColorForRow:row column:column];
        if (color)
        {
            return color;
        }
        return self.borderColor;
    }
    return self.borderColor;
}
////总行数
- (NSInteger)rows
{
    NSInteger rows = 1;
    if (DelegateResponds(@selector(rowForList:)))
    {
        rows = [self.delegate rowForList:self];
    }
    return rows;
}
///总列数
- (NSInteger)columns
{
    NSInteger columns = 1;
    if (DelegateResponds(@selector(columnForList:)))
    {
        columns = [self.delegate columnForList:self];
    }
    return columns;
}
///是否绘制上边框
- (BOOL)borderForTop:(NSInteger)row column:(NSInteger)column
{
    NSInteger influenceRow = row - 1;
    NSInteger influenceColumn = column;
    if (influenceRow < 0 || influenceRow >= [self rows])
    {
        return YES;
    }
    if (influenceColumn < 0 || influenceColumn >= [self columns])
    {
        return YES;
    }
    if (DelegateResponds(@selector(listChart:borderColorForRow:column:)))
    {
        if ([self.delegate listChart:self borderColorForRow:row column:column])
        {
            return YES;
        }
        
        if ([self.delegate listChart:self borderColorForRow:influenceRow column:influenceColumn])
        {
            return NO;
        }
        
    }
    return NO;
}
///是否绘制下边框
- (BOOL)borderForBottom:(NSInteger)row column:(NSInteger)column
{
    NSInteger influenceRow = row + 1;
    NSInteger influenceColumn = column;
    if (influenceRow < 0 || influenceRow >= [self rows])
    {
        return YES;
    }
    if (influenceColumn < 0 || influenceColumn >= [self columns])
    {
        return YES;
    }
    
    if (DelegateResponds(@selector(listChart:borderColorForRow:column:)))
    {
        
        if ([self.delegate listChart:self borderColorForRow:influenceRow column:influenceColumn])
        {
            return NO;
        }
        
    }
    return YES;
}
///是否绘制左边框
- (BOOL)borderForLeft:(NSInteger)row column:(NSInteger)column
{
    NSInteger influenceRow = row;
    NSInteger influenceColumn = column - 1;
    if (influenceRow < 0 || influenceRow >= [self rows])
    {
        return YES;
    }
    if (influenceColumn < 0 || influenceColumn >= [self columns])
    {
        return YES;
    }
    
    if (DelegateResponds(@selector(listChart:borderColorForRow:column:)))
    {
        if ([self.delegate listChart:self borderColorForRow:row column:column])
        {
            return YES;
        }
        
        if ([self.delegate listChart:self borderColorForRow:influenceRow column:influenceColumn])
        {
            return NO;
        }
        
    }
    return NO;
}
//是否绘制右边框
- (BOOL)borderForRight:(NSInteger)row column:(NSInteger)column
{
    NSInteger influenceRow = row;
    NSInteger influenceColumn = column + 1;
    if (influenceRow < 0 || influenceRow >= [self rows])
    {
        return YES;
    }
    if (influenceColumn < 0 || influenceColumn >= [self columns])
    {
        return YES;
    }
    
    if (DelegateResponds(@selector(listChart:borderColorForRow:column:)))
    {
        
        if ([self.delegate listChart:self borderColorForRow:influenceRow column:influenceColumn])
        {
            return NO;
        }
    }
    return YES;
}

-(CGSize)itemDefaultSize
{
    return CGSizeMake([self itemsBounds].size.width*1.0f/[self columns], [self itemsBounds].size.height*1.0f/[self rows]);
}

-(void)runClickFunction:(NSInteger)row column:(NSInteger)column
{
    if (DelegateResponds(@selector(listChart:clickForRow:column:)))
    {
        [self.delegate listChart:self clickForRow:row column:column];
    }
}
-(UIColor *)listBackgroundColor
{
    if (!_listBackgroundColor)
    {
        return self.backgroundColor;
    }
    else
    {
        return _listBackgroundColor;
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        _borderColor = [UIColor lightGrayColor];
        _borderWidth = 1.0f/[UIScreen mainScreen].scale;
        _textFont = [UIFont systemFontOfSize:14.0f];
        _textColor = [UIColor blackColor];
        _alignment = NSTextAlignmentCenter;
        _cornerRadius = 5.0f;
        self.formLayout = [[MixFormContentSizeFlowLayout alloc]init];
        typeof(self) __weak weakself = self;
        [self.formLayout setItemCountBlock:^NSInteger(NSInteger section)
         {
             return [weakself columns];
         }];
        [self.formLayout setItemSizeBlock:^CGSize(NSIndexPath *indexPath)
         {
             return [weakself size:indexPath.section column:indexPath.item];
         }];
        [self.formLayout setSectionCountBlock:^NSInteger
         {
             return [weakself rows];
         }];
        self.formContentView = [[MixFormContentSizeCollectionView alloc]initWithFrame:[self itemsBounds] collectionViewLayout:self.formLayout];
        [self.formContentView setDataSource:self];
        [self.formContentView setDelegate:self];
        [self.formContentView setBackgroundColor:[self listBackgroundColor]];
        [self.formContentView registerClass:[FormItemCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:self.formContentView];
    }
    return self;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self rows];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self columns];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self size:indexPath.section column:indexPath.item];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat totalWidth = 0.0f;
    for (NSInteger i=0; i<[self columns]; i++)
    {
        totalWidth += [self size:section column:i].width;
    }
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, collectionView.bounds.size.width - totalWidth);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FormItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:(arc4random()%255)/255.0f green:(arc4random()%255)/255.0f blue:(arc4random()%255)/255.0f alpha:1.0f]];
    [cell.textContentLabel setFont:[self textFont:indexPath.section column:indexPath.item]];
    [cell configurationContentText:[self text:indexPath.section column:indexPath.item]];
    [cell configurationBorder:[self borderForLeft:indexPath.section column:indexPath.item] haveRight:[self borderForRight:indexPath.section column:indexPath.item] haveTop:[self borderForTop:indexPath.section column:indexPath.item] haveBottom:[self borderForBottom:indexPath.section column:indexPath.item] lineWidth:self.borderWidth borderColor:[self borderColor:indexPath.section column:indexPath.item] itemSize:[self size:indexPath.section column:indexPath.item]];
    [cell.textContentLabel setTextAlignment:self.alignment];
    [cell.textContentLabel setTextColor:[self textColor:indexPath.section column:indexPath.item]];
    [cell setBackgroundColor:[self color:indexPath.section column:indexPath.item]];
    
    //    printf("(%li,%li) ",(long)indexPath.section,(long)indexPath.row);
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (DelegateResponds(@selector(listChart:clickForRow:column:)))
    {
        [self.delegate listChart:self clickForRow:indexPath.section column:indexPath.item];
    }
}


-(void)reloadData
{
    [self.formContentView resetContentSize];
    [self.formLayout refreshLayoutAttributes];
    CGFloat maxWidth = 0.0f;
    for (NSInteger section = 0; section < [self rows]; section++)
    {
        CGFloat totalWidth = 0.0f;
        for (NSInteger i=0; i<[self columns]; i++)
        {
            totalWidth += [self size:section column:i].width;
        }
        maxWidth = MAX(maxWidth, totalWidth);
    }
    [self.formContentView setContentSize:CGSizeMake(MAX(MAX(self.formContentView.contentSize.width, maxWidth), self.formContentView.bounds.size.width), self.formContentView.contentSize.height)];
    [self.formContentView reloadData];
    
}

@end

@implementation MixFormContentSizeCollectionView

-(void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:CGSizeMake(MAX(self.contentSize.width, contentSize.width), contentSize.height)];
}
-(void)resetContentSize
{
    [super setContentSize:self.bounds.size];
}

@end

@implementation MixFormContentSizeFlowLayout

-(void)prepareLayout
{
    [super prepareLayout];
    self.oldBounds = self.collectionView.bounds;
    if (!self.itemAttributesDataArray)
    {
        [self refreshLayoutAttributes];
    }
}

-(void)refreshLayoutAttributes
{
    NSMutableArray *resultArray = [NSMutableArray array];
    NSInteger sectionCount = self.sectionCountBlock();
    CGFloat startY = 0.0f;
    for (NSInteger section=0; section < sectionCount; section++)
    {
        CGFloat startX = 0.0f;
        CGFloat maxHeight = 0.0f;
        NSInteger itemCount = self.itemCountBlock(section);
        for (NSInteger item = 0; item<itemCount; item++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGSize itemSize = self.itemSizeBlock(indexPath);
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(startX, startY, itemSize.width, itemSize.height);
            [resultArray addObject:attributes];
            startX += itemSize.width;
            maxHeight = MAX(maxHeight, itemSize.height);
        }
        startY += maxHeight;
    }
    self.itemAttributesDataArray = resultArray;
}

-(CGSize)collectionViewContentSize
{
    NSInteger sectionCount = self.sectionCountBlock();
    CGFloat startY = 0.0f;
    CGFloat maxWidth = 0.0f;
    for (NSInteger section=0; section < sectionCount; section++)
    {
        CGFloat startX = 0.0f;
        CGFloat maxHeight = 0.0f;
        NSInteger itemCount = self.itemCountBlock(section);
        for (NSInteger item = 0; item<itemCount; item++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGSize itemSize = self.itemSizeBlock(indexPath);
            startX += itemSize.width;
            maxHeight = MAX(maxHeight, itemSize.height);
            maxWidth = MAX(maxWidth, startX);
        }
        startY += maxHeight;
    }
    return CGSizeMake(maxWidth, startY);
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = 0;
    for (NSInteger section=0; section < indexPath.section; section++)
    {
        NSInteger itemCount = self.itemCountBlock(section);
        index += itemCount;
    }
    index += indexPath.item;
    return [self.itemAttributesDataArray objectAtIndex:index];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (self.oldBounds.size.width == newBounds.size.width && self.oldBounds.size.height == newBounds.size.height)
    {
        return NO;
    }
    
    return YES;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    return self.itemAttributesDataArray;
    
    //    NSMutableArray *showItemArray = [NSMutableArray array];
    //    CGRect showRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    //    for (UICollectionViewLayoutAttributes *attributes in self.itemAttributesDataArray)
    //    {
    //        UICollectionViewLayoutAttributes *firstAttributes = [self.itemAttributesDataArray firstObject];
    //        CGFloat minX = MIN(attributes.frame.origin.x, showRect.origin.x);
    //        CGFloat maxX = MAX(attributes.frame.origin.x+attributes.frame.size.width, showRect.origin.x+showRect.size.width);
    //        CGFloat minY = MIN(attributes.frame.origin.y, showRect.origin.y);
    //        CGFloat maxY = MAX(attributes.frame.origin.y+attributes.frame.size.height, showRect.origin.y+showRect.size.height);
    //        if (!((maxY - minY - firstAttributes.frame.size.height)>(attributes.frame.size.height+showRect.size.height) && (maxX - minX - firstAttributes.frame.size.width) > (attributes.frame.size.width+showRect.size.width)))
    //        {
    //            [showItemArray addObject:attributes];
    //        }
    //    }
    //    return showItemArray;
    
}

@end



@implementation FormItemCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.textContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(3.0f, 0.5f*self.bounds.size.height, self.bounds.size.width - 3.0f, 0.0f)];
        [self.textContentLabel setNumberOfLines:0];
        [self.textContentLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.textContentLabel];
        
        self.borderLeftLine = [UIImageView new];
        [self addSubview:self.borderLeftLine];
        
        self.borderRightLine = [UIImageView new];
        [self addSubview:self.borderRightLine];
        
        self.borderTopLine = [UIImageView new];
        [self addSubview:self.borderTopLine];
        
        self.borderBottomLine = [UIImageView new];
        [self addSubview:self.borderBottomLine];
    }
    return self;
}


-(void)configurationContentText:(NSString *)content
{
    [self.textContentLabel setText:content];
    [self layoutSubviews];
}

-(void)configurationBorder:(BOOL)haveLeft haveRight:(BOOL)haveRight haveTop:(BOOL)haveTop haveBottom:(BOOL)haveBottom lineWidth:(CGFloat)lineWidth borderColor:(UIColor*)borderColor itemSize:(CGSize)itemSize
{
    [self.borderLeftLine setHidden:!haveLeft];
    [self.borderRightLine setHidden:!haveRight];
    [self.borderTopLine setHidden:!haveTop];
    [self.borderBottomLine setHidden:!haveBottom];
    [self.borderLeftLine setFrame:CGRectMake(0.0f, 0.0f, lineWidth, itemSize.height)];
    [self.borderRightLine setFrame:CGRectMake(itemSize.width - lineWidth, 0.0f, lineWidth, itemSize.height)];
    [self.borderTopLine setFrame:CGRectMake(0.0f, 0.0f, itemSize.width, lineWidth)];
    [self.borderBottomLine setFrame:CGRectMake(0.0f, itemSize.height - lineWidth, itemSize.width, lineWidth)];
    [self.borderLeftLine setBackgroundColor:borderColor];
    [self.borderRightLine setBackgroundColor:borderColor];
    [self.borderTopLine setBackgroundColor:borderColor];
    [self.borderBottomLine setBackgroundColor:borderColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [self.textContentLabel sizeThatFits:CGSizeMake(self.textContentLabel.frame.size.width, self.frame.size.height)];
    size = CGSizeMake(MIN(size.width, self.bounds.size.width - 6.0f), MIN(self.bounds.size.height - 6.0f, size.height));
    [self.textContentLabel setFrame:CGRectMake(3.0f, 0.5f*(self.bounds.size.height - size.height), self.bounds.size.width - 6.0f, size.height)];
    [self.textContentLabel setAdjustsFontSizeToFitWidth:YES];
}

@end
