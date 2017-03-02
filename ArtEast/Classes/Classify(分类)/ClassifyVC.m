//
//  ClassifyVC.m
//  ArtEast
//
//  Created by yibao on 16/10/11.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "ClassifyVC.h"
#import <MJRefresh.h>
#import "GoodsListVC.h"
#import "GoodsListViewController.h"
#import "SearchVC.h"
#import "AEButton.h"

#define TopSPACE 10 //距离顶部距离
#define LeftSPACE 10 //距离左边距离
#define  SPACE 10 //间距

@implementation ClassifyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithCellView];
    }
    return self;
}

- (void)initWithCellView{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH/2.6)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.alpha = 0;
    [self.contentView addSubview:_imageView];

    _btnView = [[UIView alloc]initWithFrame:CGRectMake(0, _imageView.maxY+5, WIDTH, 50)];
    [self.contentView addSubview:_btnView];
}

- (void)setTypeInfo:(AETypeInfo *)typeInfo {
    DLog(@"%@",typeInfo.picture);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:typeInfo.picture] placeholderImage:[UIImage imageNamed:@"ClassifyDefaultIcon"]];
    [UIView animateWithDuration:0.5 animations:^{
        _imageView.alpha = 1;
    }];
    
    //15 距离顶部15个像素点
    CGSize size = CGSizeMake(LeftSPACE, 40+TopSPACE);
    CGFloat width = WIDTH;
    
    [_btnView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < typeInfo.childs.count; i ++) {
        AESubTypeInfo *subTypeInfo = typeInfo.childs[i];
        
        CGFloat keyWorldWidth = [Utils getSizeByString:subTypeInfo.virtual_cat_name AndFontSize:14].width;
        keyWorldWidth = keyWorldWidth +5;
        if (keyWorldWidth > width) {
            keyWorldWidth = width;
        }
        if (width - size.width < keyWorldWidth) {
            size.height += 40.0;
            size.width = LeftSPACE;
        }
        //创建 label点击事件
        AEButton *button = [[AEButton alloc]initWithFrame:CGRectMake(size.width, size.height-40, keyWorldWidth, 30)];
        button.titleLabel.numberOfLines = 0;
        button.layer.borderColor = [UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0].CGColor;
        button.layer.borderWidth = 1;
        button.cornerRadius = 2;
        [button setTitleColor:LightBlackColor forState:UIControlStateNormal];
        button.titleLabel.font = kFont14Size;
        [button setTitle:subTypeInfo.virtual_cat_name forState:UIControlStateNormal];
        [_btnView addSubview:button];
        button.idStr = subTypeInfo.virtual_cat_id;
        button.name = subTypeInfo.virtual_cat_name;
        [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        //起点 增加
        size.width += keyWorldWidth+SPACE;
    }
    _btnView.height = size.height+TopSPACE-5;
}

- (UIViewController *)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 跳转到商品列表

- (void)tagButtonClick:(AEButton *)sender{
    NSLog(@"thtyjykj%@  %@",sender.idStr,sender.name);
    //GoodsListVC *goodsListVC = [[GoodsListVC alloc] init];
    GoodsListViewController *goodsListVC = [[GoodsListViewController alloc] init];
    goodsListVC.hidesBottomBarWhenPushed = YES;
    goodsListVC.virtual_cat_id = sender.idStr;
    goodsListVC.virtual_cat_name = sender.name;
    [[self viewController].navigationController pushViewController:goodsListVC animated:YES];
}

@end


@interface ClassifyVC ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate>
{
    NSMutableArray *_dataSource;
    DefaultView *_defaultView;
}
@end

@implementation ClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分类";
    
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    self.navItem.rightBarButtonItem = searchBarButtonItem;
    
    [self initView];
    [self getData];
    [self blankView];
}

//有网络了
- (void)netWorkAppear
{
    [super netWorkAppear];
    
    [self refresh];
}

//无网
- (void)blankView {
    _defaultView = [[DefaultView alloc] initWithFrame:self.tableFrame];
    _defaultView.delegate = self;
    _defaultView.hidden = YES;
    [self.view addSubview:_defaultView];
}

#pragma mark - RefreshDelegate

- (void)refresh {
    NSLog(@"点击刷新");
    self.tableView.hidden = NO;
    _defaultView.hidden = YES;
    [self getData];
}

- (void)getData {
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    [[NetworkManager sharedManager] postJSON:URL_GetVirtualCatesList parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        [self.tableView.mj_header endRefreshing];
        
        if (status == Request_Success) {
            //[Utils showToast:@"获取虚拟分类列表成功"];
            
            if ([Utils isBlankString:responseData]) {
                self.tableView.hidden = YES;
                _defaultView.hidden = NO;
                _defaultView.delegate = nil;
                _defaultView.imgView.image = [UIImage imageNamed:@""];
                _defaultView.lab.text = @"还没有任何分类呢";
            } else {
                _dataSource = [AETypeInfo mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
                [self.tableView reloadData];
            }
        } else {
            if (![Utils getNetStatus]) {
                self.tableView.hidden = YES;
                _defaultView.hidden = NO;
                _defaultView.delegate = self;
                _defaultView.imgView.image = [UIImage imageNamed:@"NoNetwork"];
                _defaultView.lab.text = @"网络状态待提升，点击重试";
            }
        }
    }];
}

- (CGFloat)getHeight:(NSArray *)nameArray{
    //第一个 label的起点
    CGSize size = CGSizeMake(LeftSPACE, 30);

    CGFloat width = [UIScreen                                                                       mainScreen].bounds.size.width;
    for (int i = 0; i < nameArray.count; i ++) {
        
        AESubTypeInfo *subTypeInfo = nameArray[i];
        CGFloat keyWorldWidth = [Utils getSizeByString:subTypeInfo.virtual_cat_name AndFontSize:14].width;
        keyWorldWidth = keyWorldWidth +5;
        if (keyWorldWidth > width) {
            keyWorldWidth = width;
        }
        if (width - size.width < keyWorldWidth) {
            size.height += 40.0;
            size.width = LeftSPACE;
        }
         size.width += keyWorldWidth+SPACE;
    }
    return MAX(30, size.height);
}

- (void)initView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //动画下拉刷新
    [self tableViewGifHeaderWithRefreshingBlock:^{
        [self refresh];
    }];
}

#pragma mark - 搜索
- (void)searchAction {
    DLog(@"搜索");
    SearchVC *searchVC = [[SearchVC alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassifyCellID"];
    if (!cell) {
        cell = [[ClassifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ClassifyCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    AETypeInfo *typeInfo = _dataSource[indexPath.section];
    cell.typeInfo = typeInfo;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AETypeInfo *typeInfo = _dataSource[indexPath.section];
    if (typeInfo.childs.count>0) {
        return [self getHeight:typeInfo.childs]+WIDTH/2.6+TopSPACE*3;
    } else {
        return WIDTH/2.6;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
