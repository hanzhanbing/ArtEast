//
//  BaseVC.m
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "BaseVC.h"
#import "MJRefresh.h"
#import <JPUSHService.h>

@interface BaseVC ()
{
    __block int timeout; //倒计时时间
}

@property (nonatomic, assign)CGFloat viewBottom; //textField的底部
@property (nonatomic, assign)CGRect keyBoardFrames;

@end

@implementation BaseVC

//- (void)viewDidLayoutSubviews {
//    
//    UIView *view = self.view.subviews[0];
//    CGRect frame = view.frame;
//    frame.origin.y = kNavBarH;
//    view.frame = frame;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = PageColor;
    
    self.tableFrame = CGRectMake(0, kNavBarH, WIDTH, HEIGHT-kNavBarH);
    
    [self setNavBar];
    
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    
    //无网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkDisappear) name:@"kNetDisAppear" object:nil];
    //有网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkAppear) name:@"kNetAppear" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
}

//没有网络了
- (void)netWorkDisappear
{
//    if (![self.navItem.title containsString:@"（未连接）"]) {
//        self.navItem.title = [NSString stringWithFormat:@"%@（未连接）",self.navItem.title];
//    }
}

//有网络了
- (void)netWorkAppear
{
//    if ([self.navItem.title containsString:@"（未连接）"]) {
//        self.navItem.title = [self.navItem.title stringByReplacingOccurrencesOfString:@"（未连接）" withString:@""];
//    }
}

#pragma mark - 自定义导航条
- (void)setNavBar {
    
    self.navBar = [[BaseNavBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64.0)];
    self.navBar.translucent = NO;
    
    self.navItem = [[UINavigationItem alloc] init];
    [self.navBar setItems:@[self.navItem]];
    
    if ([[self.navigationController viewControllers] count] == 1) {
        
    } else {
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navItem.leftBarButtonItem = backBarButtonItem;
    }
}

#pragma mark - Set方法

- (void)setTitle:(NSString *)title {
    self.navItem.title = title;
}

#pragma mark - 自定义方法

//返回
- (void)backAction {
    timeout = -1;
    [self.navigationController popViewControllerAnimated:YES];
}

//获取数据
- (void)getData{
    
}

#pragma mark - UITableViewDelegate

//iOS11 tableView 如果是Gruop类型的话，section之间的间距变宽，执行返回高度的同时还需要执行return UIView的代理
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - EMClientDelegate

- (void)didLoginFromOtherDevice
{
    //佑生活退出登录
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ThirdLoginType"];
    [[UserInfo share] setUserInfo:nil]; //清除用户信息
    
    [JPUSHService setTags:[NSSet set] alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
    }]; //清除别名
    
    //环信退出登录
    EMError *err = [[EMClient sharedClient] logout:NO];
    if (!err) {
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccNotification object:nil];
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popViewControllerAnimated:YES];
    
    //弹框提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的账号已在其他地方登录" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }])];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - 动画下拉刷新/上拉加载更多
- (void)tableViewGifHeaderWithRefreshingBlock:(void(^)()) block {
    
    //设置即将刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 1; i<=21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_refresh_image_0%zd",i]];
        [refreshingImages addObject:image];
    }
    
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //下拉刷新要做的操作
        block();
    }];
    
    //是否显示刷新状态和刷新时间
    gifHeader.stateLabel.hidden = YES;
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    
    [gifHeader setImages:@[refreshingImages[0]] forState:MJRefreshStateIdle];
    [gifHeader setImages:refreshingImages forState:MJRefreshStatePulling];
    [gifHeader setImages:refreshingImages forState:MJRefreshStateRefreshing];
    _tableView.mj_header = gifHeader;
}

- (void)tableViewGifFooterWithRefreshingBlock:(void(^)()) block {
    
    NSMutableArray *footerImages = [NSMutableArray array];
    for (int i = 1; i <= 21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_refresh_image_0%zd",i]];
        [footerImages addObject:image];
    }
    
    MJRefreshAutoGifFooter *gifFooter = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        //上拉加载需要做的操作
        block();
    }];
    
    //是否显示刷新状态和刷新时间
    //gifFooter.stateLabel.hidden = YES;
    //gifFooter.refreshingTitleHidden = YES;
    
    [gifFooter setImages:@[footerImages[0]] forState:MJRefreshStateIdle];
    [gifFooter setImages:footerImages forState:MJRefreshStateRefreshing];
    _tableView.mj_footer = gifFooter;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = [textField.superview convertRect:textField.frame toView:self.view];
    self.tempFrame = frame;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    CGRect frame = [textView.superview convertRect:textView.frame toView:self.view];
    self.tempFrame = frame;
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    
    CGFloat duration = [dict[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyboardFrame = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat transformY = 0;
    _keyBoardFrames = keyboardFrame;
    if (keyboardFrame.origin.y<self.tempFrame.origin.y + self.tempFrame.size.height) {
        transformY = keyboardFrame.origin.y - self.tempFrame.origin.y - self.tempFrame.size.height-30;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
        self.navBar.frame = CGRectMake(0, -transformY, WIDTH, 64);
        [self.view bringSubviewToFront:self.navBar];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // UIScrollView、UITableView偏移20/64适配
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    //隐藏系统导航条
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.navBar];
    
    if (!self.isPanForbid) { //默认开启
        // 开启iOS自带侧滑返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    } else {
        // 禁用iOS自带侧滑返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.navBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //显示系统导航条
    [self.navigationController setNavigationBarHidden:NO];
    [JHHJView hideLoading]; //结束加载
}

- (void)dealloc {
    NSLog(@"释放控制器");
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //移除通知
    timeout = -1;
    [[EMClient sharedClient] removeDelegate:self];
}

//#pragma mark - 仿简书、淘宝等的View弹出效果
//
//- (void)createPopVCWithRootVC:(UIViewController *)rootVC andPopView:(UIView *)popView
//{
//    _rootVC = rootVC;
//    _popView = popView;
//    [self createUI];
//}
//
//- (void)createUI
//{
//    self.view.backgroundColor = [UIColor blackColor];
//    
//    _rootVC.view.frame = self.view.bounds;
//    _rootVC.view.backgroundColor = [UIColor whiteColor];
//    _rootview = _rootVC.view;
//    [self addChildViewController:_rootVC];
//    [self.view addSubview:_rootview];
//    
//    //rootVC上的maskView
//    _maskView = ({
//        UIView * maskView = [[UIView alloc]initWithFrame:self.view.bounds];
//        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        maskView.alpha = 0;
//        maskView;
//    });
//    [_rootview addSubview:_maskView];
//}
//
//- (void)close
//{
//    CGRect frame = _popView.frame;
//    frame.origin.y += _popView.frame.size.height;
//    
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        
//        //maskView隐藏
//        [_maskView setAlpha:0.f];
//        //popView下降
//        _popView.frame = frame;
//        
//        //同时进行 感觉更丝滑
//        [_rootview.layer setTransform:[self firstTransform]];
//        
//    } completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            //变为初始值
//            [_rootview.layer setTransform:CATransform3DIdentity];
//            
//        } completion:^(BOOL finished) {
//            
//            //移除
//            [_popView removeFromSuperview];
//        }];
//        
//    }];
//}
//
//- (void)show
//{
//    [[UIApplication sharedApplication].windows[0] addSubview:_popView];
//    
//    CGRect frame = _popView.frame;
//    frame.origin.y = self.view.bounds.size.height - _popView.frame.size.height;
//    
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        
//        [_rootview.layer setTransform:[self firstTransform]];
//        
//    } completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            
//            [_rootview.layer setTransform:[self secondTransform]];
//            //显示maskView
//            [_maskView setAlpha:0.5f];
//            //popView上升
//            _popView.frame = frame;
//            
//        } completion:^(BOOL finished) {
//            
//        }];
//        
//    }];
//}
//
//- (CATransform3D)firstTransform{
//    CATransform3D t1 = CATransform3DIdentity;
//    t1.m34 = 1.0/-900;
//    //带点缩小的效果
//    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
//    //绕x轴旋转
//    t1 = CATransform3DRotate(t1, 15.0 * M_PI/180.0, 1, 0, 0);
//    return t1;
//}
//
//- (CATransform3D)secondTransform{
//    
//    CATransform3D t2 = CATransform3DIdentity;
//    t2.m34 = [self firstTransform].m34;
//    //向上移
//    t2 = CATransform3DTranslate(t2, 0, self.view.frame.size.height * (-0.08), 0);
//    //第二次缩小
//    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
//    return t2;
//}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"item name = %@", item.title);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
}

- (void)startTimeCount:(UIButton *)l_timeButton {
    timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [l_timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                l_timeButton.userInteractionEnabled = YES;
                l_timeButton.enabled = YES;
            });
        }else{
            int seconds = timeout;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [l_timeButton setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                l_timeButton.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
