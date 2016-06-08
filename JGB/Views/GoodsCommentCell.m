//
//  GoodsCommentCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-3.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "GoodsCommentCell.h"
#import "UIImageView+WebCache.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "ColorsHeader.h"


@interface GoodsCommentCell ()

{
    UIView *m_baseLine ;
}

@end

@implementation GoodsCommentCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
//    self.backgroundColor = COLOR_BACKGROUND ;
    self.contentView.backgroundColor = [UIColor whiteColor] ;
    
    [TeaCornerView setRoundHeadPicWithView:_img_userHead] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(Comment *)comment
{
    _comment = comment ;
    
    //head pic
    NSString *headStr = _comment.avatar ;
//    NSString *headStr = [NSString stringWithFormat:@"http://heads.qiniudn.com/%d.jpg",_comment.uid] ;
    [_img_userHead setImageWithURL:[NSURL URLWithString:headStr] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(55*2, 55*2)] ;
    
    //username
    _lb_userName.text = _comment.uname ;
    
    //comment content
    _lb_comment.text = _comment.message ;
    
    //atime in main at /Users/um001/Documents/JGB/JGB/main.m:16
    _lb_date.text = [MyTick getDateWithTick:_comment.atime AndWithFormart:TIME_STR_FORMAT_5] ;
    
    //like condition pic and lab
    NSString *likeStr = @"" ;
    NSString *likeImg = @"" ;
    
    likeLevelEnum level = [_comment getLikeLevelWithRate:_comment.point] ;
    
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

    _img_star.image       = [UIImage imageNamed:likeImg] ;
    _img_star.contentMode = UIViewContentModeScaleAspectFit ;
    
}





@end
