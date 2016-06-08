//
//  AddressListController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-8.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "AddressListController.h"
#import "DigitInformation.h"
#import "ReceiveAddress.h"
#import "YXSpritesLoadingView.h"
#import "ServerRequest.h"
#import "AddAddressController.h"

@interface AddressListController ()
{
    NSMutableArray *m_arrList ;
    
    UIBarButtonItem *m_rightBarItem ;
}
@end

@implementation AddressListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


- (void)setViewStyle
{
    //1.table outlite
    _table.separatorStyle   = UITableViewCellSeparatorStyleNone ;

    //2 DATA sourse
    m_arrList = [NSMutableArray array] ;
    
    //3 bottom view
    _bottomView.backgroundColor = [UIColor whiteColor] ;
    [_bt_addAddr setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    _bt_addAddr.layer.cornerRadius = CORNER_RADIUS_ALL ;
    _bt_addAddr.backgroundColor = COLOR_PINK ;
   
    UIView *upline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)] ;
    upline.backgroundColor = COLOR_BACKGROUND ;
    [_bottomView addSubview:upline] ;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setViewStyle] ;
    
    //3 bar button

    if (_isAddOrSelect)
    {
        m_rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(management)] ;
        self.navigationItem.rightBarButtonItem = m_rightBarItem ;
    }
    else
    {
//        m_rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addNewAddress)] ;
        
    }
    

    
}

- (void)showAddrList
{
    
    [m_arrList removeAllObjects] ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        [self setMyDataSourse] ;
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        [_table reloadData] ;
        
        [self setTableBackground] ;

        if ( (!m_arrList) || (!m_arrList.count) )
        {
            [DigitInformation showWordHudWithTitle:@"快新增一个属于你的地址吧"] ;
            
            return  ;
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
        [_table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO] ;
        
    } AndWithMinSec:0] ;
    
}


- (void)setTableBackground
{

    if (!m_arrList.count)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_table.frame] ;
        UIImage *img = [UIImage imageNamed:@"noAddr"] ;
        imageView.image = img ;
        imageView.contentMode = UIViewContentModeScaleAspectFit ;
        [_table setBackgroundView:imageView] ;
    }
    else
    {
        [_table setBackgroundView:nil] ;
    }
}



- (void)setMyDataSourse
{
    NSMutableArray *tempArr = [NSMutableArray array] ;
    
    ReceiveAddress *addrDefault = [[ReceiveAddress alloc] init] ;
    
    NSArray *addrList = [ServerRequest getMyAddressList] ;
    
    if (!addrList)  return ;
    
    for (NSDictionary *dic in addrList)
    {
        ReceiveAddress *addr = [[ReceiveAddress alloc] initWithDic:dic] ;
        [tempArr addObject:addr] ;
        
        if (addr.isDefault)
        {
            addrDefault = addr ;
            [m_arrList addObject:addrDefault] ;
        }
    }
    
    for (ReceiveAddress *addr in tempArr)
    {
        if (! addr.isDefault) [m_arrList addObject:addr] ;
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    //
    [self showAddrList] ;
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
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return m_arrList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"AddressCell";
    AddressCell *cell = (AddressCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil)
    {
        cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ReceiveAddress *addr = (ReceiveAddress *)[m_arrList objectAtIndex:indexPath.row] ;
    cell.myAddr = addr ;
    
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //auto ajust
    if (! m_arrList.count) return 0 ;
    
    ReceiveAddress *add = (ReceiveAddress *)[m_arrList objectAtIndex:indexPath.row] ;
    NSString *str = add.address ;

    UIFont *font = [UIFont systemFontOfSize:12.0f];
    CGSize size = CGSizeMake(272,200);
    CGSize labelsize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
    return labelsize.height + 95 ;
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row) ;
    // change new data source and reload table
    ReceiveAddress *add = (ReceiveAddress *)[m_arrList objectAtIndex:indexPath.row] ;
    
    if (_isAddOrSelect)
    {
        [self.delegate sendSelectedAddress:add] ;
        [self.navigationController popViewControllerAnimated:YES]       ;
    }
    else
    {
        [self performSegueWithIdentifier:@"address2add" sender:add]     ;
    }
    
}


#pragma mark -- Delete
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //  DEL DATA SOURCE FROM CLIENT AND SERVER
        ReceiveAddress *addr = (ReceiveAddress *)[m_arrList objectAtIndex:indexPath.row] ;

        //  DEL DATA SOURCE FROM SERVER
        BOOL b = [ServerRequest deleteAddressWithID:addr.addressId] ;
        //  DEL DATA SOURCE FROM CLIENT
        if (b)
        {
            [m_arrList removeObjectAtIndex:indexPath.row] ;
            
            //  DEL FROM VIEW
            //DEL  TABLE VIEW CELL
            [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }
}



#pragma mark --
#pragma mark - add new address
- (void)addNewAddress
{
    NSLog(@"addNewAddress") ;
    
    [self performSegueWithIdentifier:@"address2add" sender:nil] ;
}

- (void)management
{
    NSLog(@"management") ;
    
    _isAddOrSelect = NO ;
    m_rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)] ;
    self.navigationItem.rightBarButtonItem = m_rightBarItem ;
}

- (void)finish
{
    _isAddOrSelect = YES ;
    m_rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(management)] ;
    self.navigationItem.rightBarButtonItem = m_rightBarItem ;
}

- (IBAction)addAddressAction:(id)sender
{
    [self addNewAddress] ;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"address2add"])
    {
        AddAddressController *addAddrCtrl = (AddAddressController *)[segue destinationViewController] ;
        addAddrCtrl.myAddr = (ReceiveAddress *)sender ;
    }
    
}






@end
