//
//  NoteGoodsCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-4.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "NoteGoodsCell.h"

@interface NoteGoodsCell ()
{
    LabelNoteVIew       *m_labView ;
}
@property (weak, nonatomic) IBOutlet UIView *noteContentView;
@property (weak, nonatomic) IBOutlet UILabel *lb_note;

@end

@implementation NoteGoodsCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    _lb_note.textColor = [UIColor darkGrayColor] ;
    
    if (!m_labView)
    {
        m_labView = (LabelNoteVIew *)[[[NSBundle mainBundle] loadNibNamed:@"LabelNoteVIew" owner:self options:nil] firstObject] ;
    }
    if (!m_labView.superview) {
        [_noteContentView addSubview:m_labView] ;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone ;

}


- (void)setNoteMode:(ModeForGoodsNotes)noteMode
{
    _noteMode = noteMode ;

    [m_labView setNoteMode:noteMode] ;
    
    switch (noteMode)
    {
        case modeAddons:
        {
            _lb_note.text = @"必须满25美元才能下单" ;
        }
            break;
        case modeDaiGou:
        {
            _lb_note.text = @"代购商品订单以海外下单成功已否为准" ;
        }
            break;
        case modeZiYin:
        {
            _lb_note.text = @"本商品金箍棒精选商品" ;
        }
            break;
        default:
            break;
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
