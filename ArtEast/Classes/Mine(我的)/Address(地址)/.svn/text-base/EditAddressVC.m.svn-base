//
//  EditAddressVC.m
//  ArtEast
//
//  Created by zyl on 16/12/26.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "EditAddressVC.h"
#import "AEPickerView.h"
#import "ProvinceModel.h"
#import "AESegment.h"
#import "AEPageView.h"
#import "OrderConfirmVC.h"

#define FirstComponent 0
#define SubComponent 1
#define ThirdComponent 2

@interface EditAddressVC ()<AESegmentDelegate,AEPageViewDataSource,AEPageViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_nameTF; //姓名
    UITextField *_phoneTF; //手机号
    UITextField *_provinceTF; //省份
    UITextField *_detailTF; //详细地址
    UIButton    *_defaultBtn; //默认地址按钮
    UIButton    *_provinceBtn;
    
    ProvinceModel *_provinceModel;
    ProvinceModel *_cityModel;
    ProvinceModel *_countyModel;
    
    AEPageView *_pageView;
    AESegment *_segment;
    UIButton *_confirmBtn;
    NSMutableArray *_addressArr;
}

@property (nonatomic,retain) UIView *bgView; //背景视图
@property (nonatomic,retain) UIView *popView; //省市区视图

@property (nonatomic,retain) UITableView *provinceTab;
@property (nonatomic,retain) UITableView *cityTab;
@property (nonatomic,retain) UITableView *countyTab;

@property (nonatomic,retain) NSMutableArray *provinceArr;
@property (nonatomic,retain) NSMutableArray *cityArr;
@property (nonatomic,retain) NSMutableArray *countyArr;

@end

@implementation EditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([Utils isBlankString:self.addressModel.addr_id]) {
        self.title = @"新建地址";
    } else {
        self.title = @"编辑地址";
    }
    
    _provinceModel = [[ProvinceModel alloc] init];
    _cityModel = [[ProvinceModel alloc] init];
    _countyModel = [[ProvinceModel alloc] init];
    _addressArr = [[NSMutableArray alloc] initWithObjects:@"省份",@"城市",@"区县", nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"CityCountyCount"]; //默认2个
    
    [self initView]; //初始化视图
    [self initPopView]; //弹出省市区视图
    [self getData]; //获取数据
}

#pragma mark - init data

- (void)getData {
    //获取省列表
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_GetProvinceList parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            _provinceArr = [ProvinceModel mj_objectArrayWithKeyValuesArray:responseData];
            [self.provinceTab reloadData];
        }
    }];
}

#pragma mark - init view

- (void)initView {
    
    UIButton *navRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 80, 44)];
    [navRightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:LightBlackColor forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = kFont16Size;
    navRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [navRightBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
    
    //姓名
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 64, WIDTH-30, 50)];
    [_nameTF becomeFirstResponder];
    _nameTF.textColor = LightBlackColor;
    _nameTF.placeholder = @"姓名";
    [_nameTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _nameTF.font = kFont14Size;
    [self.view addSubview:_nameTF];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, _nameTF.maxY-0.5, WIDTH-15, 0.5)];
    line1.backgroundColor = LineColor;
    line1.alpha = 0.4;
    [self.view addSubview:line1];
    
    //手机号
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(15, line1.maxY, WIDTH-30, 50)];
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    _phoneTF.textColor = LightBlackColor;
    _phoneTF.placeholder = @"手机号码";
    [_phoneTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTF.font = kFont14Size;
    [self.view addSubview:_phoneTF];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, _phoneTF.maxY-0.5, WIDTH-15, 0.5)];
    line2.backgroundColor = LineColor;
    line2.alpha = 0.4;
    [self.view addSubview:line2];
    
    //省份
    _provinceTF = [[UITextField alloc] initWithFrame:CGRectMake(15, line2.maxY, WIDTH-30, 50)];
    _provinceTF.textColor = LightBlackColor;
    _provinceTF.placeholder = @"省份、城市、区县";
    [_provinceTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _provinceTF.font = kFont14Size;
    [self.view addSubview:_provinceTF];
    
    _provinceBtn = [[UIButton alloc] initWithFrame:_provinceTF.frame];
    [_provinceBtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_provinceBtn];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(15, _provinceTF.maxY-0.5, WIDTH-15, 0.5)];
    line3.backgroundColor = LineColor;
    line3.alpha = 0.4;
    [self.view addSubview:line3];
    
    //详细地址
    _detailTF = [[UITextField alloc] initWithFrame:CGRectMake(15, line3.maxY, WIDTH-30, 50)];
    _detailTF.textColor = LightBlackColor;
    _detailTF.placeholder = @"详细地址，如街道、楼牌号等";
    [_detailTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _detailTF.font = kFont14Size;
    [self.view addSubview:_detailTF];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(15, _detailTF.maxY-0.5, WIDTH-15, 0.5)];
    line4.backgroundColor = LineColor;
    line4.alpha = 0.4;
    [self.view addSubview:line4];
    
    //设为默认地址
    _defaultBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _defaultBtn.frame=CGRectMake(WIDTH/2-55, line4.maxY+20, 15, 15);
    [_defaultBtn setBackgroundImage:[UIImage imageNamed:@"UnSelected"] forState:UIControlStateNormal];
    [_defaultBtn setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    _defaultBtn.userInteractionEnabled = NO;
    [self.view addSubview:_defaultBtn];
    UIButton *clickDefault = [[UIButton alloc] initWithFrame:CGRectMake(_defaultBtn.x-15, line4.maxY+5, 50, 50)];
    [clickDefault addTarget:self action:@selector(chickDefault) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickDefault];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(_defaultBtn.maxX+5, line4.maxY+20, 90, 16)];
    lab.text=@"设为默认地址";
    lab.font=kFont14Size;
    lab.textColor=PlaceHolderColor;
    [self.view addSubview:lab];
    
    if (![Utils isBlankString:self.addressModel.name]) {
        _nameTF.text = _addressModel.name;
        _phoneTF.text = _addressModel.mobile;
        NSArray *areaArr = [NSArray array];
        NSArray *arr0 = [_addressModel.area componentsSeparatedByString:@":"];
        if (arr0.count>1) {
            NSString *areaInfo = arr0[1];
            areaArr = [areaInfo componentsSeparatedByString:@"/"];
        }
        _provinceModel.local_name = areaArr[0];
        _cityModel.local_name = areaArr[1];
        _countyModel.local_name = areaArr[2];
        _countyModel.region_id = arr0[2];
        
        _provinceTF.text = _provinceTF.text = [NSString stringWithFormat:@"%@、%@、%@",_provinceModel.local_name,_cityModel.local_name,_countyModel.local_name];
        _detailTF.text = _addressModel.addr;
        
        if ([_addressModel.def_addr isEqualToString:@"1"]) {
            _defaultBtn.selected = YES;
        } else {
            _defaultBtn.selected = NO;
        }
    }
}

#pragma mark - 省市区

- (void)initPopView {
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _bgView.alpha = 0;
    _bgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-HEIGHT/2-44)];
    [_bgView addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [view addGestureRecognizer:tap];
    
    _popView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, HEIGHT/2+44)];
    _popView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:self.popView];
    
    //选择器
    _segment = [[AESegment alloc] initWithFrame:CGRectMake(0, 0, WIDTH-50, 44)];
    _segment.textFont = kFont14Size;
    [_segment updateChannels:_addressArr andIndex:0];
    _segment.delegate = self;
    [_popView addSubview:_segment];
    
    _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-50, 0, 44, 44)];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _confirmBtn.titleLabel.font = kFont14Size;
    [_confirmBtn addTarget:self action:@selector(selectConfrim) forControlEvents:UIControlEventTouchUpInside];
    [_popView addSubview:_confirmBtn];
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segment.frame), WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [_popView addSubview:lineView];
    
    //数据源
    _pageView =[[AEPageView alloc] initWithFrame:CGRectMake(0, 44.5, WIDTH, HEIGHT/2)];
    _pageView.datasource = self;
    _pageView.delegate = self;
    [_pageView reloadData];
    [_pageView changeToItemAtIndex:0];
    [_popView addSubview:_pageView];
}

#pragma mark - 视图显示
-(void)show
{
    [self.view endEditing:YES]; //结束编辑
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 1;
        CGRect frame = _popView.frame;
        frame.origin.y -= HEIGHT/2+44;
        _popView.frame = frame;
    }];
}

#pragma mark - 视图隐藏
-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _bgView.alpha = 0;
        CGRect frame = _popView.frame;
        frame.origin.y = HEIGHT;
        _popView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - AEPageViewDataSource
-(NSInteger)numberOfItemInAEPageView:(AEPageView *)pageView{
    return 3;
}

-(UIView*)pageView:(AEPageView *)pageView viewAtIndex:(NSInteger)index{
    
    UITableView *tableView;
    
    if (index==0) {
        self.provinceTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView = self.provinceTab;
    } else if (index==1) {
        self.cityTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView = self.cityTab;
    } else {
        self.countyTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView = self.countyTab;
    }
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    
    return tableView;
}

#pragma mark - UITableViewDelegate、UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.provinceTab) {
        return _provinceArr.count;
    } else if (tableView==self.cityTab) {
        return _cityArr.count;
    } else {
        return _countyArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    ProvinceModel *model;
    if (tableView==self.provinceTab) {
        model = _provinceArr[indexPath.row];
    } else if (tableView==self.cityTab) {
        model = _cityArr[indexPath.row];
    } else {
        model = _countyArr[indexPath.row];
    }
    cell.textLabel.text = model.local_name;
    cell.textLabel.font = kFont14Size;
    
    if (model.isSelected==YES) {
        cell.textLabel.textColor = AppThemeColor;
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选择状态
    
    if (tableView==self.provinceTab) { //省份
        
        for (int i=0; i<_provinceArr.count; i++) {
            ProvinceModel *model = _provinceArr[i];
            if (i==indexPath.row) {
                model.isSelected = YES;
                _provinceModel = model;
                _cityModel = nil;
                _countyModel = nil;
                [_cityArr removeAllObjects];
                [_countyArr removeAllObjects];
                [self.cityTab reloadData];
                [self.countyTab reloadData];
                [_addressArr replaceObjectAtIndex:0 withObject:_provinceModel.local_name];
                [_addressArr replaceObjectAtIndex:1 withObject:@"城市"];
                [_addressArr replaceObjectAtIndex:2 withObject:@"区县"];
                _confirmBtn.selected = NO;
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"CityCountyCount"]; //默认2个
            } else {
                model.isSelected = NO;
            }
        }
        
        [self.provinceTab reloadData];
        [_segment updateChannels:_addressArr andIndex:0];
        
        //根据省ID获取市
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _provinceModel.region_id, @"regionID",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_GetRegionsByID parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                _cityArr = [ProvinceModel mj_objectArrayWithKeyValuesArray:responseData];
                [_segment updateChannels:_addressArr andIndex:1];
                [_pageView changeToItemAtIndex:1];
                [self.cityTab reloadData];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"CityCountyCount"];
            }
        }];
    } else if (tableView==self.cityTab) { //城市
        for (int i=0; i<_cityArr.count; i++) {
            ProvinceModel *model = _cityArr[i];
            if (i==indexPath.row) {
                model.isSelected = YES;
                _cityModel = model;
                _countyModel = nil;
                [_countyArr removeAllObjects];
                [self.countyTab reloadData];
                [_addressArr replaceObjectAtIndex:1 withObject:_cityModel.local_name];
                [_addressArr replaceObjectAtIndex:2 withObject:@"区县"];
                _confirmBtn.selected = NO;
            } else {
                model.isSelected = NO;
            }
        }
        
        [self.cityTab reloadData];
        [_segment updateChannels:_addressArr andIndex:1];
        
        //根据市ID获取区县
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _cityModel.region_id, @"regionID",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_GetRegionsByID parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                _countyArr = [ProvinceModel mj_objectArrayWithKeyValuesArray:responseData];
                [_segment updateChannels:_addressArr andIndex:2];
                [_pageView changeToItemAtIndex:2];
                [self.countyTab reloadData];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CityCountyCount"];
            }
        }];
    } else { //区县
        for (int i=0; i<_countyArr.count; i++) {
            ProvinceModel *model = _countyArr[i];
            if (i==indexPath.row) {
                model.isSelected = YES;
                _countyModel = model;
                [_addressArr replaceObjectAtIndex:2 withObject:_countyModel.local_name];
                _confirmBtn.selected = YES;
            } else {
                model.isSelected = NO;
            }
        }
        
        [self.countyTab reloadData];
        [_segment updateChannels:_addressArr andIndex:2];
    }
}

#pragma mark - AESegmentDelegate
- (void)AESegment:(AESegment*)segment didSelectIndex:(NSInteger)index{
    [_pageView changeToItemAtIndex:index];
}

#pragma mark - AEPageViewDelegate
- (void)didScrollToIndex:(NSInteger)index{
    [_segment didChengeToIndex:index];
}

//确定选择省市区
- (void)selectConfrim {
    
    if ([Utils isBlankString:_provinceModel.local_name]||[Utils isBlankString:_cityModel.local_name]||[Utils isBlankString:_countyModel.local_name]) {
        
    } else {
        [self dismiss];
        
        _provinceTF.text = [NSString stringWithFormat:@"%@、%@、%@",_provinceModel.local_name,_cityModel.local_name,_countyModel.local_name];
    }
}

#pragma mark - methods

//保存地址
- (void)submit {
    [self.view endEditing:YES]; //结束编辑
    
    if ([Utils isBlankString:_nameTF.text]) {
        [Utils showToast:@"请输入姓名"];
        return;
    }
    
    if ([Utils isBlankString:_phoneTF.text]) {
        [Utils showToast:@"请输入手机号"];
        return;
    }
    
    if (![Utils isMobileNumber:_phoneTF.text]) {
        [Utils showToast:@"请输入正确的手机号"];
        return;
    }
    
    if ([Utils isBlankString:_provinceTF.text]) {
        [Utils showToast:@"请选择省份、城市、区县"];
        return;
    }
    
    if ([Utils isBlankString:_detailTF.text]) {
        [Utils showToast:@"请输入详细地址"];
        return;
    }
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    //保存收货地址
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [UserInfo share].userID, @"memberID",
                                _phoneTF.text, @"mobile",
                                _nameTF.text, @"name",
                                _detailTF.text, @"addr", //详细地址
                                [NSString stringWithFormat:@"mainland:%@/%@/%@:%@",_provinceModel.local_name,_cityModel.local_name,_countyModel.local_name,_countyModel.region_id], @"area", //mainland:江苏/连云港市/新浦区:1677
                                _defaultBtn.selected==YES?@"1":@"0", @"def_addr",
                                nil];
    
    if (![Utils isBlankString:self.addressModel.addr_id]) { //修改地址
        [dic setObject:self.addressModel.addr_id forKey:@"addr_id"];
    }
    [[NetworkManager sharedManager] postJSON:URL_SaveAddress parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            [Utils showToast:@"新建地址成功"];
            
            if ([self.from isEqualToString:@"商品详情"]) {
                //跳订单确认页
                OrderConfirmVC *orderConfirmVC = [[OrderConfirmVC alloc] init];
                orderConfirmVC.from = self.from;
                orderConfirmVC.backFrom = @"新建地址";
                [self.navigationController pushViewController:orderConfirmVC animated:YES];
            } else if ([self.from isEqualToString:@"购物车"]) {
                //跳订单确认页
                OrderConfirmVC *orderConfirmVC = [[OrderConfirmVC alloc] init];
                orderConfirmVC.from = self.from;
                orderConfirmVC.goodIdent = self.goodIdent;
                orderConfirmVC.backFrom = @"新建地址";
                [self.navigationController pushViewController:orderConfirmVC animated:YES];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kChangeAddresssSuccNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

//设为默认地址
-(void)chickDefault {
    if (_defaultBtn.selected==YES) {
        _defaultBtn.selected=NO;
    } else {
        _defaultBtn.selected=YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
