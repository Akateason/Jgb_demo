//
//  WordChooseCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "WordChooseCell.h"
#import "DigitInformation.h"
#import "ColorsHeader.h"



@implementation WordCollectionCell


@end


@implementation WordChooseCell

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
    _WordCollectionView.backgroundColor = [UIColor whiteColor] ;
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    _WordCollectionView.collectionViewLayout = layout ;

    
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark --
#pragma mark - collection dataSourse
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%@",wordName) ;
    NSString *wordName = _valueArr[indexPath.row];
    
    UIFont *font = [UIFont systemFontOfSize:WORD_LABEL_FONT];
    CGSize size = CGSizeMake(294,21);
    CGSize labelsize = [wordName sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    CGSize newSize = CGSizeMake(labelsize.width + 25 - 10, 40) ;
    
    return newSize;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.WordCollectionView performBatchUpdates:nil completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _valueArr.count ;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up the reuse identifier
    WordCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"WordCollectionCell"
                                                                          forIndexPath:indexPath];
    // load the image for this cell
    NSString *str      = _valueArr[indexPath.row];
    cell.label.text    = str ;

    UIColor *normalColor = [UIColor lightGrayColor] ;
    UIColor *selectColor = COLOR_PINK               ;
    UIColor *wordColor   = [UIColor darkGrayColor] ;
    
    
    cell.label.font           = [UIFont systemFontOfSize:WORD_LABEL_FONT]  ;
    cell.label.textColor      = wordColor ;
    cell.layer.borderColor    = normalColor.CGColor ; //最普通的,能够选择
    cell.layer.borderWidth    = 1.0                 ;
    cell.layer.cornerRadius   = CORNER_RADIUS_ALL                ;
    
    NSString *mykey = _lb_title.text ;
    if ( (_canSelectDic.count) && (_canSelectDic != nil) )
    {
        // can not be select
        cell.alpha    = 0.25f ;
        

        for (NSString *theKey in _canSelectDic)
        {

            if ([theKey isEqualToString:mykey])
            {
                NSString *val   = _valueArr[indexPath.row];
                
                NSArray *valArr = [_canSelectDic objectForKey:mykey] ;
                for (NSString *valStr in valArr)
                {
                    if ([val isEqualToString:valStr])
                    {
                        // can select , 能够选择
                        cell.layer.borderColor = normalColor.CGColor ;
                        cell.label.textColor   = wordColor ;

                        cell.alpha    = 1.0f ;
                    }
                }
            }
        }
    }
    
    if (indexPath.row == _currentIndex) {
        //already selected
        cell.layer.borderColor    = selectColor.CGColor     ;
        cell.label.textColor      = selectColor             ;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *wordName = _valueArr[indexPath.row];
    NSLog(@"%@",wordName) ;
    _currentIndex = indexPath.row ;
    
    [self.delegate sendKey:_lb_title.text AndSendValue:wordName] ;
}





@end
