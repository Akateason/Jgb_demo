//
//  DeserveBuyView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-28.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "DeserveBuyView.h"
#import "BuyCell.h"

@implementation DeserveBuyView

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    _table.delegate = self ;
    _table.dataSource = self ;
    
    self.frame = CGRectMake(self.frame.origin.x
                            , self.frame.origin.y, self.frame.size.width, APPFRAME.size.height - 64 - 40 - 49) ;
//    NSLog(@"deserve frame : %@",NSStringFromCGRect(self.frame)) ;
}



#pragma mark --
#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return 10 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int section = indexPath.section ;
//    int row     = indexPath.row     ;

    BuyCell *cell = (BuyCell *)[tableView dequeueReusableCellWithIdentifier:@"BuyCell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BuyCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.isShowDecline  = NO ;
    
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 136 ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
