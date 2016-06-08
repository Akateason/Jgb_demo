//
//  GoodCommentCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "GoodCommentCell.h"
#import "UIImageView+WebCache.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "ReplyCell.h"
#import "DigitInformation.h"
#import "ColorsHeader.h"

@implementation GoodCommentCell

/*
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint startPoint = CGPointMake(0, 10) ;
    //CGPointMake(0, rect.size.height) ;
    CGPoint endPoint   = CGPointMake(100, 10) ;
    //CGPointMake(rect.size.width, rect.size.height) ;
    
    //    CGContextSetLineWidth(context, 2.0) ;
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    float lengths[] = {5,5};
    CGContextSetLineDash(context, 0, lengths,1);
    
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x,endPoint.y);
}
*/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setViewStyle
{
    self.backgroundColor = [UIColor whiteColor] ;
    
    _img_userHead.contentMode = UIViewContentModeScaleAspectFit ;
    [TeaCornerView setRoundHeadPicWithView:_img_userHead] ;



}



- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    
    //暂时隐藏 评论图标
    _askButton.hidden = YES ;
    _img_ask.hidden = YES ;
    
    [self setViewStyle] ;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark --
#pragma mark - Setter
- (void)setTheComment:(Comment *)theComment
{
    _theComment = theComment ;
    
    
    //用户民
    _lb_userName.text = _theComment.uname ;
    //头像
    NSString *headStr = theComment.avatar ;
    [_img_userHead setIndexImageWithURL:[NSURL URLWithString:headStr] placeholderImage:IMG_NOPIC options:0 AndSaleSize:CGSizeMake(50*2, 50*2)] ;
    

    //评论内容
    _lb_content.text = _theComment.message ;
    //日期
    _lb_date.text = [MyTick getDateWithTick:_theComment.atime AndWithFormart:TIME_STR_FORMAT_5] ;
    
    //星级
    NSString *likeStr   = @"" ;
    NSString *likeImg   = @"" ;
    
    likeLevelEnum level = [_theComment getLikeLevelWithRate:_theComment.point] ;
    
    switch (level)
    {
        case LEVEL_HATE:
        {
            //不喜欢
            likeStr = @"不喜欢";
            likeImg = @"like1" ;
        }
            break;
        case LEVEL_NORMAL:
        {
            //一般
            likeStr = @"一般"   ;
            likeImg = @"like2"  ;
        }
            break;
        case LEVEL_LIKE:
        {
            //很喜欢
            likeStr = @"很喜欢" ;
            likeImg = @"like3" ;
        }
            break;
        default:
            break;
    }
    
    _lb_like.text   = likeStr ;
    _img_like.image = [UIImage imageNamed:likeImg] ;
    
    // reply
    _tableReply.separatorStyle  = UITableViewCellSeparatorStyleNone         ;
    _tableReply.backgroundColor = COLOR_BACKGROUND                          ;
    _tableReply.scrollEnabled   = NO    ;
    _tableReply.layer.cornerRadius = CORNER_RADIUS_ALL ;
    
    if (! _theComment.reply.count)
    {   // reply count zero
        _tableReply.hidden      = YES   ;
    }
    else
    {   // reply exist
        _tableReply.hidden      = NO    ;
        _tableReply.delegate    = self  ;
        _tableReply.dataSource  = self  ;
    }
    
    float HeightReply = [_theComment getReplyTableHeight] ;
    _heightConstraint.constant = HeightReply ;
}

#pragma mark -- action 
//回复评论
- (IBAction)askCommentAction:(id)sender
{
//    NSLog(@"askCommentAction") ;
    
    if (! G_TOKEN || [G_TOKEN isEqualToString:@""])
    {
        [self.delegate userNotLoginCallBack] ;
        return ;
    }
    
    [self.delegate commentAnswerButtonClickedWithCommentID:_theComment.commentID AndWithRow:_row] ;
}

#pragma mark --
#pragma mark - reply table
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _theComment.reply.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"ReplyCell";

    ReplyCell * cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.theReply       = _theComment.reply[indexPath.row] ;
    
    return cell ;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Reply *replyTemp        = _theComment.reply[indexPath.row] ;
    
    float cellOrgHeight     = 24.0f ;
    float lbOrgHeight       = 12.0f ;
    
    NSString *commentStr    = replyTemp.message;
    
    if (! replyTemp.parentName)
    {
        commentStr = [NSString stringWithFormat:@"%@: %@",replyTemp.uname,replyTemp.message] ;
    }
    else
    {
        commentStr = [NSString stringWithFormat:@"%@ 回复 %@: %@",replyTemp.uname,replyTemp.parentName,replyTemp.message] ;
    }
    
    UIFont *font     = [UIFont systemFontOfSize:12];
    CGSize size      = CGSizeMake(207,200);
    CGSize labelsize = [commentStr sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    float h =  cellOrgHeight - lbOrgHeight + labelsize.height ;
    
    return h ;
}


#pragma mark --
#pragma mark - Table view delegate
// header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *back = [[UIView alloc] init] ;
    back.backgroundColor = COLOR_BACKGROUND ;
    
    return back ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6 ;
}

// footer view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *back = [[UIView alloc] init] ;
    back.backgroundColor = COLOR_BACKGROUND ;
    
    return back ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6 ;
}

//  Did selected Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if not login
    if (! G_TOKEN || [G_TOKEN isEqualToString:@""])
    {
        [self.delegate userNotLoginCallBack] ;
        return ;
    }
    
    // get reply
    Reply *replyTemp  = _theComment.reply[indexPath.row] ;
    
    // i cant answer my reply
    if (G_USER_CURRENT.uid == replyTemp.uid)
    {
        return ;
    }
    
    // upheight
    float upHeight = 0.0f ;
    for (int i = indexPath.row ; i >= 0 ; i--)
    {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0] ;
        upHeight += [self tableView:tableView heightForRowAtIndexPath:indexpath] ;
    }
    
    //
    [self.delegate replyAnswerCellSelectedWithCommentID:_theComment.commentID AndWithRow:_row AndWithReplyID:replyTemp.replyID AndWithReplyHeight:upHeight AndWithPlaceHolderStr:replyTemp.uname] ;
}

#pragma mark --


@end
