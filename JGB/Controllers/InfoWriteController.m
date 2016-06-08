//
//  InfoWriteController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-8.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "InfoWriteController.h"
#import "DigitInformation.h"
#import "ServerRequest.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "LSCommonFunc.h"
#import "SBJson.h"



@implementation WriteInfoCell

@end


@interface InfoWriteController ()
{
    NSArray     *m_contentArray;    //
    
    
    User        *m_myUser ;
    
    NSString    *m_resultString ;       //m , 用来保存所有的输入结果
}
@end

@implementation InfoWriteController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setup
{
    if ([_beSelectFlag_str isEqualToString:SELECT_GENDER])
    {
        m_contentArray = @[@"男",@"女"];
        return ;
    }
    
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bt setFrame:CGRectMake(0, 0, 30,44)];
    [bt setTitle:@"保存" forState:UIControlStateNormal];
    [bt setTitleColor:COLOR_PINK forState:UIControlStateNormal] ;
    
    if ([_beSelectFlag_str isEqualToString:SELECT_BIRTHDAY])
    {
        _birthDate.hidden = NO;
        _birthDate.minimumDate = [NSDate dateWithTimeIntervalSince1970:-60*60*24*365*50];
        _birthDate.maximumDate = [NSDate date];
        [_birthDate addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventValueChanged];
        if (m_myUser.birth) {
            _birthDate.date = [MyTick getNSDateWithTick:m_myUser.birth];
        }
        
        [bt addTarget:self action:@selector(saveBirth) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:bt];
        self.navigationItem.rightBarButtonItem = barButton;
        
        return ;
    }
    
    


    [bt addTarget:self action:@selector(saving) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:bt];
    self.navigationItem.rightBarButtonItem = barButton;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1
    NSLog(@"%@",_beSelectFlag_str);
    self.title = _beSelectFlag_str ;
    
    //2
    m_myUser = G_USER_CURRENT;
    m_resultString = @"" ;
    
    //3
    m_contentArray = [NSArray array];
    
    //4
    [self setup] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    self.navigationController.navigationBar.translucent = YES ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
}



#pragma mark - UItableView delegate
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_beSelectFlag_str isEqualToString:SELECT_GENDER])
    {
        return [m_contentArray count] ;
    } else {
        return 1 ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_beSelectFlag_str isEqualToString:SELECT_GENDER]||[_beSelectFlag_str isEqualToString:SELECT_BIRTHDAY])
    {
        static NSString *cellID = @"cusCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        if ([_beSelectFlag_str isEqualToString:SELECT_GENDER])
        {
            cell.textLabel.text = [m_contentArray objectAtIndex:indexPath.row] ;
            cell.textLabel.font = [UIFont systemFontOfSize:12.0f] ;
            if (m_myUser.sex == indexPath.row + 1)
            {   //    性别        0未知, 1男, 2女
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        else if ([_beSelectFlag_str isEqualToString:SELECT_BIRTHDAY])
        {
            cell.textLabel.textAlignment = NSTextAlignmentCenter ;
            cell.textLabel.text = (m_myUser.birth) ? [MyTick getStrWithNSDate:[MyTick getNSDateWithTick:m_myUser.birth] AndWithFormat:TIME_STR_FORMAT_1] : @"请输入您的生日";
            cell.textLabel.textColor = (m_myUser.birth) ? [UIColor blackColor] : [UIColor darkGrayColor] ;
        }
        
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"WriteInfoCell";
        WriteInfoCell *cell = (WriteInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[WriteInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        //
        if ([_beSelectFlag_str isEqualToString:SELECT_NICKNAME]) {
            cell.tf.placeholder = @"请输入您的昵称（4-20个字符）";
            cell.tf.text = m_myUser.nickName;
        }
        else if ([_beSelectFlag_str isEqualToString:SELECT_REALNAME]) {
            cell.tf.placeholder = @"请输入您的真实姓名（2-5个中文字符）" ;
            cell.tf.text = m_myUser.realName;
        }
        else if ([_beSelectFlag_str isEqualToString:SELECT_MAIL]) {
            cell.tf.placeholder = @"请输入您的邮件地址" ;
            cell.tf.keyboardType = UIKeyboardTypeEmailAddress ;
            cell.tf.text = m_myUser.email ;
        }
        else if ([_beSelectFlag_str isEqualToString:SELECT_PHONE]) {
            cell.tf.placeholder = @"请输入您的电话" ;
            cell.tf.keyboardType = UIKeyboardTypeNumberPad ;
            cell.tf.text = m_myUser.phone ;
        }

        cell.tf.delegate = self ;
        [cell.tf becomeFirstResponder];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (UIView *)getEmpty
{
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = nil ;
    return back;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getEmpty] ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self getEmpty] ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_beSelectFlag_str isEqualToString:SELECT_GENDER])
    {
        for (int i = 0; i <= 1; i ++) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0] ;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:ip];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        m_myUser.sex = indexPath.row + 1 ;      // 0未知, 1男, 2女
        m_resultString = [LSCommonFunc boyGirlNum2Str:m_myUser.sex] ;

        [self updateMyINFOtoDBandServer] ;
    }
}


#pragma mark --
#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect tfFrame = textField.frame;
    int offset = tfFrame.origin.y - (self.view.frame.size.height - 300.0);
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    if (offset > 0) {
        self.view.frame = CGRectMake(0.0f, - offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"ReturnKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    
    if ([_beSelectFlag_str isEqualToString:SELECT_NICKNAME])        {
        m_myUser.nickName = textField.text;
    }
    else if ([_beSelectFlag_str isEqualToString:SELECT_REALNAME])   {
        m_myUser.realName = textField.text;
    }
    else if ([_beSelectFlag_str isEqualToString:SELECT_MAIL])       {
        m_myUser.email = textField.text;
    }
    else if ([_beSelectFlag_str isEqualToString:SELECT_PHONE])      {
        m_myUser.phone = textField.text;
    }
    
    //server update     //m_myUser
    m_resultString = textField.text ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark --
#pragma mark - Bar button Actions

- (void)saving
{
    [self updateMyINFOtoDBandServer]    ;

}

- (void)saveBirth
{
    [self updateMyINFOtoDBandServer] ;
}


#pragma mark -- 
#pragma mark - picker Action
- (void)valueChange
{
    //    NSLog(@"%@",_birthDate.date);
    
    long long t         = [MyTick getTickWithDate:_birthDate.date];
    m_myUser.birth      = t;     //  传值
    m_resultString      = [NSString stringWithFormat:@"%lld",t] ; //tick
    
    NSString *str       = [MyTick getDateWithTick:t AndWithFormart:TIME_STR_FORMAT_1];
    
    UITableViewCell *cell        = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.textLabel.text          = str;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    [_table reloadData];
}


#pragma mark --
#pragma mark - updateMyINFOtoDBandServer
- (void)updateMyINFOtoDBandServer
{
    if (!([_beSelectFlag_str isEqualToString:SELECT_GENDER] || [_beSelectFlag_str isEqualToString:SELECT_BIRTHDAY]))
    {
        WriteInfoCell *cell = (WriteInfoCell *)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
        [cell.tf resignFirstResponder] ;
    }
    
    
    BOOL success = false ;
    if ([_beSelectFlag_str isEqualToString:SELECT_NICKNAME])
    {
        success = YES ;//[Verification validateNickname:m_resultString] ;
    }else if ([_beSelectFlag_str isEqualToString:SELECT_REALNAME])
    {
        success = [Verification validateRealname:m_resultString] ;
    }
    else if ([_beSelectFlag_str isEqualToString:SELECT_MAIL])
    {
        success = [Verification validateEmail:m_resultString] ;
    }
    else if ([_beSelectFlag_str isEqualToString:SELECT_PHONE])
    {
        success = [Verification validateMobile:m_resultString] ;
    }
    else if ([_beSelectFlag_str isEqualToString:SELECT_GENDER])
    {
        success = true ;
    }
    else if ([_beSelectFlag_str isEqualToString:SELECT_BIRTHDAY])
    {
        success = (m_resultString != nil) ? YES : NO ;
    }

    
    if (!success)
    {
        [DigitInformation showWordHudWithTitle:WD_HUD_NOTFORMAT];
        
        if ([_beSelectFlag_str isEqualToString:SELECT_GENDER]) return ;
        
        return ;
    }
    

    
//  send request
    NSString *result = [ServerRequest changeUserInfoWith:m_myUser] ;
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dic = [parser objectWithString:result] ;
    if (!dic) {
        [DigitInformation showWordHudWithTitle:WD_HUD_BADNETWORK]; //AndWithController:self] ;
        return ;
    }
    int code = [[dic objectForKey:@"code"] intValue];
    NSString *info = [dic objectForKey:@"info"] ;
    if (code == 200) {
        [DigitInformation showWordHudWithTitle:info]; //AndWithController:self] ;
        [self.navigationController popViewControllerAnimated:YES] ;
    }else {
        [DigitInformation showWordHudWithTitle:info]; //AndWithController:self] ;
        return ;
    }
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

@end
