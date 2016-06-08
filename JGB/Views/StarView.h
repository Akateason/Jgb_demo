//
//  StarView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  TAG_STAR1  434201
#define  TAG_STAR2  434202
#define  TAG_STAR3  434203
#define  TAG_STAR4  434204
#define  TAG_STAR5  434205


@protocol StarViewDelegate <NSObject>

- (void)sendStarLevel:(int)level ;

@end


@interface StarView : UIView

//properties
@property (nonatomic,retain) id <StarViewDelegate> delegate ;
@property (nonatomic,assign) int level ;    //星星等级; 


//UI
@property (weak, nonatomic) IBOutlet UIButton *bt1;

@property (weak, nonatomic) IBOutlet UIButton *bt2;

@property (weak, nonatomic) IBOutlet UIButton *bt3;

@property (weak, nonatomic) IBOutlet UIButton *bt4;

@property (weak, nonatomic) IBOutlet UIButton *bt5;

- (IBAction)pressedStarAction:(id)sender;



@end
