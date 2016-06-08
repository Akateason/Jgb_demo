//
//  UseScoreController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "UseScoreController.h"
#import "COScoreCell.h"
#import "DigitInformation.h"

@interface UseScoreController () <COScoreCellDelegate>

@end

@implementation UseScoreController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _table.dataSource = self ;
    _table.delegate = self ;
    _table.backgroundColor = [UIColor whiteColor] ;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"使用" style:UIBarButtonItemStylePlain target:self action:@selector(useButtonClicked)] ;
    self.navigationItem.rightBarButtonItem = rightBarItem ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"COScoreCell";
    
    COScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.delegate = self ;

    return cell ;
    
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0f ;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


#pragma mark --
#pragma mark - COScoreCellDelegate
/*
 *  scoreWrited
 */
- (void)sendScore:(int)scoreWrited
{
    NSLog(@"scoreWrited : %d",scoreWrited) ;
    
    int maxSore = G_USER_CURRENT.score ;
    
    if (scoreWrited > maxSore) {
        [DigitInformation showWordHudWithTitle:WD_HUD_SCOREOUTBONNDS] ;
        return ;
    }
    
    [self.delegate sendWritedScore:scoreWrited] ;
    
    [self.navigationController popViewControllerAnimated:YES] ;

}

/*
 *  bShowHide : Y == show , N == hide
 */
- (void)showHideKeyBoard:(BOOL)bShowHide
{
//    CGRect myViewRect = ( bShowHide ) ? CGRectMake(0, - 100, self.view.frame.size.width, self.view.frame.size.height) : CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) ;
//
//    [UIView beginAnimations:@"showHideKeyBoard" context:nil];
//    [UIView setAnimationDuration:0.3f];
//    self.view.frame = myViewRect ;
//    [UIView commitAnimations];
    
}

#pragma mark --
- (void)useButtonClicked
{

    NSLog(@"useButtonClicked") ;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0] ;
    COScoreCell *cell = (COScoreCell *)[_table cellForRowAtIndexPath:indexpath] ;
    [cell useAction] ;
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
