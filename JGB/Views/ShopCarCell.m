//
//  ShopCarCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ShopCarCell.h"
#import "ColorsHeader.h"
#import "LSCommonFunc.h"


@implementation ShopCarCell

- (void)awakeFromNib
{
    [super awakeFromNib] ;

    _img_goods.contentMode  = UIViewContentModeScaleAspectFit ;
    
    _stepView.hidden        = YES ;
    _isEdited               = NO ;
    _lb_detail.hidden       = NO ;
   
    //  text color
    _lb_title.textColor  = [UIColor darkGrayColor]  ;
    _lb_detail.textColor = [UIColor lightGrayColor] ;
    
    float wid = 1.0f ;
    
    UIView *upline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, wid)]  ;
    upline.backgroundColor = COLOR_BACKGROUND ;
    [self addSubview:upline] ;
    
    
    _lb_loseEfficient.hidden = YES ;
    
    
    _lb_price.textColor         = COLOR_PINK ;
    _lb_number.textColor        = [UIColor darkGrayColor] ;
    
    self.backgroundColor        = [UIColor whiteColor] ;
    
    //加购
    _lb_isAddon.backgroundColor     = COLOR_SKY_BLUE    ;
    _lb_isAddon.layer.cornerRadius  = CORNER_RADIUS_ALL ;
    _lb_isAddon.layer.masksToBounds = YES ;
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
}


#pragma mark --
#pragma mark - setter
- (void)setIsLoseEfficient:(BOOL)isLoseEfficient
{
    _isLoseEfficient            = isLoseEfficient  ;
    
    
    _lb_loseEfficient.hidden    = !isLoseEfficient ;
    _bt_check.hidden            = isLoseEfficient  ;
    _img_check.hidden           = isLoseEfficient  ;
    self.backgroundColor        = isLoseEfficient ? COLOR_LIGHT_GRAY : [UIColor whiteColor] ;    //COLOR_BACKGROUND
    
    
    if (isLoseEfficient) {
        NSLog(@"isLoseEfficient") ;
    }
}


- (void)setIsSelected:(BOOL)isSelected
{
    if (isSelected)
    {
        self.img_check.image = [UIImage imageNamed:@"y"];
    }
    else
    {
        self.img_check.image = [UIImage imageNamed:@"n"];
    }
}


- (void)setIsEdited:(BOOL)isEdited
{
    _isEdited = isEdited ;
    
//    
    _stepView.hidden    = !isEdited ;
   
    _lb_detail.hidden   = isEdited ;
    _lb_number.hidden   = isEdited ;
    
}

- (void)setIsAddedOn:(BOOL)isAddedOn
{
    _isAddedOn = isAddedOn ;
    
    _lb_isAddon.hidden = !isAddedOn ;
}


- (void)setShopCarG:(ShopCarGood *)shopCarG
{
    _shopCarG = shopCarG  ;
    
    Goods *g = shopCarG.good;

//      title
    _lb_title.text = g.title ;
    
//      attr
    if ( (g.attr == nil) || ([g.attr isKindOfClass:[NSNull class]]) )
    {
        _lb_detail.text = @"";
    }
    else
    {
        NSArray *attrkeys   = [(NSDictionary *)(g.attr) allKeys] ;
        NSString *attStr    = @"" ;
        for (NSString *key in attrkeys)
        {
            NSString *str = [NSString stringWithFormat:@"%@:%@",key,[g.attr objectForKey:key]] ;
            attStr = [attStr stringByAppendingString:str] ;
        }
        
        _lb_detail.text = attStr;
    }
//      price
    float strPrice = (g.promotiom == nil) ? shopCarG.price : g.promotiom.price ;
    NSString *strResult = [LSCommonFunc changeFloat:[NSString stringWithFormat:@"￥%.2f", strPrice * shopCarG.nums]] ;
    _lb_price.text  = strResult ;
//      number
    _lb_number.text = [NSString stringWithFormat:@"x%d", shopCarG.nums];
//      img goos
    NSString *imgStr    = g.galleries[0] ;
//    [_img_goods setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(90, 90)] ;
    [_img_goods setIndexImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMG_NOPIC options:0 AndSaleSize:CGSizeMake(90, 90)] ;
    
//    step
    _stepView.num      = shopCarG.nums      ;
    _stepView.maxNum   = g.stock_count      ;       //  库存 ;
    
//    能否选中
    self.isSelected = shopCarG.isSelectedInShopCar ;
//    是否失效
    self.isLoseEfficient = shopCarG.isLoseEfficient ;
    
//    是否加购
    BOOL bIsAddon = NO ;
    for (int i = 0; i < g.type.count ; i++)
    {
        NSString *str = g.type[i]   ;
        if ([str isEqualToString:@"addon"])
        {
            bIsAddon = YES ;
        }
    }
    self.isAddedOn = bIsAddon ;
}



- (void)setIsLastFooter:(BOOL)isLastFooter
{
    _isLastFooter = isLastFooter ;
    
//    _footerView.hidden = ! isLastFooter ;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark --
#pragma mark - actions
- (IBAction)checkPressed:(id)sender
{
    UIButton *bt = (UIButton *)sender ;
    bt.selected = !bt.selected ;
    

    [_delegate sendTheCellSection:self.section AndWithRow:self.row AndWithIsSelect:!bt.selected ] ;
    
}


- (IBAction)proPicClickedAction:(id)sender
{
    NSLog(@"proPicClickedAction") ;
    
    [self.delegate sendShopCarGoodWhenClickProductPictures:_shopCarG] ;
}
@end
