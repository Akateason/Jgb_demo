//
//  FilterViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "FilterViewController.h"
#import "DigitInformation.h"
#import "BATableView.h"
#import "BrandTB.h"
#import "Brand.h"
#import "ServerRequest.h"
#import "WarehouseTB.h"

#define WD_WAREHOUSE    @"仓库"

@interface FilterViewController () <BATableViewDelegate>
{
    NSArray *m_dataSource ;
}

@property (nonatomic, strong) BATableView *contactTableView;

@end

@implementation FilterViewController

@synthesize m_selectValue ,flag, m_brandList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
// Do any additional setup after loading the view.

    NSLog(@"m_dataSource : %@",m_brandList) ;
    
    //  set My Title
    [self setMyTitle]   ;
    //  set My View
    [self setMyView]    ;
    
}


- (void)setMyTitle
{
    self.table.hidden = NO ;

    if (m_brandList.count)
    {
        if ([flag isEqualToString:@"品牌"])
        {
            self.table.hidden   = YES           ;
            m_dataSource        = m_brandList   ;
            [self createTableView]              ;
        }
        else if ([flag isEqualToString:@"价格"])
        {
            m_dataSource = m_selectValue.priceAreaArray ;
        }
        else if ([flag isEqualToString:WD_WAREHOUSE])
        {
            m_dataSource = [DigitInformation shareInstance].g_wareHouseList ; //
        }
    }
    else
    {
        if ([flag isEqualToString:@"价格"])
        {
            m_dataSource = m_selectValue.priceAreaArray ;
        }
        else if ([flag isEqualToString:WD_WAREHOUSE])
        {
            m_dataSource = [DigitInformation shareInstance].g_wareHouseList ; //
        }
    }
    
    self.title = flag ;
}

// 创建tableView
- (void) createTableView
{
    float flex = 64.0f ;
    CGRect bounds = self.view.bounds ;
    CGRect rect = CGRectMake(bounds.origin.x
                             , bounds.origin.y + flex,
                             bounds.size.width,
                             bounds.size.height - flex) ;
    self.contactTableView   = [[BATableView alloc] initWithFrame:rect];
    self.contactTableView.delegate = self       ;
    UIImageView *imgView    = [[UIImageView alloc] initWithFrame:rect] ;
    UIImage *image = [UIImage imageNamed:@"tile.jpg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile] ;
    imgView.image = image ;
    [self.contactTableView.tableView setBackgroundView:imgView] ;
    [self.contactTableView.tableView setSeparatorColor:[UIColor darkGrayColor]] ;
    [self.contactTableView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine] ;
    
    [self.view addSubview:self.contactTableView];
}

- (void)setMyView
{
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [self.table setBackgroundColor:COLOR_BACKGROUND] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --
#pragma mark - BATableView Delegate
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView
{
    NSMutableArray * indexTitles = [NSMutableArray array];
    
    for (NSDictionary *dic in m_dataSource) {
        NSLog(@"%@",[[dic allKeys] lastObject]) ;
        [indexTitles addObject:[[dic allKeys] lastObject]] ;
    }
    
    return indexTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([flag isEqualToString:@"品牌"])
    {
        return [[m_dataSource[section] allKeys] lastObject] ;
    }
    return nil ;
}

#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (m_brandList.count) {
        if ([flag isEqualToString:@"品牌"]) {
            return m_dataSource.count ;
        }else {
            return 1;
        }
    }else {
        return 1 ;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (m_brandList.count)
    {
        if ([flag isEqualToString:@"品牌"])
        {
            return [[[m_dataSource[section] allValues] lastObject] count] ;
        }
        else
        {
            return [m_dataSource count] + 1;
        }
    }
    else
    {
        return [m_dataSource count] + 1 ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"FilterCell2"         ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier] ;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
    }
    
    cell.textLabel.font         = [UIFont systemFontOfSize:14.0]    ;
    cell.tintColor              = COLOR_WD_GREEN                    ;
    cell.textLabel.textColor    = [UIColor darkGrayColor]           ;
    
    UIView *baseline = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height, cell.frame.size.width, 1)] ;
    baseline.backgroundColor = COLOR_BACKGROUND ;
    [cell addSubview:baseline] ;
    
    UIView *left    =   [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, cell.frame.size.height)] ;
    left.backgroundColor = COLOR_BACKGROUND ;
    [cell addSubview:left] ;
    
    UIView *right    =   [[UIView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 4, 0, 4, cell.frame.size.height)] ;
    right.backgroundColor = COLOR_BACKGROUND ;
    [cell addSubview:right] ;
    
    cell.selectionStyle         = UITableViewCellSelectionStyleNone ;
    
    if (m_brandList.count)
    {
        if ([flag isEqualToString:@"品牌"])
        {
            //品牌
            Brand *brand        = (Brand *)(([[m_dataSource[indexPath.section] allValues] lastObject])[indexPath.row]) ;
            cell.textLabel.text = brand.brandName;
            
            return cell ;
        }
        else
        {
            if (!indexPath.row)
            {
                cell.textLabel.text = @"全部" ;
                
                if ([flag isEqualToString:@"价格"])
                {
                    if (indexPath.row == m_selectValue.currentPriceArea + 1) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
                    }
                }
                else if ([flag isEqualToString:WD_WAREHOUSE])
                {
                    if (indexPath.row == m_selectValue.currentSellers + 1) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
                    }
                }
            }
            else
            {
                int _row = indexPath.row - 1 ;
                if ([flag isEqualToString:@"价格"])
                {
                    Price_area *priceArea = (Price_area *)[m_dataSource objectAtIndex:_row] ;
                    cell.textLabel.text = priceArea.name ;
                    if (indexPath.row == m_selectValue.currentPriceArea + 1) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
                    }
                }
                else if ([flag isEqualToString:WD_WAREHOUSE])
                {
                    WareHouse *ware = (WareHouse *)[m_dataSource objectAtIndex:_row] ;
//                    Seller *seller = (Seller *)[m_dataSource objectAtIndex:_row] ;
                    cell.textLabel.text = ware.name ;
                    if (indexPath.row == m_selectValue.currentSellers + 1)
                    {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
                    }
                }
            }
        }

    }
    else
    {
            if (!indexPath.row)
            {
                cell.textLabel.text = @"全部" ;
                
                if ([flag isEqualToString:@"价格"])
                {
                    if (indexPath.row == m_selectValue.currentPriceArea + 1) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
                    }

                    
                }
                else if ([flag isEqualToString:WD_WAREHOUSE])
                {
                    if (indexPath.row == m_selectValue.currentSellers + 1) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
                    }

                }
                
            }
            else
            {
                int _row = indexPath.row - 1 ;
                
                if ([flag isEqualToString:@"价格"])
                {
                    Price_area *priceArea = (Price_area *)[m_dataSource objectAtIndex:_row] ;
                    cell.textLabel.text = priceArea.name ;
                    if (indexPath.row == m_selectValue.currentPriceArea + 1) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
                    }
                }
                else if ([flag isEqualToString:WD_WAREHOUSE])
                {
                    WareHouse *ware = (WareHouse *)[m_dataSource objectAtIndex:_row] ;
//                    Seller *seller = (Seller *)[m_dataSource objectAtIndex:_row] ;
                    cell.textLabel.text = ware.name ;
                    if (indexPath.row == m_selectValue.currentSellers + 1) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
                    }
                }
            }
    }
    
    return cell ;
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i <= m_dataSource.count; i++)
    {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0] ;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:ip] ;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    int row = indexPath.row - 1 ;

    if (m_brandList.count)
    {
        if ([flag isEqualToString:@"品牌"])
        {
            m_selectValue.currentBrandSTR   = ((Brand *)(([[m_dataSource[indexPath.section] allValues] lastObject])[indexPath.row])).brandName ;
        }
        else if ([flag isEqualToString:@"价格"])
        {
            m_selectValue.currentPriceArea  = row;
        }
        else if ([flag isEqualToString:WD_WAREHOUSE])
        {
            m_selectValue.currentSellers    = row;
        }
        
    } else {
        
        if ([flag isEqualToString:@"价格"])
        {
            m_selectValue.currentPriceArea  = row;
        }
        else if ([flag isEqualToString:WD_WAREHOUSE])
        {
            m_selectValue.currentSellers    = row;
        }
    }
    
    G_SELECT_VAL = m_selectValue ;

    [self performSelector:@selector(gogoBack) withObject:nil afterDelay:0.45] ;
}

- (void)gogoBack
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44 ;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *back = [[UIView alloc] init] ;
        back.backgroundColor = COLOR_BACKGROUND ;
        
        return back ;
    }
    
    return nil ;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 15 ;

    return 0 ;
}

@end
