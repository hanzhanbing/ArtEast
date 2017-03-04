//
//  GoodsClassifyVC.m
//  ArtEast
//
//  Created by yibao on 2017/2/17.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "GoodsClassifyVC.h"
#import "ClassifyListVC.h"
#import "CollectionViewHeaderView.h"
#import "CollectionViewCell.h"
#import "CollectionViewHeaderCell.h"
#import "LJCollectionViewFlowLayout.h"
#import "LeftTableViewCell.h"
#import "SearchVC.h"
#import "AETypeInfo.h"

@interface GoodsClassifyVC () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate,
UICollectionViewDataSource,UISearchBarDelegate>
{
    UIView *topView;
    UISearchBar *searchBar;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *collectionDatas;

@end

@implementation GoodsClassifyVC
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    
    //搜索框
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    topView.backgroundColor = [UIColor whiteColor];
    
    searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.showsCancelButton = NO;
    if (HEIGHT==736) { //plus
        searchBar.frame = CGRectMake(15, 2, WIDTH-50, 40);
    } else {
        searchBar.frame = CGRectMake(10, 2, WIDTH-35, 40);
    }
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"有生活 才有家";
    [topView addSubview:searchBar];
    
    self.navigationItem.titleView = topView;

    _selectIndex = 0;
    _isScrollDown = YES;
    
    self.view.alpha = 0;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    
    [self getData];
}

- (void)getData {
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    [[NetworkManager sharedManager] postJSON:URL_GetVirtualCatesList parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
    
        if (status == Request_Success) {
            
            if (![Utils isBlankString:responseData]) {
                self.dataSource = [AETypeInfo mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            
                [UIView animateWithDuration:0.5 animations:^{
                    self.view.alpha = 1;
                }];
                [self.tableView reloadData];
                [self.collectionView reloadData];
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            }
        }
    }];
}

#pragma mark - UISearchBarDelegate

//跳转到搜索页面
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchVC *searchVC = [[SearchVC alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    
    return NO;
}

#pragma mark - Getters

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)collectionDatas
{
    if (!_collectionDatas)
    {
        _collectionDatas = [NSMutableArray array];
    }
    return _collectionDatas;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80, HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 55;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[LeftTableViewCell class]
           forCellReuseIdentifier:kCellIdentifier_Left];
    }
    return _tableView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //左右间距
        flowlayout.minimumInteritemSpacing = 2;
        //上下间距
        flowlayout.minimumLineSpacing = 2;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(1 + 80, 64, WIDTH - 80 - 1, HEIGHT-64-49) collectionViewLayout:flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        //注册cell
        [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_CollectionView];
        [self.collectionView registerClass:[CollectionViewHeaderCell class] forCellWithReuseIdentifier:kCellIdentifier_CollectionViewHeaderCell];
        //注册分区头标题
//        [self.collectionView registerClass:[CollectionViewHeaderView class]
//                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                       withReuseIdentifier:@"CollectionViewHeaderView"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - UITableView DataSource Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
    AETypeInfo *typeInfo = self.dataSource[indexPath.row];
    cell.name.text = typeInfo.virtual_cat_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:_selectIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    AETypeInfo *typeInfo = self.dataSource[section];
    return typeInfo.childs.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        CollectionViewHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CollectionViewHeaderCell forIndexPath:indexPath];
        AETypeInfo *typeInfo = self.dataSource[indexPath.section];
        cell.title.text = [NSString stringWithFormat:@"%@分类",typeInfo.virtual_cat_name];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:typeInfo.picture] placeholderImage:[UIImage imageNamed:@"ClassifyDefaultIcon"]];
        return cell;
    }
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CollectionView forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor redColor];
    AETypeInfo *typeInfo = self.dataSource[indexPath.section];
    AESubTypeInfo *info = typeInfo.childs[indexPath.row-1];
    cell.model = info;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return;
    }
    ClassifyListVC *classifyListVC = [[ClassifyListVC alloc] init];
    classifyListVC.hidesBottomBarWhenPushed = YES;
    AETypeInfo *typeInfo = self.dataSource[indexPath.section];
    classifyListVC.titleStr = typeInfo.virtual_cat_name;
    classifyListVC.subArr = [typeInfo.childs mutableCopy];
    classifyListVC.currentPage = (int)indexPath.row-1;
    [self.navigationController pushViewController:classifyListVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return CGSizeMake(WIDTH, (WIDTH-110)/3+30+40);
    }
    return CGSizeMake((WIDTH - 80 - 4 - 4) / 3,
                      (WIDTH - 80 - 4 - 4) / 3 + 45);
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind
//                                 atIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *reuseIdentifier;
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
//    { // header
//        reuseIdentifier = @"CollectionViewHeaderView";
//    }
//    CollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                                        withReuseIdentifier:reuseIdentifier
//                                                                               forIndexPath:indexPath];
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
//    {
//        AETypeInfo *typeInfo = self.dataSource[indexPath.section];
//        view.title.text = [NSString stringWithFormat:@"%@分类",typeInfo.virtual_cat_name];
//        [view.imageView sd_setImageWithURL:[NSURL URLWithString:typeInfo.picture] placeholderImage:[UIImage imageNamed:@"ClassifyDefaultIcon"]];
//    }
//    return view;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(WIDTH, (WIDTH-110)/3+30+40);
//}
//
//// CollectionView分区标题即将展示
//- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
//{
//    // 当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
//    if (!_isScrollDown && collectionView.dragging)
//    {
//        [self selectRowAtIndexPath:indexPath.section];
//    }
//}
//
//// CollectionView分区标题展示结束
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    // 当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
//    if (_isScrollDown && collectionView.dragging)
//    {
//        [self selectRowAtIndexPath:indexPath.section + 1];
//    }
//}

// CollectionView分区第一个cell即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    // 当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && collectionView.dragging && indexPath.row == 0)
    {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区第一个cell展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && collectionView.dragging && indexPath.row == 0)
    {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float lastOffsetY = 0;
    
    if (self.collectionView == scrollView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
