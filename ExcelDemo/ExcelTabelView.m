//
//  ExcelTabelView.m
//  ExcelDemo
//
//  Created by tangyunchuan on 2019/2/22.
//  Copyright © 2019 tangyunchuan. All rights reserved.
//

#import "ExcelTabelView.h"
#import "ExcelCell.h"

@interface ExcelTabelView ()<UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (nonatomic, strong) NSIndexPath *theIndexPath;

@end

@implementation ExcelTabelView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = self.frame.size.height;
    }
    return self;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 16;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ExcelCell";
    ExcelCell *theCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!theCell) {
        theCell = [[ExcelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.isVertical) {
        //MARK:左右滑
        [theCell.contentView setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        theCell.isVertical = self.isVertical;
    }
    return theCell;
}

@end
