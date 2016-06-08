//
//  UserHeadCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-9.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserHeadCellDelegate <NSObject>

- (void)pressUserHeadPictureCallBack ;

@end


@interface UserHeadCell : UITableViewCell

@property (nonatomic,retain) id <UserHeadCellDelegate> delegate ;

@property (nonatomic,copy) NSString *strImgs ;
@property (nonatomic,retain) UIImage *imgPhotoOver ;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)tagImg:(id)sender ;

@end
