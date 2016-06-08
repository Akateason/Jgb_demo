//
//  DetailSubController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-1.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "DetailSubController.h"
#import "HMSegmentedControl.h"
#import "WebViewCell.h"
#import "GoodsCommentCell.h"
#import "ServerRequest.h"
#import "ResultPasel.h"
#import "Comment.h"
#import "CommentAlertCell.h"
#import "WebLoadCell.h"


@interface DetailSubController ()<HMSegmentedControlDelegate,WebViewCellDelegate,GoodsCommentCellDelegate,WebLoadCellDelegate>
{
    HMSegmentedControl  *m_sg;
    
    NSMutableArray      *m_arr_queue ;
    
    NSString            *m_html ;
    
    float               m_desciptionHeight ;
    float               m_webLoadCellHeight ;

    BOOL                m_bFirst ;
    BOOL                m_bFirst2 ;

    NSMutableArray      *m_listComment ;
    
    ModeDetailSub       m_modeDetailSub ;
}

@property (nonatomic) int commentNum ;  //此商品的评论数量

@property (nonatomic) BOOL hasSize ;    //是否有尺码

@end

@implementation DetailSubController


#define H5              @"<!doctype html>"

#define CSSSTR          @"<style type='text/css'>*{ max-width: 100%; font-size:13px; padding-bottom:20px; font-family:'Heiti SC','Microsoft Yahei'; color:#3c3c3c ;}</style>"

#define SCRIPTSTR       @"<script type='text/javascript'>window.onload = function () {var every = document.getElementsByTagName('*');for (var i = 0; i < every.length; i++) {if (every[i].style.backgroundImage != '') {every[i].style.backgroundSize = '100%';}}};</script>"

#define HTML_BR         @"</br>"


#define TABHEIGHT           35.0f

#define TABLEHEADHEIGHT     40.0f

- (void)parselDescriptionHtml
{
    NSString *descrip = @"" ;
    descrip = (_currentGood.descriptionHtml == nil) ? @"" : (_currentGood.descriptionHtml) ;    //  descriptionHtml
    NSString *descripCN = (_currentGood.description_cn == nil) ? @"" : _currentGood.description_cn ;
    
    NSString *descripResult = [descripCN stringByAppendingString:descrip] ; //[descripCN isEqualToString:@""] ? descrip : descripCN ;
    
    
    NSString *strVideo = @"" ;
    if (_currentGood.vod != nil && [_currentGood.vod count])
    {
        NSString *video = [_currentGood.vod firstObject] ;
        strVideo = [NSString stringWithFormat:@"<video controls='controls' autoplay='autoplay'> <source src='%@' type='video/ogg' /> <source src='%@' type='video/mp4'/> </video>",video,video] ;
    }
    
    NSString *html      = [NSString stringWithFormat:@"%@%@%@%@%@%@",H5,CSSSTR,SCRIPTSTR,strVideo,descripResult,HTML_BR] ;
    
    m_html              = html ;
}

- (void)setCommentNum:(int)commentNum
{
    _commentNum = commentNum ;
    
//  set segment view
    if (self.hasSize)
    {
        //有尺码
        m_arr_queue = [NSMutableArray arrayWithArray:@[@"商品详情", @"尺码说明", [NSString stringWithFormat:@"用户评论(%d)",_commentNum]]] ;
    }
    else
    {
        //无尺码
        m_arr_queue = [NSMutableArray arrayWithArray:@[@"商品详情", [NSString stringWithFormat:@"用户评论(%d)",_commentNum]]] ;
    }
    
//  set bg
    UIImage *image = (!commentNum) ? [UIImage imageNamed:@"noComment"] : nil ;
    [self setBackground:image] ;

//  reload table
    [self.tableView reloadData] ;
    
}

- (void)setBackground:(UIImage *)image
{
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    imgV.image = image ;
    imgV.contentMode = UIViewContentModeScaleAspectFit ;
    [self.tableView setBackgroundView:imgV] ;
}

- (BOOL)hasSize
{
    return (!_currentGood.size_url) ? NO : YES ;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_bFirst    = YES ;
    m_bFirst2   = YES ;
    
    m_listComment = [NSMutableArray array] ;
    
    m_modeDetailSub = DetailMode ;
    
    self.tableView.backgroundColor = COLOR_BACKGROUND ;
    
    self.commentNum = 0 ;
    
    [self parselDescriptionHtml] ;
    
    m_desciptionHeight  = APPFRAME.size.height - TABHEIGHT ;
    m_webLoadCellHeight = APPFRAME.size.height - TABHEIGHT + 12 ;

    [self.tableView reloadData] ;
    
    dispatch_queue_t queue = dispatch_queue_create("oneCommentQueue", NULL) ;
    dispatch_async(queue, ^{
        
        ResultPasel *result = [ServerRequest getProductCommentListWithProCode:_currentGood.code AndWithPage:1 AndWithSize:5 AndWithScore:nil] ;
        
        if (result.code == 200)
        {
            if ( (result.data == nil) || ([result.data isKindOfClass:[NSNull class]]) || (result.data == NULL) ) return ;
            
            self.commentNum = [((NSArray *)result.data) count];
            
            for (NSDictionary *dic in ((NSArray *)result.data))
            {
                Comment *tempComment = [[Comment alloc] initWithDictionary:dic] ;
                [m_listComment addObject:tempComment] ;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData] ;
            }) ;
        }
        
    }) ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
}

#pragma mark --
#pragma mark - WebViewCellDelegate
- (void)sendDescriptionHeight:(int)height
{
    m_desciptionHeight = height ;
    
    NSLog(@"m_desciptionHeight : %f",m_desciptionHeight) ;
    
    [self.tableView reloadData] ;
}

#pragma mark --
#pragma mark - WebLoadCellDelegate
- (void)setWebLoadCellHeight:(int)height
{
    m_webLoadCellHeight = height ;
    
    NSLog(@"m_webLoadCellHeight : %f",m_desciptionHeight) ;

    [self.tableView reloadData] ;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0)
    {   //height flex
        return 0 ;
    }

    switch (m_modeDetailSub)
    {
        case DetailMode:
        {
            //height flex
            return 1 ;
        }
            break;
        case SizeMode:
        {
            //height flex
            return 1 ;
        }
            break;
        case CommentMode:
        {
            return [m_listComment count] + 1 + 1 ; // + 头 10高   + 尾巴,高度补齐整个屏幕
        }
            break;
        default:
            break;
    }
    
    return 0 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row     = indexPath.row ;
    int section = indexPath.section ;
    
    if (section == 1)
    {
        float resultFlt ;
        
        switch (m_modeDetailSub)
        {
            case DetailMode:
            {
                //height flex
                resultFlt = m_desciptionHeight ;
            }
                break;
            case SizeMode:
            {
                //height flex
                resultFlt = m_webLoadCellHeight ;
            }
                break;
            case CommentMode:
            {
                if ( (!m_listComment.count || !m_listComment) )
                {
                    //无评价
                    resultFlt =  1.0f ;
                }
                else
                {
                    //有评价
                    //第一行
                    if (!row)
                    {
                        resultFlt = 10.0f ;
                        break ;
                    }
                    //最后一行
                    else if (row == [m_listComment count] + 1)
                    {
                        float fltAllHeight = 0 ; //评论总高度 ;
                        for (int i = 0 ; i < [m_listComment count] ; i++)
                        {
                            fltAllHeight += [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:1]] ;
                        }
                        
                        resultFlt = APPFRAME.size.height - fltAllHeight - TABHEIGHT - TABLEHEADHEIGHT ;
                        
                        if (resultFlt <= 0)
                        {
                            resultFlt = 0 ;
                        }
                        
                        break ;
                    }
                    
                    //评论行
                    float cellOrgHeight = 90.0f ;
                    float lbOrgHeight   = 15.0f ;
                    
                    NSString *commentStr = ((Comment *)[m_listComment objectAtIndex:row - 1]).message ;
                    UIFont *font    = [UIFont systemFontOfSize:12] ;
                    CGSize size     = CGSizeMake(230,200) ;
                    CGSize labelsize = [commentStr sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
                    float h = cellOrgHeight - lbOrgHeight + labelsize.height ;
                    
                    resultFlt = h ;
                }

            }
                break;
            default:
                break;
        }
        
        return resultFlt ;
    }
    
    return 1.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row     = indexPath.row     ;
    int section = indexPath.section ;

    if (section == 1)
    {
        switch (m_modeDetailSub)
        {
            case DetailMode:
            {
                static NSString *TableSampleIdentifier = @"WebViewCell";
                WebViewCell *cell = (WebViewCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
                if (cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0] ;
                }
                
                cell.html = m_html ;
                cell.webView.allowsInlineMediaPlayback = YES;

                if (m_bFirst)
                {
                    cell.delegate = self ;
                    cell.webHeight.constant = APPFRAME.size.height - TABLEHEADHEIGHT ;
                    [cell refresh] ;
                    m_bFirst = NO ;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                
                return cell ;
            }
                break;
                
            case SizeMode:
            {
                //height flex
                static NSString *TableSampleIdentifier = @"WebLoadCell";
                WebLoadCell *cell = (WebLoadCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
                if (cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0] ;
                }
                
                cell.html = _currentGood.size_url ;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                
                if (m_bFirst2) {
                    cell.delegate = self ;
                    cell.webHeight.constant = APPFRAME.size.height - TABLEHEADHEIGHT ;
                    [cell refresh] ;
                    m_bFirst2 = NO ;
                }
                
                return cell ;
            }
                break;
                
            case CommentMode:
            {
                if ( (![m_listComment count]) || (!m_listComment) )
                {//无评论
                    /* 点击去评论
                     static NSString *identifierGoodCell = @"CommentAlertCell";
                     CommentAlertCell *cell = (CommentAlertCell *)[tableView dequeueReusableCellWithIdentifier:identifierGoodCell];
                     if (cell == nil)
                     {
                     cell = [[[NSBundle mainBundle] loadNibNamed:identifierGoodCell owner:self options:nil] objectAtIndex:0] ;
                     }
                     cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                     
                     return cell ;
                     */
                    return [self getNoneCellWithTable:tableView] ;
                }
                else
                {//有评论
                    if (!row)
                    {
                    //第一行
                        return [self getNoneCellWithTable:tableView] ;
                    }
                    //最后一行
                    else if (row == [m_listComment count] + 1)
                    {
                        return [self getNoneCellWithTable:tableView] ;
                    }
                    
                    //非第一行
                    static NSString *identifierGoodCell = @"GoodsCommentCell";
                    GoodsCommentCell *cell = (GoodsCommentCell *)[tableView dequeueReusableCellWithIdentifier:identifierGoodCell];
                    if (cell == nil)
                    {
                        cell = [[[NSBundle mainBundle] loadNibNamed:identifierGoodCell owner:self options:nil] objectAtIndex:0] ;
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
                    cell.delegate = self ;
                    cell.comment = (Comment *)m_listComment[row - 1] ;
                    
                    return cell;
                }
            }
                break;
            default:
                break;
        }
        
    }
    
    return nil ;
}


- (UITableViewCell *)getNoneCellWithTable:(UITableView *)tableView
{
    static NSString *noneCell = @"noneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noneCell];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noneCell] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.contentView.backgroundColor = nil ;
    cell.backgroundColor = COLOR_BACKGROUND ;
    
    return cell ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
    {   //height flex
        return [self getClearView] ;
    }
    else if (section == 1)
    {
        //详情\评论
        if (!m_sg)
        {
            m_sg = [[HMSegmentedControl alloc] init];
        }
        m_sg.sectionTitles = m_arr_queue;

        m_sg.delegate = self ;
        m_sg.height = TABHEIGHT ;   //
        [m_sg setSelectionIndicatorHeight:4.0f];
        [m_sg setBackgroundColor:[UIColor whiteColor]];
        [m_sg setTextColor:COLOR_PINK];
        [m_sg setSelectionIndicatorColor:COLOR_PINK];
        [m_sg setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
        [m_sg setSegmentEdgeInset:UIEdgeInsetsMake(0, 6, 0, 6)];
        [m_sg setFont:[UIFont boldSystemFontOfSize:12.0f]] ;
        [m_sg addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged] ;
        
        m_sg.frame = CGRectMake(0, 20, m_sg.frame.size.width, m_sg.frame.size.height) ;
        
        return m_sg;
    }
    
    return [self getClearView] ;

}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        //height flex
        return 10.0f ;
    }
    else if (section == 1)
    {
        //tab   详情\评论
        return TABHEIGHT ;
    }
    
    return 1.0f ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    if ( (m_modeDetailSub == CommentMode) && (m_listComment.count) && (section > 0) )
    {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,TABLEHEADHEIGHT)] ;
        baseView.backgroundColor = [UIColor whiteColor] ;
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [bt setTitle:@"查看评论详情" forState:UIControlStateNormal] ;
        [bt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal] ;
        [bt setFont:[UIFont systemFontOfSize:12.0f]] ;
        [bt addTarget:self action:@selector(seeMoreCommentCallBack) forControlEvents:UIControlEventTouchUpInside] ;
        [bt setFrame:baseView.frame] ;
        [baseView addSubview:bt] ;
        
        UIView *upline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)] ;
        upline.backgroundColor = COLOR_BACKGROUND ;
        [baseView addSubview:upline] ;
        
        return baseView ;
    }
    
    return [self getClearView] ;
}

- (UIView *)getClearView
{
    UIView *back = [[UIView alloc] init] ;
    back.backgroundColor = nil; //[UIColor clearColor] ;
    return back ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( (m_modeDetailSub == CommentMode) && (m_listComment.count) && (section > 0) ) return TABLEHEADHEIGHT ;
    
    return 1.0f ;
}


#pragma mark -- ** theSelectedSegment ** --
- (void)theSelectedSegment:(int)seg
{
    if (!self.hasSize)
    {
        //无尺码
        if (seg == SizeMode) {
            seg = CommentMode ;
        }
    }

    switch (seg) {
        case DetailMode:
        {
            m_modeDetailSub = DetailMode ;
        }
            break;
        case SizeMode:
        {
            m_modeDetailSub = SizeMode ;
        }
            break;
        case CommentMode:
        {
            if ( (![m_listComment count]) || (!m_listComment) ) return ; // 无评论
            
            m_modeDetailSub = CommentMode ;
        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData] ;
}


#pragma mark --
#pragma - HMSegmentedControlDelegate sendCurrentIndex ↑↓
#pragma mark - seg value changed
- (void)valueChanged
{
    [self theSelectedSegment:m_sg.selectedIndex]            ;
    NSLog(@"m_sg.selectedIndex : %d",m_sg.selectedIndex )   ;
}

- (void)sendCurrentIndexEveryPressed:(int)seg
{
    
}

#pragma mark --
#pragma mark - action
- (void)seeMoreCommentCallBack
{
    [self.delegate seeMoreCommment] ;
}



#pragma mark --
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
