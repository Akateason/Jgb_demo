//
//  CommentListCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CommentListCell.h"
#import "DigitInformation.h"
#import "UIImageView+WebCache.h"
#import "ColorsHeader.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

@implementation CommentListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    _img_goods.contentMode = UIViewContentModeScaleAspectFit ;
    _bgView.backgroundColor = [UIColor whiteColor] ;
    self.backgroundColor = COLOR_BACKGROUND ;
    [TeaCornerView setRoundHeadPicWithView:_img_goods] ;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews
{
    [super layoutSubviews]    ;
}


#pragma mark --
#pragma mark - setter
- (void)setCommentMode:(CmtCellMode)commentMode
{
    _commentMode = commentMode ;
    
    
    [self setLabelStyleWithIsShowButton:NO] ;
    
    NSString *strWillShow = @"" ;
    
    switch (commentMode)
    {
        case sendCommentMode:
        {
            [self setLabelStyleWithIsShowButton:YES] ;
            strWillShow = STATUS_SEND_COMMENT ;
        }
            break;
        case sendFailMode:
        {
            strWillShow = STATUS_SEND_FAIL ;
        }
            break ;
        case waitForCheckMode:
        {
            strWillShow = STATUS_WAITFORCHECK ;
        }
            break ;
        case sendSuccessMode:
        {
            strWillShow = STATUS_SEND_SUCCESS ;
        }
            break ;
        case managerReplyMode:
        {
            strWillShow = STATUS_MANAGER_REPLY ;
        }
            break ;
            
            
        default:
            break;
    }
    
    _lb_status.text = strWillShow ;
    
}


- (void)setLabelStyleWithIsShowButton:(BOOL)isShowButton
{
    if (isShowButton)
    {
        _lb_status.textAlignment      = NSTextAlignmentCenter ;
        _lb_status.layer.borderColor  = COLOR_PINK.CGColor ;
        _lb_status.layer.borderWidth  = 1.0f ;
        _lb_status.layer.cornerRadius = 2.0f ;
        _lb_status.textColor          = COLOR_PINK ;
        
        _bt_comment.hidden            = NO ;
    }
    else
    {
        _lb_status.textAlignment      = NSTextAlignmentLeft ;
        _lb_status.layer.borderWidth  = 0.0f ;
        _lb_status.textColor          = [UIColor darkGrayColor] ;
        _lb_status.layer.cornerRadius = 0.0f ;

        _bt_comment.hidden            = YES ;
    }
}


- (void)setCmt:(ListComment *)cmt
{
    _cmt = cmt ;
    
    [_img_goods setIndexImageWithURL:[NSURL URLWithString:cmt.image] placeholderImage:IMG_NOPIC options:0 AndSaleSize:CGSizeMake(60*2, 60*2)] ;
//    [_img_goods setImageWithURL:[NSURL URLWithString:cmt.image] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(60*2, 60*2)] ;
    
    _lb_title.text  = cmt.title ;
    
    self.commentMode =  cmt.status ;
    
}


#pragma mark --
#pragma mark - actions
- (IBAction)imgClickedAction:(id)sender
{
    NSLog(@"imgClickedAction") ;
}


- (IBAction)commentButtonCicked:(id)sender
{
    [self.delegate pressedCommentButtonSendCellIndex:self.row ] ;
}



@end
