//
//  GoodsDetailVC.m
//  ArtEast
//
//  Created by yibao on 16/12/12.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "GoodsDetailVC.h"
#import "SDCycleScrollView.h"
#import "GoodsDetailModel.h"
#import "GoodsSkusModel.h"
#import "GoodsCommentModel.h"
#import "GoodsFavModel.h"
#import "BaseWebVC.h"
#import "ShoppingCartVC.h"
#import "LoginVC.h"
#import "ImageViewer.h"
#import "AEFlowLayoutView.h"
#import "AEShareView.h"
#import "TapImageView.h"
#import "ImgLargeScrollView.h"
#import "OrderConfirmVC.h"
#import "AddressModel.h"
#import "EditAddressVC.h"
#import "AEEmitterButton.h"
#import "ChatViewController.h"

#define SCREEN_SIZE     [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define HEADER_VIEW_HEIGHT      [UIScreen mainScreen].bounds.size.width      // 顶部商品图片高度
#define END_DRAG_SHOW_HEIGHT    80.0f       // 结束拖拽最大值时的显示
#define BOTTOM_VIEW_HEIGHT      49.0f       // 底部视图高度（加入购物车＼立即购买）

@interface GoodsDetailVC ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIWebViewDelegate, SDCycleScrollViewDelegate, AEFlowLayoutViewDelegate,CAAnimationDelegate,TapImageViewDelegate>

@property (nonatomic,retain) UIView *bgView;            // 背景视图
@property (nonatomic,retain) UIView *navigationView;    // 导航栏
@property (nonatomic,retain) UIView *headerView;        // 顶部视图
@property (nonatomic,retain) UIView *footerView;        // 底部视图
@property (nonatomic,retain) UILabel *xiajiaView;       // 下架视图
@property (nonatomic,retain) UIView *promotionView;     // 促销视图
@property (nonatomic,retain) UILabel *titleLab;         // 标题
@property (nonatomic,retain) UIButton *backBtn;         // 返回
@property (nonatomic,retain) UIButton *shareBtn;        // 分享
@property (nonatomic,retain) UIView *allContentView;    // 所有内容的View
@property (nonatomic,retain) UIView *tableFooterView;   // 尾视图

@property (nonatomic,retain) UIView *detailCell;        // 详情cell
@property (nonatomic,retain) UIView *promoCell;         // 促销cell
@property (nonatomic,retain) UIView *specCell;          // 规格cell
@property (nonatomic,retain) UIView *favCell;           // 喜欢cell
@property (nonatomic,retain) UIView *commentCell;       // 评论cell

@property (nonatomic,retain) UIWebView *detailWebView;  // 商品详情
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) UILabel *pageLab;         //分页个数

@property (nonatomic,retain) AEEmitterButton *collectBtn;      // 关注
@property (nonatomic,retain) UIButton *cartBtn;         // 购物车
@property (nonatomic,retain) UIButton *countBtn;        // 购物车数量
@property (nonatomic,retain) UIButton *chatBtn;         // 聊天
@property (nonatomic,retain) UIButton *addCartBtn;      // 添加购物车
@property (nonatomic,retain) UIButton *buyBtn;          // 立即购买

@property (strong, nonatomic) UIView *popView;                  // 弹出底部视图
@property (strong, nonatomic) UIView *maskView;                 // 遮罩视图
@property (strong, nonatomic) UIView *maskView2;                // 遮罩视图2
@property (strong, nonatomic) TapImageView *goodsIcon;           // 商品图片
@property (strong, nonatomic) UIButton *deleteBtn;              // 删除图标
@property (strong, nonatomic) UILabel *titleLabel;              // 商品名称
@property (strong, nonatomic) UILabel *priceLabel;              // 价格
@property (strong, nonatomic) UITextField *goodsNumTF;          // 商品数量
@property (strong, nonatomic) UILabel *storeLabel;              // 库存

@property (strong, nonatomic) UILabel *topMsgLabel;             // 顶部提示信息
@property (strong, nonatomic) UILabel *bottomMsgLabel;          // 底部提示信息

@property (strong, nonatomic) GoodsDetailModel *detailModel;    //商品详情model
@property (strong, nonatomic) GoodsCommentModel *commentModel;  //商品评论model
@property (strong, nonatomic) NSMutableArray *favArr;           //商品收藏数组
@property (strong, nonatomic) NSMutableArray *picArray;         //图片轮播数组
@property (strong, nonatomic) NSMutableArray *ivArr;            //评论图片控件数组
@property (assign, nonatomic) BOOL isShowLab;                   //是否显示图片轮播数组数量
@property (assign, nonatomic) int picIndex;                     //当前显示的是第几个图片
@property (strong, nonatomic) NSString *isGoodsFav;             //商品是否收藏

@end

@implementation GoodsDetailVC
{
    CGFloat minY;
    CGFloat maxY;
    // 图文详情开关，
    BOOL isShowDetail;
    // 选择规格弹框开关，
    BOOL isShowSkus;
    
    //头部背景图宽高
    float _bgImgWidth;
    float _bgImgHeight;
    
    //弹出规格高度
    float _specHeight;
    
    //图文详情div
    NSString *htmlStr;
    
    UIImageView *topImgView;
    UIView *headView;
}

#pragma mark - AEAnimatorDelegate

- (void)animationFinish
{
    // 图片往上平铺
    _isShowLab = YES;
    _picIndex = 1;
    [_picArray removeAllObjects];
    [_picArray addObject:self.goodsModel.icon];
    [self.tableView reloadData];
    _headerView.hidden = NO;
    
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ImageJumpAnimation"];
    self.tabBarController.tabBar.hidden=YES;
    self.navBar.hidden = YES; //隐藏导航条
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _picArray = [NSMutableArray array];
    _specHeight = 230; //默认弹出规格高度
    [self initView];
    
    if (self.isPresent==YES) {
        // 图片往上平铺
        _isShowLab = YES;
        _picIndex = 1;
        [_picArray removeAllObjects];
        [_picArray addObject:self.goodsModel.icon];
        [self.tableView reloadData];
        
        [self getData];
    }
}

#pragma mark - init data

- (void)getData {
    
    //获取商品详情
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.goodsModel.ID, @"iid",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_GetGoodsDetail parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            _detailModel = [GoodsDetailModel mj_objectWithKeyValues:responseData[@"item"]];
            
            //加载图文详情
            htmlStr = @"<div style=\"text-align:center;\">\n";
            for (int i=0; i<_detailModel.des_imgs.count; i++) {
                NSString *imgH5 = @"";
                NSString *imgUrl = [NSString stringWithFormat:@"%@",_detailModel.des_imgs[i]];
                if (i == _detailModel.des_imgs.count-1) {
                    if ([imgUrl containsString:@"http"]) {
                        imgH5 = [NSString stringWithFormat:@"<img src='%@'>",_detailModel.des_imgs[i]];
                    } else {
                        imgH5 = [NSString stringWithFormat:@"<img src='%@%@'>",PictureUrl,_detailModel.des_imgs[i]];
                    }
                } else {
                    if ([imgUrl containsString:@"http"]) {
                        imgH5 = [NSString stringWithFormat:@"<img src='%@'>\n",_detailModel.des_imgs[i]];
                    } else {
                        imgH5 = [NSString stringWithFormat:@"<img src='%@%@'>\n",PictureUrl,_detailModel.des_imgs[i]];
                    }
                }
                htmlStr = [NSString stringWithFormat:@"%@%@",htmlStr,imgH5];
            }
            htmlStr = [NSString stringWithFormat:@"%@</div>",htmlStr];
            [self.detailWebView loadHTMLString:htmlStr baseURL:nil];
            
            //加载图片轮播
            [_picArray removeAllObjects];
            for (int i=0; i<self.detailModel.item_imgs.count; i++) {
                NSString *imgItem = [NSString stringWithFormat:@"%@%@",PictureUrl,self.detailModel.item_imgs[i][@"thisuasm_url"]];
                [_picArray addObject:imgItem];
            }
            
            //加载选择规格
            NSArray *skus = self.detailModel.skus;
            for (int i=0; i<skus.count; i++) {
                GoodsSkusModel *skusModel = skus[i];
                if ([skusModel.is_default isEqualToString:@"true"]) { //默认选中
                    self.detailModel.select_skusIndex = i;
                    self.detailModel.select_skusID = skusModel.sku_id;
                    self.detailModel.select_skusImgs = skusModel.spec_goods_images;
                    self.detailModel.realStore = [NSString stringWithFormat:@"%d",[skusModel.store intValue]-[skusModel.freez intValue]];
                    self.detailModel.price = skusModel.price; //价格、市场价格以规格为主
                    self.detailModel.market_price = skusModel.market_price;
                    if ([Utils isBlankString:skusModel.properties]) {
                        self.detailModel.select_skus = @"1件";
                    } else {
                        NSArray *proArr = [skusModel.properties componentsSeparatedByString:@";"];
                        NSString *proStr = @"";
                        for (int i=0; i<proArr.count; i++) {
                            NSArray *arr = [proArr[i] componentsSeparatedByString:@"_"];
                            if (arr.count>1) {
                                proStr = [NSString stringWithFormat:@"%@%@，",proStr,arr[1]];
                            } else {
                                proStr = [NSString stringWithFormat:@"%@%@，",proStr,arr[0]];
                            }
                        }
                        self.detailModel.select_skus = [NSString stringWithFormat:@"%@1件",proStr];
                    }
                }
            }
            
            //默认选择数量
            self.detailModel.select_count = @"1";
            
            NSString *firstImgUrl = @"";
            if (_picArray.count>0) {
                firstImgUrl = _picArray[0];
            }
            //先缓存一下图片轮播的第一张图片
            [topImgView sd_setImageWithURL:[NSURL URLWithString:firstImgUrl] placeholderImage:[UIImage imageNamed:@"GoodsDefaultBig"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self.tableView reloadData];
                
                self.view.backgroundColor = PageColor;
                _tableFooterView.alpha = 1;
                _detailWebView.alpha = 1;
                _footerView.alpha = 1;
                _shareBtn.userInteractionEnabled = YES;
                
                if ([self.detailModel.marketable isEqualToString:@"false"]) { //商品下架
                    _shareBtn.userInteractionEnabled = NO;
                    _addCartBtn.userInteractionEnabled = NO;
                    _buyBtn.userInteractionEnabled = NO;
                    _addCartBtn.backgroundColor = PageColor;
                    [_addCartBtn setTitleColor:LightBlackColor forState:UIControlStateNormal];
                    _buyBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
                    [_buyBtn setTitleColor:LightBlackColor forState:UIControlStateNormal];
                    
                    _xiajiaView.hidden = NO;
                }
            }];
            
            //获取商品喜欢
            [self getGoodsFav];
            
            //获取商品评论
            [self getGoodsComment];
            
            //检测商品关注
            [self checkGoodsFav];
            
            //获取购物车数量
            [self getCartNum];
        }
    }];
}

- (void)getGoodsFav {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.goodsModel.ID, @"goods_id",
                         @"1", @"page",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_GetGoodsFav parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                [_favArr removeAllObjects];
                _favArr = [GoodsFavModel mj_objectArrayWithKeyValuesArray:responseData[@"data"]];
                _detailModel.favs_count = [NSString stringWithFormat:@"%@",responseData[@"pager"][@"total"]];
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)getGoodsComment {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.goodsModel.ID, @"iid",
                          nil];
    [[NetworkManager sharedManager] postJSON:URL_GetGoodsComment parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            if ([responseData isKindOfClass:[NSArray class]]) {
                NSArray *commentArr = responseData;
                if (commentArr.count>0) {
                    _commentModel = [GoodsCommentModel mj_objectWithKeyValues:commentArr[0]];
                    _detailModel.comments_count = [NSString stringWithFormat:@"%d",(int)commentArr.count];
                    [self.tableView reloadData];
                }
            }
        }
    }];
}

- (void)checkGoodsFav {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UserInfo share].userID, @"memberID",
                          self.goodsModel.ID, @"goodID",
                          nil];
    [[NetworkManager sharedManager] postJSON:URL_CheckGoodsFav parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            _isGoodsFav = [NSString stringWithFormat:@"%@",responseData];
            [self.tableView reloadData];
        }
    }];
}

- (void)getCartNum {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UserInfo share].userID, @"memberID",
                          nil];
    [[NetworkManager sharedManager] postJSON:URL_GetCartNum parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            NSString *result = [NSString stringWithFormat:@"%@",responseData];
            
            if ([result isEqualToString:@"0"]) {
                _countBtn.hidden = YES;
                
                //隐藏
                [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
            } else {
                _countBtn.hidden = NO;
                [_countBtn setTitle:result forState:UIControlStateNormal];
                
                //显示
                [self.tabBarController.tabBar showBadgeOnItemIndex:3 andCount:result];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:result forKey:kCartCount];
        }
    }];
}

#pragma mark - methods

//返回
- (void)backAction {
    [JHHJView hideLoading]; //结束加载
    if (self.hideAnimation==YES) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ImageJumpAnimation"];
    }
    
    if ([self.goodsModel.from isEqualToString:@"分类列表"]&&![Utils isBlankString:_isPraise]) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
        [mutDic setObject:self.goodsModel.index forKey:@"Index"];
        [mutDic setObject:self.goodsModel.indexPath forKey:@"IndexPath"];
        [mutDic setObject:_isPraise forKey:@"PraiseFlag"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCollectNotification object:mutDic];
    }
    
    if (self.isPresent==YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//分享
- (void)shareAction {
    NSMutableDictionary *goodsShareDic = [NSMutableDictionary dictionary];
    
    NSString *picUrl = @"";
    if (self.detailModel.item_imgs.count>0) {
        picUrl = [NSString stringWithFormat:@"%@%@",PictureUrl,self.detailModel.item_imgs[0][@"thisuasm_url"]];
    } else {
        picUrl = self.goodsModel.icon;
    }
    NSLog(@"rtgtrgt%@",picUrl);
    [goodsShareDic setObject:picUrl forKey:@"image"];
    NSString *urlStr = [NSString stringWithFormat:@"%@web/Share/goodsDetails.html?iid=%@",WebUrl,self.goodsModel.ID];
    [goodsShareDic setObject:urlStr forKey:@"url"];
    [goodsShareDic setObject:self.detailModel.title forKey:@"title"];
    [goodsShareDic setObject:@"我在佑生活发现一个超级好的商品，赶快来看看吧" forKey:@"text"];
    AEShareView *shareView = [[AEShareView alloc] initWithBaseController:self andBaseView:[UIApplication sharedApplication].keyWindow andData:goodsShareDic andType:ShareUrl];
    [shareView show];
}

//关注
- (void)collectAction {
    //如果用户ID存在的话，说明已登陆
    if ([Utils isUserLogin]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [UserInfo share].userID, @"memberID",
                             self.goodsModel.ID, @"gid",
                             nil];
        
        if (_collectBtn.isSelected==YES) { //取消关注
            [[NetworkManager sharedManager] postJSON:URL_DeleteFav parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
                
                if (status == Request_Success) {
                    _isPraise = @"0";
                    _isGoodsFav = @"0";
                    //[Utils showToast:@"取消关注"];
                    
                    //获取商品喜欢
                    [self getGoodsFav];
                }
            }];
        } else { //添加关注
            [[NetworkManager sharedManager] postJSON:URL_AddFav parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
                
                if (status == Request_Success) {
                    _isPraise = @"1";
                    _isGoodsFav = @"1";
                    //[Utils showToast:@"关注成功"];
                    
                    //获取商品喜欢
                    [self getGoodsFav];
                }
            }];
        }
    } else {
        [self jumpLogin]; //跳到登录
    }
}

//购物车
- (void)cartAction {
    //如果用户ID存在的话，说明已登陆
    if ([Utils isUserLogin]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ImageJumpAnimation"];
        ShoppingCartVC *shoppingCartVC = [[ShoppingCartVC alloc] init];
        shoppingCartVC.hidesBottomBarWhenPushed = YES;
        shoppingCartVC.isTabbarHidder = YES;
        [self.navigationController pushViewController:shoppingCartVC animated:NO];
    } else {
        [self jumpLogin]; //跳到登录
    }
}

//聊天
- (void)chatAction {
    //如果用户ID存在的话，说明已登陆
    if ([Utils isUserLogin]) {
        if ([[EMClient sharedClient] isLoggedIn]) { //环信是否登录
            [self jumpChatVC];
        } else {
            [[EMClient sharedClient] loginWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    [self jumpChatVC];
                }
            }];
        }
    } else {
        [self jumpLogin]; //跳到登录
    }
}

//跳转到聊天页面
- (void)jumpChatVC {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ImageJumpAnimation"];
    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:HXChatter conversationType:EMConversationTypeChat];
    chatVC.hidesBottomBarWhenPushed = YES;
    NSDictionary *dataDictionary= [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"我正在看：",@"title", //消息标题
                                   [NSString stringWithFormat:@"￥%@",_detailModel.price],@"price", //商品价格
                                   _detailModel.title,@"desc", //商品描述
                                   [NSString stringWithFormat:@"%@%@",PictureUrl,self.detailModel.item_imgs[0][@"thisuasm_url"]],@"img_url", //商品图片链接
                                   [NSString stringWithFormat:@"%@web/Share/goodsDetails.html?iid=%@",WebUrl,self.goodsModel.ID],@"item_url", //商品页面链接
                                   [UserInfo share].userName,@"nick", //昵称
                                   [UserInfo share].avatar,@"avatar", //头像
                                   [Utils isBlankString:self.goodsModel.ID]?@"":self.goodsModel.ID,@"id", //id
                                   @"",@"order_title", //多余
                                   nil];
    chatVC.info = @{@"msgtype":@{@"track":dataDictionary}};
    chatVC.infoType = @"轨迹";
    chatVC.height = 95;
    [self.navigationController pushViewController:chatVC animated:YES];
}

//添加购物车
- (void)addCartAction {
    //如果用户ID存在的话，说明已登陆
    if ([Utils isUserLogin]) {
        if (![Utils isBlankString:self.detailModel.select_skus]) {
            //添加购物车
            NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UserInfo share].userID, @"memberID",
                                  self.detailModel.select_skusID, @"product_id",
                                  self.detailModel.select_count, @"num",
                                  nil];
            [[NetworkManager sharedManager] postJSON:URL_AddCartGoods parameters:dic2 imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
                
                if (status == Request_Success) {
                    [Utils showToast:@"加入购物车成功"];
                    if (isShowSkus) { //打开
                        UIImageView *goodsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, HEIGHT-_popView.height, 100, 100)];
                        goodsIcon.image = _goodsIcon.image;
                        [self.view addSubview:goodsIcon];
                        [UIView animateWithDuration:1.0 animations:^{
                            goodsIcon.frame=CGRectMake(BOTTOM_VIEW_HEIGHT+BOTTOM_VIEW_HEIGHT/2, HEIGHT-49/2, 0, 0);
                            goodsIcon.transform = CGAffineTransformRotate(goodsIcon.transform, M_PI_2);
                        } completion:^(BOOL finished) {
                            //获取购物车数量
                            [self getCartNum];
                            
                            //动画完成后做的事
                            CATransition *animation = [CATransition animation];
                            animation.duration = 0.25f;
                            [_countBtn.layer addAnimation:animation forKey:nil];
                            
                            CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
                            shakeAnimation.duration = 0.25f;
                            shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
                            shakeAnimation.toValue = [NSNumber numberWithFloat:5];
                            shakeAnimation.autoreverses = YES;
                            [_cartBtn.layer addAnimation:shakeAnimation forKey:nil];
                        }];
                    } else {
                        //获取购物车数量
                        [self getCartNum];
                        
                        //动画完成后做的事
                        CATransition *animation = [CATransition animation];
                        animation.duration = 0.25f;
                        [_countBtn.layer addAnimation:animation forKey:nil];
                        
                        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
                        shakeAnimation.duration = 0.25f;
                        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
                        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
                        shakeAnimation.autoreverses = YES;
                        [_cartBtn.layer addAnimation:shakeAnimation forKey:nil];
                    }
                }
            }];
        } else {
            //self.tableView.contentOffset = CGPointMake(0, 0);
            [self open];
        }
    } else {
        [self jumpLogin]; //跳到登录
    }
}

//立即购买
- (void)buyAction {
    //如果用户ID存在的话，说明已登陆
    if ([Utils isUserLogin]) {
        
        if (![Utils isBlankString:self.detailModel.select_skus]) {
            [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
            //添加购物车
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"is_fastbuy", @"btype",
                                 [UserInfo share].userID, @"memberID",
                                 self.detailModel.select_skusID, @"product_id",
                                 self.detailModel.select_count, @"num",
                                 nil];
            [[NetworkManager sharedManager] postJSON:URL_AddCartGoods parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
                
                if (status == Request_Success) {

                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UserInfo share].userID, @"memberID",
                                         nil];
                    [[NetworkManager sharedManager] postJSON:URL_GetOrderAddress parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
                        
                        [JHHJView hideLoading]; //结束加载
                        
                        if (status == Request_Success) {
                            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ImageJumpAnimation"];
                            
                            NSMutableArray *dataArr = [AddressModel mj_objectArrayWithKeyValuesArray:responseData];
                            if (dataArr.count==0) {
                                //跳新建地址页
                                EditAddressVC *editAddressVC = [[EditAddressVC alloc] init];
                                editAddressVC.from = @"商品详情";
                                [self.navigationController pushViewController:editAddressVC animated:YES];
                            } else {
                                //跳订单确认页
//                                [BaseWebVC showWithContro:self withUrlStr:HTML_OrderConfirmPage withTitle:@"" isPresent:NO];
                                OrderConfirmVC *orderConfirmVC = [[OrderConfirmVC alloc] init];
                                orderConfirmVC.from = @"商品详情";
                                orderConfirmVC.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:orderConfirmVC animated:YES];
                            }
                        }
                    }];
                } else {
                    [JHHJView hideLoading]; //结束加载
                }
            }];
        } else {
            //self.tableView.contentOffset = CGPointMake(0, 0);
            [self open];
        }
    } else {
        [self jumpLogin]; //跳到登录
    }
}

//查看全部收藏
- (void)showAllFav {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ImageJumpAnimation"];
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",HTML_GoodsDetailFav,self.goodsModel.ID] withTitle:@"喜欢商品的人" isPresent:NO withShareContent:@""];
}

//查看全部评论
- (void)showAllComment {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ImageJumpAnimation"];
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",HTML_GoodsDetailComment,self.goodsModel.ID] withTitle:@"全部评论" isPresent:NO withShareContent:@""];
}

//跳到登录
- (void)jumpLogin {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ImageJumpAnimation"];
    //跳到登录页面
    LoginVC *loginVC = [[LoginVC alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:NO];
}

#pragma mark - 懒加载

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
        
        //底部背景
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
        _navigationView.backgroundColor = [UIColor whiteColor];
        _navigationView.layer.borderColor = LineColor.CGColor;
        _navigationView.layer.borderWidth = 0.3;
        _navigationView.alpha = 0;
        [_headerView addSubview:_navigationView];
        
        //标题
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
        _titleLab.text = @"商品详情";
        _titleLab.alpha = 0;
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = kFont18Size;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:_titleLab];
        
        //返回按钮
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"BackAlpha"] forState:UIControlStateNormal];
        _backBtn.frame = CGRectMake(16, 27, 30, 30);
        _backBtn.userInteractionEnabled = NO;
        [_headerView addSubview:_backBtn];
        UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 50)];
        [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:back];
        
        //分享按钮
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"ShareAlpha"] forState:UIControlStateNormal];
        _shareBtn.frame = CGRectMake(WIDTH-46, 27, 30, 30);
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.userInteractionEnabled = NO;
        [_headerView addSubview:_shareBtn];
    }
    return _headerView;
}

- (UILabel *)pageLab {
    if (!_pageLab) {
        _pageLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-50, WIDTH-50, 35, 35)];
        _pageLab.backgroundColor = PageColor;
        _pageLab.layer.cornerRadius = _pageLab.width/2;
        [_pageLab.layer setMasksToBounds:YES];
        _pageLab.textAlignment = NSTextAlignmentCenter;
        _pageLab.textColor = LightBlackColor;
        _pageLab.font = kFont12Size;
    }
    return _pageLab;
}

#pragma mark - init view

- (void)initView {
    _bgView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_bgView];
    
    /*-----------商品详情-----------*/
    
    //所有内容的view
    _allContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1512)];
    _allContentView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_allContentView];
    
    //上UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_allContentView addSubview:self.tableView];
    
    _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    _tableFooterView.alpha = 0;
    _tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = _tableFooterView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 21.5, WIDTH-20, 0.5)];
    lineView.backgroundColor = LineColor;
    lineView.alpha = 0.3;
    [_tableFooterView addSubview:lineView];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-90, 14, 180, 16)];
    tipLab.font = kFont13Size;
    tipLab.backgroundColor = PageColor;
    tipLab.text = @"继续拖动，查看图文详情";
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = LightBlackColor;
    [_tableFooterView addSubview:tipLab];
    
    //下UIWebView
    self.detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.tableView.maxY+64, WIDTH, HEIGHT-64-49)];
    self.detailWebView.alpha = 0;
    self.detailWebView.opaque = NO; //不设置这个值 页面背景始终是白色
    self.detailWebView.backgroundColor = [UIColor clearColor];
    self.detailWebView.delegate = self;
    self.detailWebView.scrollView.delegate = self;
    self.detailWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.detailWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.detailWebView setScalesPageToFit:YES];
    self.detailWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    [_allContentView addSubview:self.detailWebView];
    
    _bottomMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -END_DRAG_SHOW_HEIGHT, SCREEN_WIDTH, END_DRAG_SHOW_HEIGHT)];
    _bottomMsgLabel.font = kFont13Size;
    _bottomMsgLabel.textAlignment = NSTextAlignmentCenter;
    _bottomMsgLabel.text = @"下拉返回商品详情";
    [self.detailWebView.scrollView addSubview:_bottomMsgLabel];
    
    /*-----------下架视图-----------*/
    [self initXiajiaView];
    
    /*-----------底部视图-----------*/
    [self initFooterView];
    
    /*------------导航条-----------*/
    [self initNav];
}

//下架视图
- (void)initXiajiaView {
    _xiajiaView = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT-49-44, WIDTH, 44)];
    _xiajiaView.hidden = YES;
    _xiajiaView.backgroundColor = kColorFromRGBHex(0xfdfae7);
    _xiajiaView.text = @"该商品已下柜，非常抱歉！";
    _xiajiaView.textColor = kColorFromRGBHex(0xda8f4c);
    _xiajiaView.textAlignment = NSTextAlignmentCenter;
    _xiajiaView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_xiajiaView];
}

//导航条
- (void)initNav {
    
    [self.view addSubview:self.headerView];
    _headerView.hidden = YES;
    
//    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
//    [[UIApplication sharedApplication].keyWindow addSubview:_headerView];
//    
//    //底部背景
//    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
//    _navigationView.backgroundColor = [UIColor whiteColor];
//    _navigationView.layer.borderColor = LineColor.CGColor;
//    _navigationView.layer.borderWidth = 0.3;
//    _navigationView.alpha = 0;
//    [_headerView addSubview:_navigationView];
//    
//    //标题
//    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
//    _titleLab.text = @"商品详情";
//    _titleLab.alpha = 0;
//    _titleLab.textColor = [UIColor blackColor];
//    _titleLab.font = kFont18Size;
//    _titleLab.textAlignment = NSTextAlignmentCenter;
//    [_headerView addSubview:_titleLab];
//    
//    //返回按钮
//    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_backBtn setImage:[UIImage imageNamed:@"BackAlpha"] forState:UIControlStateNormal];
//    _backBtn.frame = CGRectMake(16, 27, 30, 30);
//    _backBtn.userInteractionEnabled = NO;
//    [_headerView addSubview:_backBtn];
//    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 50)];
//    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [_headerView addSubview:back];
//    
//    //分享按钮
//    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_shareBtn setImage:[UIImage imageNamed:@"ShareAlpha"] forState:UIControlStateNormal];
//    _shareBtn.frame = CGRectMake(WIDTH-46, 27, 30, 30);
//    [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
//    _shareBtn.userInteractionEnabled = NO;
//    [_headerView addSubview:_shareBtn];
}

//底部视图
- (void)initFooterView {

    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-BOTTOM_VIEW_HEIGHT, WIDTH, BOTTOM_VIEW_HEIGHT)];
    _footerView.alpha = 0;
    _footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footerView];
    
    UIView *rowLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    rowLine.backgroundColor = LineColor;
    rowLine.alpha = 0.6;
    [_footerView addSubview:rowLine];
    
    //聊天
    _chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH/6, BOTTOM_VIEW_HEIGHT)];
    [_chatBtn setImage:[UIImage imageNamed:@"ChatGray"] forState:UIControlStateNormal];
    [_chatBtn addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_chatBtn];
    
    UIView *colLine = [[UIView alloc] initWithFrame:CGRectMake(_chatBtn.maxX, 0, 0.5, BOTTOM_VIEW_HEIGHT)];
    colLine.backgroundColor = LineColor;
    colLine.alpha = 0.6;
    [_footerView addSubview:colLine];
    
    //购物车
    _cartBtn = [[UIButton alloc] initWithFrame:CGRectMake(colLine.maxX, 0, WIDTH/6, BOTTOM_VIEW_HEIGHT)];
    [_cartBtn setImage:[UIImage imageNamed:@"CartGray"] forState:UIControlStateNormal];
    [_cartBtn addTarget:self action:@selector(cartAction) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_cartBtn];
    
    //数量提示
//    _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/12+4, 8, 16, 16)];
//    _countBtn.hidden = YES;
//    _countBtn.backgroundColor = [UIColor whiteColor];
//    _countBtn.titleLabel.font = kFont10Size;
//    [_countBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
//    _countBtn.layer.cornerRadius = 8;
//    _countBtn.layer.borderColor = AppThemeColor.CGColor;
//    _countBtn.layer.borderWidth = 1;
//    _countBtn.userInteractionEnabled = NO;
//    [_cartBtn addSubview:_countBtn];
    
    _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/12+1, 8, 16, 16)];
    _countBtn.hidden = YES;
    _countBtn.backgroundColor = LightYellowColor;
    _countBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_countBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _countBtn.layer.cornerRadius = 8;
    _countBtn.userInteractionEnabled = NO;
    [_cartBtn addSubview:_countBtn];
    
    UIView *colLine1 = [[UIView alloc] initWithFrame:CGRectMake(_cartBtn.maxX, 0, 0.5, BOTTOM_VIEW_HEIGHT)];
    colLine1.backgroundColor = LineColor;
    colLine1.alpha = 0.4;
    [_footerView addSubview:colLine1];
    
    //关注
//    _collectBtn = [[AEEmitterButton alloc] initWithFrame:CGRectMake(colLine1.maxX, 0, BOTTOM_VIEW_HEIGHT, BOTTOM_VIEW_HEIGHT)];
//    [_collectBtn setImage:[UIImage imageNamed:@"CollectGray"] forState:UIControlStateNormal];
//    [_collectBtn setImage:[UIImage imageNamed:@"CollectRed"] forState:UIControlStateSelected];
//    [_collectBtn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
//    [_footerView addSubview:_collectBtn];
    
//    UIView *colLine2 = [[UIView alloc] initWithFrame:CGRectMake(_collectBtn.maxX, 0, 0.5, BOTTOM_VIEW_HEIGHT)];
//    colLine2.backgroundColor = LineColor;
//    colLine2.alpha = 0.6;
//    [_footerView addSubview:colLine2];
    
    //加入购物车
    _addCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(_cartBtn.maxX, 0, WIDTH/3, BOTTOM_VIEW_HEIGHT)];
    //_addCartBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.55]; //kColorFromRGBHex(0xfff0f0)
    _addCartBtn.backgroundColor = [UIColor clearColor];
    [_addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_addCartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _addCartBtn.titleLabel.font = kFont14Size;
    [_addCartBtn addTarget:self action:@selector(addCartAction) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_addCartBtn];
    
    //立即购买
    _buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(_addCartBtn.maxX, 0, WIDTH/3, BOTTOM_VIEW_HEIGHT)];
    _buyBtn.backgroundColor = LightYellowColor;
    [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _buyBtn.titleLabel.font = kFont14Size;
    [_buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_buyBtn];
}

//促销视图
- (UIView *)promotionView {
    if (!_promotionView) {
        _promotionView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, HEIGHT/2-50)];
        _promotionView.backgroundColor = [UIColor whiteColor];
        
        NSArray *goodsPro = _detailModel.promotion[@"goods"];
        
        for (int i=0; i<goodsPro.count; i++) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*i, WIDTH, 50)];
            [_promotionView addSubview:bgView];
            
            CGSize tagSize = [goodsPro[i][@"tag"] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFont11Size} context:nil].size;
            UILabel *tagLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 17.5, tagSize.width+4, 15)];
            tagLab.layer.cornerRadius = 2;
            tagLab.font = kFont11Size;
            tagLab.layer.borderWidth = 0.5;
            tagLab.layer.borderColor = AppThemeColor.CGColor;
            tagLab.textAlignment = NSTextAlignmentCenter;
            tagLab.textColor = AppThemeColor;
            tagLab.text = goodsPro[i][@"tag"];
            [bgView addSubview:tagLab];
            
            UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(tagLab.maxX+5, 17.5, WIDTH-30-tagSize.width, 15)];
            contentLab.textColor = AppThemeColor;
            contentLab.font = kFont14Size;
            contentLab.text = goodsPro[i][@"name"];
            [bgView addSubview:contentLab];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, WIDTH, 0.5)];
            lineView.backgroundColor = LineColor;
            lineView.alpha = 0.3;
            [bgView addSubview:lineView];
        }
        
        UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT/2-49, WIDTH, 49)];
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        doneBtn.backgroundColor = AppThemeColor;
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [doneBtn addTarget:self action:@selector(closeProView) forControlEvents:UIControlEventTouchUpInside];
        doneBtn.hidden = YES;
        [_promotionView addSubview:doneBtn];
    }
    return _promotionView;
}

//选择规格视图
- (UIView *)popView {
    if (!_popView) {
        _popView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _specHeight+BOTTOM_VIEW_HEIGHT)];
        _popView.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, WIDTH, _specHeight-30)];
        bgView.backgroundColor = [UIColor whiteColor];
        [_popView addSubview:bgView];
        
        NSArray *skus = self.detailModel.skus;
        GoodsSkusModel *skusModel = skus[self.detailModel.select_skusIndex];
        
        //图片
        _goodsIcon = [[TapImageView alloc] initWithFrame:CGRectMake(15, 0, 100, 100)];
        _goodsIcon.tag = 100;
        _goodsIcon.t_delegate = self;
        _goodsIcon.layer.cornerRadius = 5;
        [_goodsIcon.layer setMasksToBounds:YES];
        _goodsIcon.backgroundColor = PageColor;
        [_popView addSubview:_goodsIcon];
        
        NSString *picUrl = @"";
        NSArray *itemImages = skusModel.spec_goods_images; //选中规格图片数组
        if (itemImages.count>0) {
            picUrl = [NSString stringWithFormat:@"%@%@",PictureUrl,itemImages[0]];
        } else {
            if (self.detailModel.spec_info.count==0) {
                if (self.detailModel.item_imgs.count>0) {
                    picUrl = [NSString stringWithFormat:@"%@%@",PictureUrl,self.detailModel.item_imgs[0][@"thisuasm_url"]];
                } else {
                    picUrl = self.goodsModel.icon;
                }
            }
        }
        [_goodsIcon sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
        
//        if (self.detailModel.spec_info.count==0) { //如果没有规格，显示图片轮播的第一张图片
//            NSString *picUrl = @"";
//            NSArray *itemImages = self.detailModel.item_imgs; //图片轮播数组
//            if (itemImages.count>0) {
//                picUrl = [NSString stringWithFormat:@"%@%@",PictureUrl,itemImages[0][@"thisuasm_url"]];
//            } else {
//                picUrl = self.goodsModel.icon;
//            }
//            [_goodsIcon sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
//        }
        
        //删除图标
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-30, 43, 16, 16)];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
        _deleteBtn.userInteractionEnabled = NO;
        [_popView addSubview:_deleteBtn];
        UIButton *clickCloseBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-55, 38, 50, 50)];
        [clickCloseBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_popView addSubview:clickCloseBtn];
        
        //标题
        CGFloat nameH = [Utils getTextHeight:self.detailModel.title font:kFont14Size forWidth:WIDTH-190];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_goodsIcon.maxX+15, 10, WIDTH-190, nameH)];
        _titleLabel.text = self.detailModel.title;
        _titleLabel.font = kFont14Size;
        _titleLabel.textColor = LightBlackColor;
        _titleLabel.numberOfLines = 0;
        [bgView addSubview:_titleLabel];
        
        //价格
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_goodsIcon.maxX+15, _titleLabel.maxY+15, WIDTH-190, 20)];
        _priceLabel.text = [NSString stringWithFormat:@"￥%@",self.detailModel.price];
        _priceLabel.textColor = AppThemeColor;
        _priceLabel.font = kFont14Size;
        [bgView addSubview:_priceLabel];
        
        //规格
        UIView *specView = [[UIView alloc] initWithFrame:CGRectMake(0, _goodsIcon.maxY, WIDTH, 0)];
        [bgView addSubview:specView];
        
        NSArray *specArr = self.detailModel.spec_info;
        CGFloat itemHeight = _goodsIcon.maxY;
        if (specArr.count>0) {
            for (int i=0; i<specArr.count; i++) {
                GoodsSpecInfoModel *specInfo = specArr[i];
                //热门搜索
                UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, itemHeight, WIDTH, 50)];
                [bgView addSubview:itemView];
                
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 20)];
                titleLab.text = specInfo.spec_name;
                titleLab.font = kFont14Size;
                titleLab.textColor = LightBlackColor;
                [itemView addSubview:titleLab];
                
                NSMutableArray *array = [NSMutableArray array];
                NSArray *itemsArr = specInfo.spec_values;
                for (int j=0; j<itemsArr.count; j++) {
                    GoodsSpecModel *spec = itemsArr[j];
                    [array addObject:spec.spec_value];
                    if ([skusModel.properties containsString:spec.properties]) {
                        //选中品牌
                        specInfo.select_index = j;
//                        if (i==0) {
//                            [_goodsIcon sd_setImageWithURL:[NSURL URLWithString:spec.spec_image] placeholderImage:nil];
//                        }
                    }
                }
                
                AEFlowLayoutView *specFlowView = [[AEFlowLayoutView alloc] initWithFrame:CGRectMake(0, titleLab.maxY-8, WIDTH, 50) andDefaultIndex:specInfo.select_index]; //高度由内容定
                specFlowView.tag = 100000+i;
                specFlowView.isSelected = YES;
                specFlowView.array = array;
                specFlowView.delegate = self;
                [itemView addSubview:specFlowView];
                
                itemView.height = specFlowView.maxY+3;
                specView.height += itemView.height;
                
                if (i!=specArr.count-1) {
                    itemHeight += itemView.height;
                }
            }
            
            _specHeight +=specView.height;
            _popView.height = _specHeight;
            bgView.height +=specView.height;
        }
        
        //数量
        UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(0, specView.maxY+5, WIDTH, 55)];
        [bgView addSubview:countView];
        
        UILabel *countFlag = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 15)];
        countFlag.text = @"数量";
        countFlag.textColor = LightBlackColor;
        countFlag.font = kFont14Size;
        [countView addSubview:countFlag];
        
        UIButton *reduceBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, countFlag.maxY+10, 28, 28)];
        [reduceBtn addTarget:self action:@selector(reduceNumForCell:) forControlEvents:UIControlEventTouchUpInside];
        [countView addSubview:reduceBtn];
        
        _goodsNumTF = [[UITextField alloc]initWithFrame:CGRectMake(reduceBtn.maxX, countFlag.maxY+10, 56, 28)];
        _goodsNumTF.text = self.detailModel.select_count;
        _goodsNumTF.textColor = LightBlackColor;
        _goodsNumTF.keyboardType = UIKeyboardTypeNumberPad;
        _goodsNumTF.textAlignment = NSTextAlignmentCenter;
        _goodsNumTF.font = kFont13Size;
        _goodsNumTF.delegate = self;
        _goodsNumTF.backgroundColor = [UIColor clearColor];
        _goodsNumTF.userInteractionEnabled = NO;
        [countView addSubview:_goodsNumTF];
        
        UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(_goodsNumTF.maxX, countFlag.maxY+10, 28, 28)];
        [addBtn addTarget:self action:@selector(addNumForCell:) forControlEvents:UIControlEventTouchUpInside];
        [countView addSubview:addBtn];
        
        _goodsNumTF.height = 28;
        _goodsNumTF.centerY = addBtn.centerY;
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15, countFlag.maxY+10, 28, _goodsNumTF.height)];
        img.image = [UIImage imageNamed:@"Sub"];
        img.centerY = _goodsNumTF.centerY;
        [countView addSubview:img];
        
        UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(_goodsNumTF.maxX, countFlag.maxY+10, 28, _goodsNumTF.height)];
        img1.image = [UIImage imageNamed:@"Add"];
        img1.centerY = _goodsNumTF.centerY;
        [countView addSubview:img1];
        
        //库存
        UILabel *storeFlag = [[UILabel alloc] initWithFrame:CGRectMake(img1.maxX+15, countFlag.maxY+10, 40, _goodsNumTF.height)];
        storeFlag.text = @"库存：";
        storeFlag.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        storeFlag.font = kFont13Size;
        [countView addSubview:storeFlag];
        
        _storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(storeFlag.maxX, countFlag.maxY+10, 40, _goodsNumTF.height)];
        _storeLabel.text = self.detailModel.realStore; //显示库存=实际库存-冻结库存
        _storeLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        _storeLabel.font = kFont13Size;
        [countView addSubview:_storeLabel];
    }
    
    return _popView;
}

#pragma mark - AEFlowLayoutViewDelegate
//跳转到商品列表
- (void)clickFlowLayout:(AEButton *)sender {
    NSLog(@"%@  %@",sender.idStr,sender.name);
    
    //记录点击的哪种品牌视图
    AEFlowLayoutView *specFlowView = (AEFlowLayoutView *)[sender superview];
    int index = (int)specFlowView.tag-100000;
    
    //记录点击的哪种品牌
    NSArray *specArr = self.detailModel.spec_info;
    GoodsSpecInfoModel *specInfo = specArr[index];
    specInfo.select_index = [sender.idStr intValue];
    
//    if (index==0) { //取第一个品牌的图片
//        //改变图片
//        GoodsSpecModel *spec = specInfo.spec_values[specInfo.select_index];
//        [_goodsIcon sd_setImageWithURL:[NSURL URLWithString:spec.spec_image] placeholderImage:nil];
//    }
    
    //记录选择的规格
    NSString *selectSkus = @"";
    for (int i = 0; i<specArr.count; i++) {
        GoodsSpecInfoModel *specInfo = specArr[i];
        GoodsSpecModel *spec = specInfo.spec_values[specInfo.select_index];
        if (i==0) {
            selectSkus = [NSString stringWithFormat:@"%@",spec.properties];
        } else {
            selectSkus = [NSString stringWithFormat:@"%@;%@",selectSkus,spec.properties];
        }
    }
    
    NSArray *skus = self.detailModel.skus;
    for (int i=0; i<skus.count; i++) {
        GoodsSkusModel *skusModel = skus[i];
        if ([skusModel.properties isEqualToString:selectSkus]) {
            self.detailModel.select_skusIndex = i;
            self.detailModel.select_skusID = skusModel.sku_id;
            self.detailModel.select_skusImgs = skusModel.spec_goods_images;
            self.detailModel.realStore = [NSString stringWithFormat:@"%d",[skusModel.store intValue]-[skusModel.freez intValue]];
            self.detailModel.price = skusModel.price; //价格、市场价格以规格为主
            self.detailModel.market_price = skusModel.market_price;
            if (skusModel.spec_goods_images.count>0) {
                [_goodsIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureUrl,skusModel.spec_goods_images[0]]] placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
            } else {
                _goodsIcon.image = [UIImage imageNamed:@"GoodsDefault"];
            }
            _priceLabel.text = [NSString stringWithFormat:@"￥%@",self.detailModel.price];
            
            if ([skusModel.marketable isEqualToString:@"false"]) { //商品下架
                [Utils showToast:@"该商品已下柜"];
                _shareBtn.userInteractionEnabled = NO;
                _addCartBtn.userInteractionEnabled = NO;
                _buyBtn.userInteractionEnabled = NO;
                _addCartBtn.backgroundColor = PageColor;
                [_addCartBtn setTitleColor:LightBlackColor forState:UIControlStateNormal];
                _buyBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
                [_buyBtn setTitleColor:LightBlackColor forState:UIControlStateNormal];
                
                _xiajiaView.hidden = NO;
            } else {
                _shareBtn.userInteractionEnabled = YES;
                _addCartBtn.userInteractionEnabled = YES;
                _buyBtn.userInteractionEnabled = YES;
                //_addCartBtn.backgroundColor = kColorFromRGBHex(0xfff0f0);
                //[_addCartBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
                //_buyBtn.backgroundColor = AppThemeColor;
                //[_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _addCartBtn.backgroundColor = [UIColor clearColor];
                [_addCartBtn setTitleColor:LightBlackColor forState:UIControlStateNormal];
                _buyBtn.backgroundColor = LightYellowColor;
                [_buyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                _xiajiaView.hidden = YES;
            }
            
            [self.tableView reloadData];
            
            //改变库存
            _storeLabel.text = self.detailModel.realStore; //显示库存=实际库存-冻结库存
        }
    }
}

- (void)reduceNumForCell:(UIButton *)sender {
    
    if ([_goodsNumTF.text integerValue]<2) {
        return;
    }
    
    _detailModel.select_count = [NSString stringWithFormat:@"%ld",[_goodsNumTF.text integerValue]-1];
    _goodsNumTF.text = self.detailModel.select_count;
}


- (void)addNumForCell:(UIButton *)sender {
    
    if ([_goodsNumTF.text integerValue]+1>999) {
        return;
    }
    
    if ([_goodsNumTF.text integerValue]+1>[_detailModel.realStore integerValue]) {
        [Utils showToast:@"库存不足"];
        return;
    }
    
    _detailModel.select_count = [NSString stringWithFormat:@"%ld",[_goodsNumTF.text integerValue]+1];
    _goodsNumTF.text = self.detailModel.select_count;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *str = [textField.text stringByAppendingString:string ];
    if (string.length==0&&textField.text.length==1) { //控制数量最少为0
        textField.text = @"0";
        return NO;
    }
    
    if (str.length>3) { //数量最大只能是3位数的数量
        return NO;
    }
    if ([str integerValue]>999) { //数量最大是999
        textField.text = @"999";
        return NO;
    }
    if ([str integerValue]>[_detailModel.realStore integerValue]) {
        [Utils showToast:@"库存不足"];
        return NO;
    }
    if (string.length>0) { //控制输入的数字 是非0开始
        textField.text = [NSString stringWithFormat:@"%ld",(long)[str integerValue]];
        return NO;
    }
    
    return YES;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-BOTTOM_VIEW_HEIGHT)];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.400];
        _maskView.alpha = 0.0f;
        
        // 添加点击背景按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-BOTTOM_VIEW_HEIGHT)];
        [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:btn];
    }
    return _maskView;
}

- (UIView *)maskView2 {
    if (!_maskView2) {
        _maskView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-BOTTOM_VIEW_HEIGHT)];
        _maskView2.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.400];
        _maskView2.alpha = 0.0f;
        
        // 添加点击背景按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-BOTTOM_VIEW_HEIGHT)];
        [btn addTarget:self action:@selector(closeProView) forControlEvents:UIControlEventTouchUpInside];
        [_maskView2 addSubview:btn];
    }
    return _maskView2;
}

#pragma mark - UITableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==4) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return WIDTH;
    } else if (section==1) {
        NSArray *goodsPro = _detailModel.promotion[@"goods"];
        if (goodsPro.count==0) {
            return CGFLOAT_MIN;
        } else {
            return 8;
        }
    } else if (section==3) {
        if ([_detailModel.favs_count intValue]==0) {
            return CGFLOAT_MIN;
        } else {
            return 8;
        }
    } else if (section==4) {
        if ([_detailModel.comments_count intValue]==0) {
            return CGFLOAT_MIN;
        } else {
            return 8;
        }
    } else {
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - 导航条以及图片轮播顶部视图

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH)];
        headView.backgroundColor = [UIColor clearColor];
        
        //图片轮播
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, WIDTH) delegate:self placeholderImage:nil];
        if (self.hideAnimation==YES) {
            _cycleScrollView.placeholderImage = [UIImage imageNamed:@"GoodsDefaultBig"];
        }
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.imageURLStringsGroup = _picArray;
        _cycleScrollView.delegate = self;
        _cycleScrollView.infiniteLoop = NO; //关闭无限循环
        _cycleScrollView.autoScroll = NO; //关闭自动滚动
        _cycleScrollView.pageDotColor = [UIColor whiteColor]; //分页控件小圆标颜色
        _cycleScrollView.currentPageDotColor = AppThemeColor;
        _cycleScrollView.pageControlDotSize = CGSizeMake(2, 2); //分页控件小圆标大小
        _cycleScrollView.showPageControl = NO;
        [headView addSubview:_cycleScrollView];
        
        topImgView = [[UIImageView alloc]initWithFrame:_cycleScrollView.frame];
        topImgView.backgroundColor = [UIColor clearColor];
        topImgView.userInteractionEnabled = NO;
        topImgView.hidden = YES;
        [self.view addSubview:topImgView];
    
        [headView addSubview:self.pageLab];
        _pageLab.hidden = !_isShowLab;
        _pageLab.text = [NSString stringWithFormat:@"%d/%d",_picIndex,(int)self.detailModel.item_imgs.count>0?(int)self.detailModel.item_imgs.count:1];
        
        _bgImgWidth=_cycleScrollView.frame.size.width;
        _bgImgHeight=_cycleScrollView.frame.size.height;
        
        return headView;
    } else {
        return [[UIView alloc] init];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"goodsDetailCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //添加箭头
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]; //cell选中背景颜色
    
    if (indexPath.section==0) { //商品信息
        cell.accessoryType = UITableViewCellAccessoryNone; //隐藏箭头
        
        CGFloat cellH = 0.f;
        NSString *name = _detailModel.title;
        CGSize nameSize = [name boundingRectWithSize:CGSizeMake(WIDTH-70,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont16Size,NSFontAttributeName,nil] context:nil].size;
        CGFloat nameH = nameSize.height;
        if ([Utils isBlankString:_detailModel.title]) {
            cellH = 20+20+10+30+20+20+45;
        } else {
            cellH = 20+nameH+10+30+20+20+45;
        }
        
        _detailCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, cellH)];
        [cell addSubview:_detailCell];
        
        if ([Utils isBlankString:_detailModel.title]) {
            _detailCell.alpha = 0;
        } else {
            _detailCell.alpha = 1;
        }
        
        //名称
        UILabel *nameLab = [[UILabel alloc] init];
        if ([Utils isBlankString:_detailModel.title]) {
            nameLab.frame = CGRectMake(15, 20, WIDTH-70, 20);
        } else {
            nameLab.frame = CGRectMake(15, 20, WIDTH-70, nameH);
        }
        nameLab.numberOfLines = 0;
        nameLab.font = kFont16Size;
        nameLab.text = name;
        nameLab.textColor = [UIColor blackColor];
        [_detailCell addSubview:nameLab];
        
        //配货说明
        NSString *peihuo = _detailModel.brief;
        UILabel *peihuoLab = [[UILabel alloc] initWithFrame:CGRectMake(15, nameLab.maxY+10, WIDTH-70, 15)];
        if ([Utils isBlankString:_detailModel.brief]) {
            peihuoLab.frame = CGRectMake(15, nameLab.maxY+5, WIDTH-70, 0);
        }
        peihuoLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        peihuoLab.text = peihuo;
        peihuoLab.font = kFont13Size;
        [_detailCell addSubview:peihuoLab];
        
        //价格
        UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(13, peihuoLab.maxY+15, 100, 20)];
        priceLab.textColor = PriceRedColor;
        priceLab.font = kFont15Size;
        [_detailCell addSubview:priceLab];
        
        //市场价格
        UILabel *mktpriceLab = [[UILabel alloc] initWithFrame:CGRectMake(priceLab.maxX+5, peihuoLab.maxY+12, 90, 20)];
        mktpriceLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        mktpriceLab.font = kFont12Size;
        [_detailCell addSubview:mktpriceLab];
        
        //删除线
        UIView *deleteView = [[UIView alloc] initWithFrame:CGRectZero];
        deleteView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        [_detailCell addSubview:deleteView];
        
        //收藏图标
        _collectBtn = [[AEEmitterButton alloc] initWithFrame:CGRectZero];
        [_collectBtn setImage:[UIImage imageNamed:@"CollectGray"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"CollectRed"] forState:UIControlStateSelected];
        [_collectBtn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
        [_detailCell addSubview:_collectBtn];
        if ([Utils isBlankString:_isGoodsFav]) {
            _collectBtn.alpha = 0;
        } else {
            _collectBtn.alpha = 1;
        }
        
        //收藏人数
        UILabel *countLab = [[UILabel alloc] initWithFrame:CGRectZero];
        countLab.font = kFont12Size;
        countLab.textColor = LightBlackColor;
        countLab.textAlignment = NSTextAlignmentCenter;
        [_detailCell addSubview:countLab];
        
        NSString *priceStr;
        if ([Utils isBlankString:_detailModel.price]) {
            priceStr = @"";
        } else {
            priceStr = [NSString stringWithFormat:@"￥%@",_detailModel.price];
        }
        CGSize priceSize = [priceStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont15Size,NSFontAttributeName,nil] context:nil].size;
        priceLab.width = priceSize.width;
        priceLab.text = priceStr;
        
        NSString *mktpriceStr;
        if ([Utils isBlankString:_detailModel.market_price]||[_detailModel.market_price floatValue]==0.00) {
            //mktpriceStr = @"";
            mktpriceStr = [NSString stringWithFormat:@"￥%@",_detailModel.price];
        } else {
            mktpriceStr = [NSString stringWithFormat:@"￥%@",_detailModel.market_price];
        }
        CGSize mktpriceSize = [mktpriceStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont12Size,NSFontAttributeName,nil] context:nil].size;
        mktpriceLab.frame = CGRectMake(priceLab.maxX+8, peihuoLab.maxY+18, mktpriceSize.width, 16);
        mktpriceLab.text = mktpriceStr;
        
        deleteView.frame = CGRectMake(priceLab.maxX+6, peihuoLab.maxY+18+8, mktpriceSize.width+5, 0.5);
        
        _collectBtn.frame = CGRectMake(WIDTH-50, priceLab.maxY-46, 30, 30);
        if ([_isGoodsFav isEqualToString:@"0"]) {
            _collectBtn.selected = NO;
        } else {
            _collectBtn.selected = YES;
        }
        
        countLab.text = _detailModel.favs_count;
        countLab.frame = CGRectMake(_collectBtn.x, priceLab.maxY-18, 100, 16);
        countLab.centerX = _collectBtn.centerX;
        
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, priceLab.maxY+15, WIDTH, 0.5)]; //0.4
        lineView.backgroundColor = LineColor;
        lineView.alpha = 0.5;
        [_detailCell addSubview:lineView];
        
        //品牌
        NSArray *arr = @[@"原创设计",@"全场包邮",@"三十天无理由退货"];
        
        CGFloat width0 = [Utils getSizeByString:arr[0] AndFontSize:13].width;
        CGFloat width1 = [Utils getSizeByString:arr[1] AndFontSize:13].width;
        CGFloat width2 = [Utils getSizeByString:arr[2] AndFontSize:13].width;
        
        CGFloat offX = (WIDTH-20*3-width0-width1-width2)/4;
        
        for (NSInteger i = 0; i < arr.count; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i==0) {
                btn.frame = CGRectMake(2+offX, lineView.maxY, 20+width0, 50);
            }
            if (i==1) {
                btn.frame = CGRectMake(2+offX*2+20+width0, lineView.maxY, 20+width1, 50);
            }
            if (i==2) {
                btn.frame = CGRectMake(2+offX*3+20*2+width0+width1, lineView.maxY, 20+width2, 50);
            }
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = kFont13Size;
            [btn setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.titleLabel.bounds.size.width+12, 0, 0);
            [_detailCell addSubview:btn];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), lineView.maxY+18.5, 13, 13)];
            imgView.image = [UIImage imageNamed:@"CheckFlag"];
            //imgView.image = [UIImage imageNamed:@"Oval"];
            [_detailCell addSubview:imgView];
        }
    }
    if (indexPath.section==1) { //促销
        _promoCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
        [cell addSubview:_promoCell];
        
        NSString *tag = @"";
        NSString *name = @"";
        NSArray *goodsPro = _detailModel.promotion[@"goods"];
        if (goodsPro.count==0) {
            _promoCell.alpha = 0;
            cell.accessoryType = UITableViewCellAccessoryNone; //隐藏箭头
        } else {
            _promoCell.alpha = 1;
            tag = goodsPro[0][@"tag"];
            name = goodsPro[0][@"name"];
        }
        
        NSString *proCount = [NSString stringWithFormat:@"%d个促销：",(int)goodsPro.count];
        CGSize proSize = [proCount boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFont14Size} context:nil].size;
        UILabel *promotionLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, proSize.width, 50)];
        promotionLab.font = kFont14Size;
        promotionLab.text = proCount;
        promotionLab.textColor = LightBlackColor;
        [_promoCell addSubview:promotionLab];
        
        CGSize tagSize = [tag boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFont11Size} context:nil].size;
        UILabel *tagLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 17.5, tagSize.width+4, 15)];
        tagLab.layer.cornerRadius = 2;
        tagLab.font = kFont11Size;
        tagLab.layer.borderWidth = 0.5;
        tagLab.layer.borderColor = AppThemeColor.CGColor;
        tagLab.textAlignment = NSTextAlignmentCenter;
        tagLab.textColor = AppThemeColor;
        tagLab.text = tag;
        [_promoCell addSubview:tagLab];
        
        UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(tagLab.maxX+5, 17.5, WIDTH-30-tagSize.width, 15)];
        contentLab.textColor = AppThemeColor;
        contentLab.font = kFont13Size;
        contentLab.text = name;
        [_promoCell addSubview:contentLab];
    }
    if (indexPath.section==2) { //规格
        _specCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
        [cell addSubview:_specCell];
        
        if ([Utils isBlankString:_detailModel.title]) {
            _specCell.alpha = 0;
            cell.accessoryType = UITableViewCellAccessoryNone; //隐藏箭头
        } else {
            _specCell.alpha = 1;
        }
        
        UILabel *guigeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 50)];
        guigeLab.font = kFont14Size;
        guigeLab.text = @"已选择：";
        guigeLab.textColor = LightBlackColor;
        [_specCell addSubview:guigeLab];
        
        UILabel *ruleLab = [[UILabel alloc] initWithFrame:CGRectMake(guigeLab.maxX, 0, WIDTH-120, 50)];
        ruleLab.font = kFont14Size;
        ruleLab.textColor = LightBlackColor;
        ruleLab.text = self.detailModel.select_skus;
        [_specCell addSubview:ruleLab];
    }
    if (indexPath.section==3) { //喜欢
        cell.accessoryType = UITableViewCellAccessoryNone; //隐藏箭头
        
        _favCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 95)];
        [cell addSubview:_favCell];
        
        if ([_detailModel.favs_count intValue]==0) {
            _favCell.alpha = 0;
        } else {
            _favCell.alpha = 1;
        }
        
        UILabel *countLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, WIDTH-30, 20)];
        countLab.font = kFont14Size;
        countLab.text = [NSString stringWithFormat:@"喜欢 (%@)",_detailModel.favs_count];
        countLab.textColor = LightBlackColor;
        [_favCell addSubview:countLab];
        
        int favShowCount = 7;
        if (_favArr.count<=6) {
            favShowCount = (int)_favArr.count+1;
        }
        
        CGFloat favWidth = (WIDTH-15*2-10*7)/8;
        for (int i = 0; i<favShowCount; i++) {
            UIButton *favBtn = [[UIButton alloc] initWithFrame:CGRectMake(15+(favWidth+10)*i, countLab.maxY+10, favWidth, favWidth)];
            favBtn.layer.cornerRadius = favBtn.frame.size.width/2;
            [favBtn.layer setMasksToBounds:YES];
            [_favCell addSubview:favBtn];
            
            if (i!=favShowCount-1) {
                GoodsFavModel *favModel = _favArr[i];
                [favBtn sd_setImageWithURL:[NSURL URLWithString:favModel.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"MineHeadIcon"]];
            } else {
                [favBtn setImage:[UIImage imageNamed:@"FavMore"] forState:UIControlStateNormal];
                [favBtn addTarget:self action:@selector(showAllFav) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    if (indexPath.section==4) { //评论
        _commentCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44+145)];
        [cell addSubview:_commentCell];
        
        if ([_detailModel.comments_count intValue]==0) {
            _commentCell.alpha = 0;
            cell.accessoryType = UITableViewCellAccessoryNone; //隐藏箭头
        } else {
            _commentCell.alpha = 1;
        }
        
        if (indexPath.row==0) {
            
            UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH-30, 44)];
            commentLab.font = kFont14Size;
            commentLab.text = [NSString stringWithFormat:@"评论 (%d)",[_detailModel.comments_count intValue]];
            commentLab.textColor = LightBlackColor;
            [_commentCell addSubview:commentLab];
            
            //查看全部
            UIButton *showAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-120, 0, 100, 44)];
            [showAllBtn setTitle:@"查看全部" forState:UIControlStateNormal];
            [showAllBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7] forState:UIControlStateNormal];
            showAllBtn.titleLabel.font = kFont13Size;
            [showAllBtn addTarget:self action:@selector(showAllComment) forControlEvents:UIControlEventTouchUpInside];
            [_commentCell addSubview:showAllBtn];
            
            //分割线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, commentLab.maxY-0.5, WIDTH-15, 0.5)];
            lineView.backgroundColor = LineColor;
            lineView.alpha = 0.3;
            [_commentCell addSubview:lineView];
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone; //隐藏箭头
            
            //头像
            CGFloat favWidth = (WIDTH-15*2-10*7)/8;
            UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, favWidth, favWidth)];
            headImageView.layer.cornerRadius = favWidth/2;
            [headImageView.layer setMasksToBounds:YES];
            [headImageView sd_setImageWithURL:[NSURL URLWithString:_commentModel.url] placeholderImage:[UIImage imageNamed:@"MineHeadIcon"]];
            [_commentCell addSubview:headImageView];
            
            //昵称
            UILabel *nickLab = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.maxX+10, 10, 120, 35)];
            nickLab.text = _commentModel.author;
            nickLab.textColor = LightBlackColor;
            nickLab.font = kFont14Size;
            [_commentCell addSubview:nickLab];
            
            //时间
            UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-165, 10, 150, 35)];
            timeLab.textAlignment = NSTextAlignmentRight;
            timeLab.text = _commentModel.time;
            timeLab.font = kFont13Size;
            timeLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
            [_commentCell addSubview:timeLab];
            
            //内容
            NSString *content = _commentModel.comment;
            CGFloat contentH = [Utils getTextHeight:content font:kFont14Size forWidth:WIDTH-30];
            UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(15, headImageView.maxY+10, WIDTH-30, contentH)];
            contentLab.numberOfLines = 0;
            contentLab.text = content;
            contentLab.font = kFont14Size;
            contentLab.textColor = LightBlackColor;
            [_commentCell addSubview:contentLab];
            
            //规格
            UILabel *specLab = [[UILabel alloc] initWithFrame:CGRectMake(15, nickLab.maxY+10, WIDTH-100, 15)];
            specLab.text = _commentModel.spec_info;
            specLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
            specLab.font = kFont13Size;
            [_commentCell addSubview:specLab];
            
            if (_commentModel.images.count>0) { //如果有图片
                CGFloat imgWidth = (WIDTH-15*6)/5;
                specLab.frame = CGRectMake(15, contentLab.maxY+10+imgWidth+10, WIDTH-30, 15);
                //图片(最多展示5张)
                _ivArr = [NSMutableArray array];
                for (int i = 0; i<_commentModel.images.count; i++) {
                    TapImageView *imageView = [[TapImageView alloc] initWithFrame:CGRectMake((15+imgWidth)*i+15, contentLab.maxY+10, imgWidth, imgWidth)];
                    imageView.backgroundColor = PageColor;
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureUrl,_commentModel.images[i]]] placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
                    imageView.tag = 100000+i;
                    imageView.t_delegate = self;
                    [_commentCell addSubview:imageView];
                    
                    [_ivArr addObject:imageView];
                    //[_ivArr addObject:[NSString stringWithFormat:@"%@%@",PictureUrl,_commentModel.images[i]]];
                }
                NSLog(@"");
            } else {
                specLab.frame = CGRectMake(15, contentLab.maxY+10, WIDTH-30, 15);
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            CGFloat cellH = 0.f;
            NSString *name = _detailModel.title;
            CGSize nameSize = [name boundingRectWithSize:CGSizeMake(WIDTH-70,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont16Size,NSFontAttributeName,nil] context:nil].size;
            CGFloat nameH = nameSize.height;
            if ([Utils isBlankString:_detailModel.title]) {
                cellH = 20+20+10+30+20+20+45;
            } else {
                cellH = 20+nameH+10+30+20+20+45;
            }
            
            if ([Utils isBlankString:_detailModel.brief]) {
                cellH -= 20;
            }
            
            return cellH;
        }
            break;
        case 1:
        {
            NSArray *goodsPro = _detailModel.promotion[@"goods"];
            if (goodsPro.count==0) {
                return 0.0f;
            } else {
                return 50.0f;
            }
        }
            break;
        case 2:
            return 50.0f;
            break;
        case 3:
            if ([_detailModel.favs_count intValue]==0) {
                return 0.0f;
            } else {
                return 95.0f;
            }
            break;
        case 4:
        {
            if ([_detailModel.comments_count intValue]==0) {
                return 0.0f;
            } else {
                if (indexPath.row==0) {
                    return 44;
                } else {
                    CGFloat cellH = 0.0f;
                    NSString *content = _commentModel.comment;
                    CGFloat contentH = [Utils getTextHeight:content font:kFont14Size forWidth:WIDTH-30];
                    CGFloat imgWidth = 0.0f;
                    if (_commentModel.images.count>0) {
                        imgWidth = (WIDTH-15*6)/5;
                    }
                    CGFloat specH = 0.0f;
                    if (![Utils isBlankString:_commentModel.spec_info]) {
                        specH = 25.0f;
                    }
                    cellH += 80+contentH+imgWidth+specH;
                    return cellH;
                }
            }
        }
            break;
        default:
            return 0.0f;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==1) { //促销
        //self.tableView.contentOffset = CGPointMake(0, 0);
        [self openProView];
    }
    
    if (indexPath.section==2) { //选择商品
        //self.tableView.contentOffset = CGPointMake(0, 0);
        [self open];
    }
}

#pragma mark - TapImageViewDelegate代理
- (void) tappedWithObject:(id)sender
{
    TapImageView *tmpView = sender;
    if ((int)tmpView.tag==100) { //规格图片
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:_goodsIcon];
        [[ImgLargeScrollView shareInstance] tapImg:arr andIndex:0];
        return;
    }
    int index = (int)tmpView.tag - 100000;
    
    //传递图片控件数组和点击的第几张图片标识
    [[ImgLargeScrollView shareInstance] tapImg:_ivArr andIndex:index];
    
//    ImageViewer *imageViewer = [[ImageViewer alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andUrlArr:_ivArr tag:index];
//    [self.view addSubview:imageViewer];
}

#pragma mark - UIWebViewDelegate代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView stringByEvaluatingJavaScriptFromString:injectionJSString];
}

#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //    ImageViewer *imageViewer = [[ImageViewer alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andUrlArr:_picArray tag:index];
    //    [self.view addSubview:imageViewer];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    _picIndex = (int)index+1;
    _pageLab.text = [NSString stringWithFormat:@"%d/%d",_picIndex,(int)self.detailModel.item_imgs.count>0?(int)self.detailModel.item_imgs.count:1];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    
    if (scrollView == self.tableView) {
//        if (self.tableView.contentOffset.y < 0) {
//            self.tableView.scrollEnabled = NO; //不允许滑动
//        } else {
//            self.tableView.scrollEnabled = YES; //允许滑动
//        }
//        if (self.tableView.contentOffset.y >= 0 &&  self.tableView.contentOffset.y <= HEADER_VIEW_HEIGHT/2) {
//            
//            self.navigationView.alpha = offset / (HEADER_VIEW_HEIGHT/2);
//            
//            if (isShowDetail==NO) {
//                
//                if (self.tableView.contentOffset.y <= HEADER_VIEW_HEIGHT/4) {
//                    [_backBtn setImage:[UIImage imageNamed:@"BackGray"] forState:UIControlStateNormal];
//                    [_shareBtn setImage:[UIImage imageNamed:@"ShareGray"] forState:UIControlStateNormal];
//                    _backBtn.alpha = 1-offset / (HEADER_VIEW_HEIGHT/4);
//                    _shareBtn.alpha = 1-offset / (HEADER_VIEW_HEIGHT/4);
//                } else {
//                    [_backBtn setImage:[UIImage imageNamed:@"BackAlpha"] forState:UIControlStateNormal];
//                    [_shareBtn setImage:[UIImage imageNamed:@"ShareAlpha"] forState:UIControlStateNormal];
//                    _backBtn.alpha = offset / (HEADER_VIEW_HEIGHT/4)-1;
//                    _shareBtn.alpha = offset / (HEADER_VIEW_HEIGHT/4)-1;
//                }
//            } else {
//                self.navigationView.alpha = 1;
//            }
//        }
    } else {
        //WebView中的ScrollView
        if (offset <= -END_DRAG_SHOW_HEIGHT) {
            _bottomMsgLabel.text = @"释放返回商品详情";
        } else {
            _bottomMsgLabel.text = @"下拉返回商品详情";
        }
    }
    
    if (isShowDetail==NO) { //tableView
        topImgView.image =[self snapshotSingleView:_cycleScrollView];
        topImgView.backgroundColor = [UIColor yellowColor];
        CGRect tempF = topImgView.frame;
        // 如果offset大于0，说明是向上滚动，缩小
        if (offset >=0) {
            tempF.origin.y = -offset;
            tempF.size.width = WIDTH;
            topImgView.frame = tempF;
            topImgView.hidden = YES;
            _pageLab.x = WIDTH-50;
            _pageLab.y = WIDTH-50;
            [headView addSubview:_pageLab];
            [self.view addSubview:_headerView];
        }else{
            topImgView.hidden = NO;
            // 如果offset小于0，让headImageView的Y值等于0，headImageView的高度要放大
            tempF.size.height = _bgImgHeight-offset;
            tempF.origin.y = 0;
            tempF.size.width = WIDTH*(_bgImgHeight-offset)/_bgImgHeight;
            tempF.origin.x = (WIDTH-(_bgImgWidth*(_bgImgHeight-offset)/_bgImgHeight))/2.0;
            topImgView.frame = tempF;
            _pageLab.x = WIDTH-50;
            _pageLab.y = topImgView.height-50;
            [self.view addSubview:_pageLab];
            [self.view addSubview:_headerView];
        }

        //设置最大拉伸程度
        if (offset<=-100) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -100);
        }
    } else {
        topImgView.hidden = YES;
    }
}

#pragma mark - 屏幕快照
- (UIImage *)snapshotSingleView:(UIView *)view
{
    CGRect rect =  view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  每次拖拽都会回调
 *  @param decelerate YES时，为滑动减速动画，NO时，没有滑动减速动画
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        CGFloat offset = scrollView.contentOffset.y;
        if (scrollView == self.tableView) {
            if (offset < 0) {
                minY = MIN(minY, offset);
            } else {
                maxY = MAX(maxY, offset);
            }
        } else {
            minY = MIN(minY, offset);
        }
        
        // 滚到图文详情
        if (maxY >= self.tableView.contentSize.height - SCREEN_HEIGHT + END_DRAG_SHOW_HEIGHT + BOTTOM_VIEW_HEIGHT) {
            
            if (![Utils isBlankString:htmlStr]) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.allContentView.transform = CGAffineTransformTranslate(self.allContentView.transform, 0, - (SCREEN_HEIGHT - BOTTOM_VIEW_HEIGHT));
                    _backBtn.alpha = 1;
                    _shareBtn.alpha = 1;
                    self.navigationView.alpha = 1;
                    _titleLab.alpha = 1;
                } completion:^(BOOL finished) {
                    maxY = 0.0f;
                    isShowDetail = YES;
                    [_backBtn setImage:[UIImage imageNamed:@"BackAlpha"] forState:UIControlStateNormal];
                    [_shareBtn setImage:[UIImage imageNamed:@"ShareAlpha"] forState:UIControlStateNormal];
                }];
            }
        }
        
        // 滚到商品详情
        if (minY <= -END_DRAG_SHOW_HEIGHT && isShowDetail) {
            [UIView animateWithDuration:0.4 animations:^{
                self.allContentView.transform = CGAffineTransformIdentity;
                [self.tableView setContentOffset:CGPointMake(0,0)];
                self.navigationView.alpha = 0;
                _titleLab.alpha = 0;
                _backBtn.alpha = 1;
                _shareBtn.alpha = 1;
            } completion:^(BOOL finished) {
                minY = 0.0f;
                isShowDetail = NO;
                _bottomMsgLabel.text = @"下拉返回商品详情";
                [_backBtn setImage:[UIImage imageNamed:@"BackAlpha"] forState:UIControlStateNormal];
                [_shareBtn setImage:[UIImage imageNamed:@"ShareAlpha"] forState:UIControlStateNormal];
            }];
        }
    }
}

/**
 *  带有滑动减速动画效果时，才会调用
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // NSLog(@"END Decelerating");
}

#pragma mark - 促销视图
- (void)openProView {
    [self.view addSubview:self.maskView2];
    [self.view addSubview:self.promotionView];
    
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.layer.transform = [self secondStepTransform];
        //_bgView.layer.transform = [self firstStepTransform];
        self.maskView2.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            //_bgView.layer.transform = [self secondStepTransform];
            self.promotionView.transform = CGAffineTransformTranslate(self.promotionView.transform, 0, -HEIGHT/2+50);
        }];
    }];
}

- (void)closeProView {
    // 关闭顶部视图动画
    [UIView animateWithDuration:0.3 animations:^{
        //_bgView.layer.transform = [self firstStepTransform];
        _bgView.layer.transform = [self secondStepTransform];
        self.promotionView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _bgView.layer.transform = CATransform3DIdentity;
            self.maskView2.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.maskView2 removeFromSuperview];
            [self.promotionView removeFromSuperview];
        }];
    }];
}

#pragma mark - 选择规格视图
- (void) open {
    isShowSkus = YES; //打开
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.popView];
    [self.view bringSubviewToFront:_footerView];
    
    [UIView animateWithDuration:0.2 animations:^{
        //_bgView.layer.transform = [self firstStepTransform];
        _bgView.layer.transform = [self secondStepTransform];
        self.maskView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            //_bgView.layer.transform = [self secondStepTransform];
            self.popView.transform = CGAffineTransformTranslate(self.popView.transform, 0, -_specHeight-BOTTOM_VIEW_HEIGHT);
        }];
    }];
}

- (void)close {
    isShowSkus = NO; //关闭
    // 关闭顶部视图动画
    [UIView animateWithDuration:0.3 animations:^{
        //_bgView.layer.transform = [self firstStepTransform];
        _bgView.layer.transform = [self secondStepTransform];
        self.popView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _bgView.layer.transform = CATransform3DIdentity;
            self.maskView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self.popView removeFromSuperview];
            
            NSArray *skus = self.detailModel.skus;
            GoodsSkusModel *skusModel = skus[self.detailModel.select_skusIndex];
            if ([Utils isBlankString:skusModel.properties]) {
                self.detailModel.select_skus = [NSString stringWithFormat:@"%@件",self.detailModel.select_count];
            } else {
                NSArray *proArr = [skusModel.properties componentsSeparatedByString:@";"];
                NSString *proStr = @"";
                for (int i=0; i<proArr.count; i++) {
                    NSArray *arr = [proArr[i] componentsSeparatedByString:@"_"];
                    if (arr.count>1) {
                        proStr = [NSString stringWithFormat:@"%@%@，",proStr,arr[1]];
                    } else {
                        proStr = [NSString stringWithFormat:@"%@%@，",proStr,arr[0]];
                    }
                }
                self.detailModel.select_skus = [NSString stringWithFormat:@"%@%@件",proStr,self.detailModel.select_count];
            }
            [self.tableView reloadData];
        }];
    }];
}

// 动画1
- (CATransform3D)firstStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500.0;
    transform = CATransform3DScale(transform, 0.98, 0.98, 1.0);
    transform = CATransform3DRotate(transform, 5.0 * M_PI / 180.0, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 0, -30.0);
    return transform;
}

// 动画2
- (CATransform3D)secondStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = [self firstStepTransform].m34;
    transform = CATransform3DTranslate(transform, 0, 0, 0);
    transform = CATransform3DScale(transform, 0.92, 0.92, 1.0);
    return transform;
}

#pragma mark - 监听系统侧滑返回

- (void)willMoveToParentViewController:(UIViewController*)parent{
    [super willMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ImageJumpAnimation"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
