//
//  LoveLifeVC.m
//  ArtEast
//
//  Created by yibao on 16/11/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "LoveLifeVC.h"
#import "BaseWebVC.h"
#import <WebKit/WebKit.h>
#import "WKDelegateController.h"
#import <MJRefresh.h>
#import "GoodsListViewController.h"
#import "BaseNC.h"
#import "GoodsDetailVC.h" //原生商品详情
#import "SearchVC.h"
#import "ShoppingCartVC.h"
#import "LoginVC.h"

@interface LoveLifeVC ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,WKDelegate,RefreshDelegate,UIScrollViewDelegate>
{
    WKWebView *_webView;
    WKWebView *_webView1;
    WKUserContentController *_userContentController;
    DefaultView *_defaultView;
    NSString *_webUrl;
    
    BOOL isHidden;
    
    UIButton *leftClickBtn;
    UIButton *rightClickBtn;
    UIButton *iconNum;
    UIView *titleTopView;
    UIView *lineBottomView;
    
    int index; //索引
    int i;
}
@end

@implementation LoveLifeVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    leftClickBtn.hidden = YES;
    rightClickBtn.hidden = YES;
    titleTopView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    leftClickBtn.hidden = NO;
    rightClickBtn.hidden = NO;
    titleTopView.hidden = NO;
    [self getCartNum]; //获取购物车数量
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    [self blankView];
    
    //配置环境
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    _userContentController =[[WKUserContentController alloc]init];
    configuration.userContentController = _userContentController;
    //注册方法
    WKDelegateController *delegateController = [[WKDelegateController alloc]init];
    delegateController.delegate = self;
    [_userContentController addScriptMessageHandler:delegateController name:@"goGoodsDetails"]; //跳到原生商品详情
    [_userContentController addScriptMessageHandler:delegateController name:@"contentHref"]; //跳原生列表页
    
    //精选话题
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-113)configuration:configuration];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webUrl = HTML_FindPage;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30]];
    [self.view addSubview:_webView];
    
    //设计师说
    _webView1 = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-113)configuration:configuration];
    _webView1.hidden = YES;
    _webView1.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView1.UIDelegate = self;
    _webView1.navigationDelegate = self;
    [self.view addSubview:_webView1];
    
    index = 0;
    i = 1;
    
//    //动画下拉刷新
//    [self webViewGifHeaderWithRefreshingBlock:^{
//        [self performSelector:@selector(endRefresh) withObject:self afterDelay:1.5];
//    }];
}

- (void)endRefresh {
    [_webView.scrollView.mj_header endRefreshing]; //结束刷新
}

// 记得取消监听
- (void)dealloc {
    [_userContentController removeScriptMessageHandlerForName:@"goGoodsDetails"];
    [_userContentController removeScriptMessageHandlerForName:@"contentHref"];
}

#pragma mark - 初始化导航条

- (void)initNav {
    //左搜索
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"SearchGray"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    leftBtn.userInteractionEnabled = NO;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navItem.leftBarButtonItem = leftBarButtonItem;

    //右购物车
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"CartGray"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(WIDTH-30, 0, 30, 30);
    rightBtn.userInteractionEnabled = NO;
    
    //数量提示
    iconNum = [[UIButton alloc] initWithFrame:CGRectMake(14, -2, 17, 17)];
    iconNum.hidden = YES;
    iconNum.backgroundColor = LightYellowColor;
    iconNum.titleLabel.font = [UIFont systemFontOfSize:10];
    [iconNum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    iconNum.layer.cornerRadius = 8.5;
    iconNum.userInteractionEnabled = NO;
    [rightBtn addSubview:iconNum];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navItem.rightBarButtonItem = rightBarButtonItem;
    
    leftClickBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 14, 50, 50)];
    [leftClickBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:leftClickBtn];
    
    rightClickBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-55, 14, 50, 50)];
    [rightClickBtn addTarget:self action:@selector(cartAction) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:rightClickBtn];
    
    
    titleTopView = [[UIView alloc] initWithFrame:CGRectMake((WIDTH-170)/2, 20, 160, 44)];
    [[UIApplication sharedApplication].keyWindow addSubview:titleTopView];
    
    UIButton *topBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    [topBtn1 setTitle:@"精选话题" forState:UIControlStateNormal];
    topBtn1.titleLabel.font = [UIFont systemFontOfSize:16];
    topBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [topBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [topBtn1 addTarget:self action:@selector(selectFrist) forControlEvents:UIControlEventTouchUpInside];
    [titleTopView addSubview:topBtn1];
    
    UIButton *topBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(topBtn1.maxX+20, 0, 70, 44)];
    [topBtn2 setTitle:@"设计师说" forState:UIControlStateNormal];
    topBtn2.titleLabel.font = [UIFont systemFontOfSize:16];
    topBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [topBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [topBtn2 addTarget:self action:@selector(selectSecond) forControlEvents:UIControlEventTouchUpInside];
    [titleTopView addSubview:topBtn2];
    
    lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(topBtn1.x, topBtn1.maxY-5, 70, 5)];
    lineBottomView.backgroundColor = LightYellowColor;
    [titleTopView addSubview:lineBottomView];
}

- (void)getCartNum {
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:kCartCount];
    if ([Utils isBlankString:result]||[result isEqualToString:@"0"]) {
        iconNum.hidden = YES;
    } else {
        iconNum.hidden = NO;
        [iconNum setTitle:result forState:UIControlStateNormal];
    }
}

#pragma mark - methods

//精选话题
- (void)selectFrist {
    if (index!=0) {
        // 改变控件的位置
        lineBottomView.transform = CGAffineTransformTranslate(lineBottomView.transform, -90, 0);
        
        _webUrl = HTML_FindPage;
        
        index = 0;
        _webView.hidden = NO;
        _webView1.hidden = YES;
    }
}

//设计师说
- (void)selectSecond {
    if (index!=1) {
        // 改变控件的位置
        lineBottomView.transform = CGAffineTransformTranslate(lineBottomView.transform, 90, 0);
        
        _webUrl = HTML_DesignSay;
        
        if (i!=2) {
            [_webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30]];
        }
        
        index = 1;
        i = 2;
        _webView.hidden = YES;
        _webView1.hidden = NO;
    }
}

//购物车
- (void)cartAction {
    //如果用户ID存在的话，说明已登陆
    if ([Utils isUserLogin]) {
        ShoppingCartVC *shoppingCartVC = [[ShoppingCartVC alloc] init];
        shoppingCartVC.hidesBottomBarWhenPushed = YES;
        shoppingCartVC.isTabbarHidder = YES;
        [self.navigationController pushViewController:shoppingCartVC animated:YES];
    } else {
        //跳到登录页面
        LoginVC *loginVC = [[LoginVC alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

//搜索
- (void)searchAction {
    DLog(@"搜索");
    SearchVC *searchVC = [[SearchVC alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 刷新H5

-(void)refreshH5 {
    //清除缓存，刷新网页
    //[Utils clearCache];
    
    [_webView reload];
}

#pragma mark - 动画下拉刷新/上拉加载更多

- (void)webViewGifHeaderWithRefreshingBlock:(void(^)()) block {
    
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
    _webView.scrollView.mj_header = gifHeader;
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    if (isHidden == NO) {
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [JHHJView hideLoading]; //结束加载
    [_webView.scrollView.mj_header endRefreshing]; //结束刷新
    isHidden = NO;
    _webView.hidden = YES;
    _defaultView.hidden = NO;
    _defaultView.imgView.image = [UIImage imageNamed:@"NoNetwork"];
    _defaultView.lab.text = @"网络状态待提升，点击重试";
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow); //允许跳转
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *url = navigationAction.request.URL.absoluteString;
    if (url.length>0) {
        if (![url isEqualToString:_webUrl]) {
            decisionHandler(WKNavigationActionPolicyCancel); //不允许跳转
            
            [BaseWebVC showWithContro:self withUrlStr:url withTitle:@"" isPresent:NO withShareContent:@""];
        } else {
            decisionHandler(WKNavigationActionPolicyAllow); //允许跳转
        }
    }
}

#pragma mark - OC调用JS

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [JHHJView hideLoading]; //结束加载
    [_webView.scrollView.mj_header endRefreshing]; //结束刷新
    isHidden = NO;
    
//    [UIView animateWithDuration:1 animations:^{
//        _webView.alpha = 1;
//    }];
    
    NSDictionary *dic = @{@"memberId":[UserInfo share].userID.length>0?[UserInfo share].userID:@"false"};
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"getIos('%@');",[Utils dictionaryToJson:dic]] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //NSLog(@"js返回结果%@",result);
    }];
}

#pragma mark - JS调用OC

//WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    
    if ([message.name isEqualToString:@"contentHref"]) { //跳原生列表页
        
        NSString *result = message.body[@"href"];
        
        if (result.length>0) {
            //判断网址后面是否有参数
            NSArray *arr = [result componentsSeparatedByString:@"?"];
            if (arr.count>1) {
                
                NSString *page = arr[0];
                
                if ([page isEqualToString:@"list"]) {
                    NSMutableDictionary *urlParDic = [Utils subWebUrlParChangeDic:result];
                    
                    if ([[urlParDic allKeys] containsObject:@"keyid"]&&[[urlParDic allKeys] containsObject:@"caName"]) {
                        
                        NSString *cat_id = [urlParDic objectForKey:@"keyid"];
                        NSString *cat_name = [urlParDic objectForKey:@"caName"];
                        
                        if (isHidden == NO) {
                            GoodsListViewController *goodsListVC = [[GoodsListViewController alloc] init];
                            goodsListVC.hidesBottomBarWhenPushed = YES;
                            goodsListVC.virtual_cat_id = cat_id;
                            goodsListVC.virtual_cat_name = cat_name;
                            [self.navigationController pushViewController:goodsListVC animated:YES];
                        }
                        
                    }
                }
                
                if ([page isEqualToString:@"detail"]) {
                    NSMutableDictionary *urlParDic = [Utils subWebUrlParChangeDic:result];
                    
                    if ([[urlParDic allKeys] containsObject:@"keyid"]) {
                        
                        GoodsModel *goodsModel = [[GoodsModel alloc] init];
                        goodsModel.icon = @"";
                        goodsModel.ID = [urlParDic objectForKey:@"keyid"];
                        if (![Utils isBlankString:goodsModel.ID]) {
                            if (isHidden == NO) {
                                GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
                                goodsDetailVC.hidesBottomBarWhenPushed = YES;
                                goodsDetailVC.goodsModel = goodsModel;
                                goodsDetailVC.hideAnimation = YES;
                                BaseNC *baseNC = (BaseNC *)self.navigationController;
                                [baseNC pushViewController:goodsDetailVC imageView:goodsModel.imageView desRec:goodsModel.descRec original:goodsModel.originalRec deleagte:goodsDetailVC isAnimation:YES];
                            }
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - WKUIDelegate

// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

//有网络了
//- (void)netWorkAppear
//{
//    [super netWorkAppear];
//
//    [self refresh];
//}

//无网
- (void)blankView {
    _defaultView = [[DefaultView alloc] initWithFrame:self.tableFrame];
    _defaultView.delegate = self;
    _defaultView.hidden = YES;
    [self.view addSubview:_defaultView];
}

#pragma mark - RefreshDelegate

- (void)refresh {
    _defaultView.hidden = YES;
    _webView.hidden = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
