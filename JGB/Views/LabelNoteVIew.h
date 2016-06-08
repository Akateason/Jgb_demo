//
//  LabelNoteVIew.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-3.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    modeAddons = 0 ,        //加购商品
    modeDaiGou,             //代购商品
    modeZiYin               //金箍棒精选
} ModeForGoodsNotes ;


@interface LabelNoteVIew : UIView


@property (nonatomic) ModeForGoodsNotes noteMode ;


@end
