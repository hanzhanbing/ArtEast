//
//  SearchVC.m
//  ArtEast
//
//  Created by yibao on 16/10/20.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "SearchVC.h"
#import "GoodsListVC.h"
#import "AEButton.h"
#import "AEFlowLayoutView.h"

#define TopSPACE 10 //距离顶部距离
#define LeftSPACE 15 //距离左边距离
#define  SPACE 15 //间距

@interface SearchVC ()<UISearchBarDelegate,AEFlowLayoutViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UISearchBar *_searchBar;
    UIView *_historyView; //历史记录
    UIView *_grayBg; //灰色分割区域
    UIView *_hotView; //热门搜索
    NSMutableArray *_fuzzyArr;
    NSMutableArray *_hotArr;
    NSMutableArray *_historyArr;
    NSUserDefaults *defaults;
    AEFlowLayoutView *_hisFlowView;
    AEFlowLayoutView *_hotFlowView;
}
@end

@implementation SearchVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.hidden = YES;
    [_searchBar becomeFirstResponder];
    
    _historyArr = [[[NSSet setWithArray:[defaults objectForKey:@"searchHisArr"]] allObjects] mutableCopy];
    _hisFlowView.array = _historyArr;
    
    if (_historyArr.count==0) {
        _historyView.hidden = YES;
        _hotView.y = 64;
    } else {
        _historyView.hidden = NO;
        _hotView.y = _historyView.maxY;
    }
    
    _grayBg.y = _hisFlowView.maxY;
    _historyView.height = _grayBg.maxY;
    _hotView.y = _historyView.maxY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    defaults = [NSUserDefaults standardUserDefaults];
    _fuzzyArr = [NSMutableArray array];
    _hotArr = [NSMutableArray array];
    _historyArr = [NSMutableArray array];
    
    self.navItem.leftBarButtonItem = nil;
    
    //搜索框
    _searchBar = [[UISearchBar alloc] init];
    [self showCancelBtn];
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.placeholder = @"有生活 才有家";
    [self.navBar addSubview: _searchBar];
    
    [self getData];
}

#pragma mark - init data

- (void)getData {
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    [[NetworkManager sharedManager] postJSON:URL_GetHotKeywords parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            NSArray *items = responseData[@"items"];
            for (NSDictionary *keyDic in items) {
                [_hotArr addObject:keyDic[@"kw_name"]];
            }
        }
        
        [self initView];
    }];
}

#pragma mark - init view

- (void)initView {
    
    //历史记录
    _historyView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 50)];
    [self.view addSubview:_historyView];
    
    UILabel *historyLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 100, 20)];
    historyLab.text = @"历史记录";
    historyLab.font = [UIFont systemFontOfSize:14];
    historyLab.textColor = [UIColor grayColor];
    [_historyView addSubview:historyLab];
    
    UIButton *deleteHisBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-35, 15, 22, 22)];
    [deleteHisBtn setImage:[UIImage imageNamed:@"Delete"] forState:UIControlStateNormal];
    [_historyView addSubview:deleteHisBtn];
    UIButton *clickDeleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-45, 10, 40, 40)];
    clickDeleteBtn.backgroundColor = [UIColor clearColor];
    [clickDeleteBtn addTarget:self action:@selector(clearSearchHis) forControlEvents:UIControlEventTouchUpInside];
    [_historyView addSubview:clickDeleteBtn];
    
    _hisFlowView = [[AEFlowLayoutView alloc] initWithFrame:CGRectMake(0, historyLab.maxY, WIDTH, 0)]; //高度由内容定
    _hisFlowView.array = [[[NSSet setWithArray:[defaults objectForKey:@"searchHisArr"]] allObjects] mutableCopy];;
    _hisFlowView.delegate = self;
    [_historyView addSubview:_hisFlowView];
    
    _grayBg = [[UIView alloc] initWithFrame:CGRectMake(0, _hisFlowView.maxY, WIDTH, 10)];
    _grayBg.backgroundColor = PageColor;
    [_historyView addSubview:_grayBg];
    
    _historyView.height = _grayBg.maxY;
    
    //热门搜索
    _hotView = [[UIView alloc] initWithFrame:CGRectMake(0, _historyView.maxY, WIDTH, 50)];
    [self.view addSubview:_hotView];
    
    UILabel *hotLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 100, 20)];
    hotLab.text = @"热门搜索";
    hotLab.font = [UIFont systemFontOfSize:14];
    hotLab.textColor = [UIColor grayColor];
    [_hotView addSubview:hotLab];
    
    _hotFlowView = [[AEFlowLayoutView alloc] initWithFrame:CGRectMake(0, hotLab.maxY, WIDTH, 50)]; //高度由内容定
    _hotFlowView.array = _hotArr;
    _hotFlowView.delegate = self;
    [_hotView addSubview:_hotFlowView];
    
    _hotView.height = _hotFlowView.maxY;
    
    if (_historyArr.count==0) {
        _historyView.hidden = YES;
        _hotView.y = 64;
    } else {
        _historyView.hidden = NO;
        _hotView.y = _historyView.maxY;
    }
    
    if (_hotArr.count==0) {
        _hotView.hidden = YES;
    } else {
        _hotView.hidden = NO;
    }
    
    //模糊搜索列表
    self.tableView = [[UITableView alloc] initWithFrame:self.tableFrame style:UITableViewStylePlain];
    self.tableView.hidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] init]; //不显示没内容的cell
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - 清空搜索历史

- (void)clearSearchHis {
    [_historyArr removeAllObjects];
    [defaults removeObjectForKey:@"searchHisArr"];
    _historyView.hidden = YES;
    _hotView.y = 64;
}

#pragma mark - 显示/隐藏取消按钮

//显示取消按钮
- (void)showCancelBtn {
    _searchBar.showsCancelButton = YES;
    _searchBar.frame = CGRectMake(16, 22, WIDTH-20, 40);
    //修改取消按钮样式
    for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        }
    }
}

//隐藏取消按钮
- (void)hideCancelBtn {
//    _searchBar.showsCancelButton = NO;
//    [_searchBar resignFirstResponder];
//    _searchBar.frame = CGRectMake(16, 22, WIDTH-30, 40);
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self showCancelBtn];
    return YES;
}

//点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self hideCancelBtn];
    //将搜索的关键字加入到搜索历史数组中
    [_historyArr addObject:searchBar.text];
    [defaults setObject:_historyArr forKey:@"searchHisArr"];
    
    [self.view endEditing:YES];
    GoodsListVC *goodsListVC = [[GoodsListVC alloc] init];
    goodsListVC.search_content = searchBar.text;
    goodsListVC.virtual_cat_name = searchBar.text;
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

//点击取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self hideCancelBtn];
    [self.navigationController popViewControllerAnimated:YES];
}

//模糊搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0) {
        self.tableView.hidden = NO;
        
        [_fuzzyArr removeAllObjects];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             searchText, @"words",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_FuzzySearch parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                if ([responseData isKindOfClass:[NSArray class]]) {
                    NSArray *arr = (NSArray *)responseData;
                    if (arr.count>0) {
                        for (NSDictionary *keyDic in arr) {
                            [_fuzzyArr addObject:keyDic[@"keyword"]];
                        }
                    }
                }
            }
            
            [self.tableView reloadData];
        }];
    } else {
        self.tableView.hidden = YES;
    }
}

#pragma mark - AEFlowLayoutViewDelegate
//跳转到商品列表
- (void)clickFlowLayout:(AEButton *)sender {
    NSLog(@"%@  %@",sender.idStr,sender.name);
    [self hideCancelBtn];
    //将搜索的关键字加入到搜索历史数组中
    [_historyArr addObject:sender.name];
    [defaults setObject:_historyArr forKey:@"searchHisArr"];
    
    [self.view endEditing:YES];
    GoodsListVC *goodsListVC = [[GoodsListVC alloc] init];
    goodsListVC.hidesBottomBarWhenPushed = YES;
    goodsListVC.search_content = sender.name;
    goodsListVC.virtual_cat_name = sender.name;
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_fuzzyArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FuzzySearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        UIView *selectedView = [[UIView alloc] init];
        selectedView.backgroundColor = PageColor;
        cell.selectedBackgroundView = selectedView;
    }
    NSString *nameStr = [_fuzzyArr objectAtIndex:indexPath.row];
    cell.textLabel.text = nameStr;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *nameStr = [_fuzzyArr objectAtIndex:indexPath.row];
    
    [self hideCancelBtn];
    //将搜索的关键字加入到搜索历史数组中
    [_historyArr addObject:nameStr];
    [defaults setObject:_historyArr forKey:@"searchHisArr"];
    
    [self.view endEditing:YES];
    GoodsListVC *goodsListVC = [[GoodsListVC alloc] init];
    goodsListVC.search_content = nameStr;
    goodsListVC.virtual_cat_name = nameStr;
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
