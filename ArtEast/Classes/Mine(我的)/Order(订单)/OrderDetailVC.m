//
//  OrderDetailVC.m
//  ArtEast
//
//  Created by yibao on 16/11/7.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "OrderDetailVC.h"
#import <UIImageView+AFNetworking.h>
#import "BaseWebVC.h"
#import "OrderProgressVC.h"
#import "ContactUsVC.h"
#import "ChatViewController.h"
#import "ReturnApplyVC.h"
#import "CancelOrderVC.h"
#import "ChoosePayVC.h"
#import "GoodsDetailVC.h"
#import "BaseNC.h"

#define BtnWidth 70
#define BtnHeight 30
#define TabCellHeight 100

@interface OrderDetailCell : UITableViewCell
{
    UILabel *_goodsNameLabel; //名称
    UILabel *_goodsPropertyLabel; //规格
    UILabel *_goodsPriceLabel; //价格
    UILabel *_goodsNumLabel; //数量
}

@property (nonatomic,retain) UIImageView *imageV;
@property (nonatomic,retain) UIButton *applyServiceBtn;
@property (nonatomic,retain) NSDictionary *goodsDic;
@property (nonatomic,retain) OrderModel *order;

@end

@implementation OrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithCellViews];
    }
    return self;
}

- (void)initWithCellViews {
    
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, (TabCellHeight-80)/2.0, 80, 80)];
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    [self.contentView addSubview:_imageV];
    
    CGFloat labelWidth = (WIDTH-(_imageV.maxX+10)-55);
    
    _goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.maxX+10, 12, labelWidth, 20)];
    _goodsNameLabel.text = @"";
    _goodsNameLabel.font = [UIFont systemFontOfSize:13];
    _goodsNameLabel.textColor = LightBlackColor;
    [self.contentView addSubview:_goodsNameLabel];
    
    _goodsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-55, 12, 40, 20)];
    _goodsNumLabel.font = [UIFont systemFontOfSize:14];
    _goodsNumLabel.textColor = PriceColor;
    _goodsNumLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_goodsNumLabel];
    
    _goodsPropertyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.maxX+10, 40, WIDTH-(_imageV.maxX+10)-20, 20)];
    _goodsPropertyLabel.text = @"";
    _goodsPropertyLabel.textColor = PlaceHolderColor;
    _goodsPropertyLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_goodsPropertyLabel];
    
    _goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.maxX+10, 68, WIDTH-(_imageV.maxX+10)-75, 20)];
    _goodsPriceLabel.textColor = [UIColor colorWithRed:0.1255 green:0.1255 blue:0.1255 alpha:1.0];
    _goodsPriceLabel.textColor = PriceRedColor;
    _goodsPriceLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_goodsPriceLabel];
    
    _applyServiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(_goodsPriceLabel.maxX, TabCellHeight-42, 70, 30)];
    [_applyServiceBtn setTitle:@"申请退货" forState:UIControlStateNormal];
    _applyServiceBtn.cornerRadius = 3;
    _applyServiceBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [_applyServiceBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    _applyServiceBtn.layer.borderColor = LineColor.CGColor;
    _applyServiceBtn.layer.borderWidth = 0.5;
    [self.contentView addSubview:_applyServiceBtn];
}

- (void)setGoodsDic:(NSDictionary *)goodsDic {
    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureUrl,goodsDic[@"thumbnail_pic_src"]]] placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
    _goodsNameLabel.text = [goodsDic[@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _goodsNumLabel.text = [NSString stringWithFormat:@"x%@",goodsDic[@"quantity"]];
    _goodsPropertyLabel.text = [NSString stringWithFormat:@"%@",[Utils isBlankString:goodsDic[@"addon"]]?@"":goodsDic[@"addon"]];
    _goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",goodsDic[@"price"]];
}

- (void)setOrder:(OrderModel *)order {
    switch (order.type) {
        case UnPayOrderType:
            _applyServiceBtn.hidden = YES;
            break;
        case UntreatedOrderType:
            _applyServiceBtn.hidden = YES;
            break;
        case DestroyOrderType:
            _applyServiceBtn.hidden = YES;
            break;
        case RefundOrderType:
            _applyServiceBtn.hidden = YES;
            break;
            
        default:
            break;
    }
}

@end


@interface OrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *_scrollView;
    UILabel *_addressNameLb; //姓名
    UILabel *_addressPhoneLb; //手机号
    UILabel *_addressDetailLb; //收货地址
    UILabel *_orderNumLb;//订单号
    UILabel *_orderStatusLb;//订单状态
    UILabel *_orderPriceLb;//订单总价
    UILabel *_totalGoodsLb;//商品合计
    UILabel *_couponLb;//优惠券金额
    UILabel *_orderYouhuiLb; //订单优惠金额
    UILabel *_carriageLb;//运费金额
    UILabel *_redPaperLb;//红包金额
    UILabel *_totalMoneyLb;//合计总价钱
    UILabel *_payWayLb;//付款方式
    UILabel *_billInfoLb;//发票信息
    UILabel *_timeLb; //下单时间
    
    UIButton *contactPersonBtn; //联系客服按钮
    UIButton *lookLogisticsBtn;//查看物流按钮
    UIButton *confirmReceiptBtn;//确认收货按钮
    
    UIView *otherView; //支付价格所在视图
    UIView *payView;//支付方式所在视图
    UIView *invoiceView; //发票所在视图
    UIView *timeView; //时间所在视图
    UIView *bottomView;//底部视图
    
    NSMutableArray *goodsList; //商品列表
    
    NSString *_totalMoney; //商品合计
}
@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    goodsList = [NSMutableArray array];
    
    [self initView];
    [self getData];
    [self.view addSubview:self.navBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCancelSucc) name:kOrderCancelSuccNotification object:nil]; //订单取消成功
}

- (void)initView {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 3)];
    topImageView.image = [UIImage imageNamed:@"AddressIcon"];
    [_scrollView addSubview:topImageView];
    
    //收货地址视图 （收货人信息 收货地址信息）
    UIButton *topView = [[UIButton alloc]initWithFrame:CGRectMake(0, topImageView.maxY, WIDTH, 90)];
    topView.backgroundColor = [UIColor whiteColor];
    [topView addTarget:self action:@selector(AddressManager) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:topView];
    
    UIImageView *dingweiImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 30, topView.height-5)];
    dingweiImg.image = [UIImage imageNamed:@"AddressFlag"];
    dingweiImg.contentMode = UIViewContentModeCenter;
    dingweiImg.clipsToBounds = YES;
    [topView addSubview:dingweiImg];
    
    _addressNameLb = [[UILabel alloc]initWithFrame:CGRectMake(dingweiImg.maxX+15, 15, 200, 30)];
    _addressNameLb.font = [UIFont systemFontOfSize:14];
    _addressNameLb.textColor = LightBlackColor;
    [topView addSubview:_addressNameLb];
    
//    _addressPhoneLb = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-110, 15, 100, 30)];
//    _addressPhoneLb.font = [UIFont systemFontOfSize:14];
//    _addressPhoneLb.textColor = LightBlackColor;
//    [topView addSubview:_addressPhoneLb];
    
    _addressDetailLb = [[UILabel alloc]initWithFrame:CGRectMake(dingweiImg.maxX+15, _addressNameLb.maxY, WIDTH-(dingweiImg.maxX+5)-30-10, topView.height-10-_addressNameLb.maxY)];
    _addressDetailLb.minimumScaleFactor = 0.8;
    _addressDetailLb.numberOfLines = 0;
    _addressDetailLb.font = [UIFont systemFontOfSize:13];
    _addressDetailLb.textColor = PlaceHolderColor;
    [topView addSubview:_addressDetailLb];
    
//    UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(_addressNameLb.maxX, 0, 30, topView.height)];
//    arrowImg.image = [UIImage imageNamed:@"Back"];
//    arrowImg.contentMode = UIViewContentModeCenter;
//    arrowImg.transform = CGAffineTransformMakeRotation( M_PI);
//    [topView addSubview:arrowImg];
    
    //订单信息 视图 （订单编号、商品图片、订单总价）
    UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.maxY+10, WIDTH, 140)];
    orderView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:orderView];
    
    _orderNumLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, WIDTH-30-70, 40)];
    _orderNumLb.minimumScaleFactor = 0.8;
    _orderNumLb.numberOfLines = 0;
    _orderNumLb.font = [UIFont systemFontOfSize:14];
    _orderNumLb.textColor = LightBlackColor;
    [orderView addSubview:_orderNumLb];
    
    _orderStatusLb = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-136, 0, 120, _orderNumLb.height)];
    _orderStatusLb.textAlignment = NSTextAlignmentRight;
    _orderStatusLb.minimumScaleFactor = 0.8;
    _orderStatusLb.font = [UIFont systemFontOfSize:13];
    _orderStatusLb.textColor = AppThemeColor;;
    [orderView addSubview:_orderStatusLb];
    
    UIView *lin1View = [[UIView alloc]initWithFrame:CGRectMake(0, _orderNumLb.maxY, WIDTH, 0.5)];
    lin1View.backgroundColor = LineColor;
    [orderView addSubview:lin1View];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _orderNumLb.maxY, WIDTH, 100) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor]; //kColorFromRGBHex(0xf8f8f8)
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [orderView addSubview:self.tableView];
    //self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //商品合计 所在视图（商品合计、优惠券、运费、合计）
    otherView = [[UIView alloc]initWithFrame:CGRectMake(0, orderView.maxY+10, WIDTH, 44*5)];
    otherView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:otherView];
    
    UILabel *goodsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, 44)];
    goodsLabel.text = @"商品合计";
    goodsLabel.font = [UIFont systemFontOfSize:14];
    goodsLabel.textColor = LightBlackColor;
    [otherView addSubview:goodsLabel];
    
    _totalGoodsLb = [[UILabel alloc]initWithFrame:CGRectMake(goodsLabel.maxX+5, goodsLabel.y, WIDTH-(goodsLabel.maxX+5)-15, goodsLabel.height)];
    _totalGoodsLb.textAlignment = NSTextAlignmentRight;
    _totalGoodsLb.textColor  = LightBlackColor;
    _totalGoodsLb.font = [UIFont systemFontOfSize:14];
    [otherView addSubview:_totalGoodsLb];
    
//    UILabel *youhuiqLb = [[UILabel alloc]initWithFrame:CGRectMake(15, goodsLabel.maxY, 70, 50)];
//    youhuiqLb.text = @"优惠券";
//    youhuiqLb.font = [UIFont systemFontOfSize:14];
//    youhuiqLb.textColor = LightBlackColor;;
//    [otherView addSubview:youhuiqLb];
//    
//    _couponLb =  [[UILabel alloc]initWithFrame:CGRectMake(goodsLabel.maxX+5, youhuiqLb.y, WIDTH-(goodsLabel.maxX+5)-15, goodsLabel.height)];
//    _couponLb.textAlignment = NSTextAlignmentRight;
//    _couponLb.textColor  = AppThemeColor;
//    _couponLb.font = [UIFont systemFontOfSize:14];
//    [otherView addSubview:_couponLb];
    
    UILabel *youhuiLb = [[UILabel alloc]initWithFrame:CGRectMake(15, goodsLabel.maxY, 70, 44)];
    youhuiLb.text = @"订单优惠";
    youhuiLb.font = [UIFont systemFontOfSize:14];
    youhuiLb.textColor = LightBlackColor;;
    [otherView addSubview:youhuiLb];
    
    _orderYouhuiLb =  [[UILabel alloc]initWithFrame:CGRectMake(goodsLabel.maxX+5, youhuiLb.y, WIDTH-(goodsLabel.maxX+5)-15, goodsLabel.height)];
    _orderYouhuiLb.textAlignment = NSTextAlignmentRight;
    _orderYouhuiLb.textColor  = LightBlackColor;
    _orderYouhuiLb.font = [UIFont systemFontOfSize:14];
    [otherView addSubview:_orderYouhuiLb];
    
    UILabel *yunfeiLb = [[UILabel alloc]initWithFrame:CGRectMake(15, youhuiLb.maxY, 70, 44)];
    yunfeiLb.text = @"运费";
    yunfeiLb.font = [UIFont systemFontOfSize:14];
    yunfeiLb.textColor = LightBlackColor;
    [otherView addSubview:yunfeiLb];
    
    _carriageLb =  [[UILabel alloc]initWithFrame:CGRectMake(goodsLabel.maxX+5, yunfeiLb.y, WIDTH-(goodsLabel.maxX+5)-15, goodsLabel.height)];
    _carriageLb.textAlignment = NSTextAlignmentRight;
    _carriageLb.textColor  = LightBlackColor;
    _carriageLb.font = [UIFont systemFontOfSize:14];
    [otherView addSubview:_carriageLb];
    
    UILabel *hongBaoLb = [[UILabel alloc]initWithFrame:CGRectMake(15, yunfeiLb.maxY, 70, 44)];
    hongBaoLb.text = @"红包";
    hongBaoLb.font = [UIFont systemFontOfSize:14];
    hongBaoLb.textColor = LightBlackColor;;
    [otherView addSubview:hongBaoLb];
    
    _redPaperLb =  [[UILabel alloc]initWithFrame:CGRectMake(goodsLabel.maxX+5, hongBaoLb.y, WIDTH-(goodsLabel.maxX+5)-15, goodsLabel.height)];
    _redPaperLb.textAlignment = NSTextAlignmentRight;
    _redPaperLb.textColor  = LightBlackColor;
    _redPaperLb.font = [UIFont systemFontOfSize:14];
    [otherView addSubview:_redPaperLb];
    
    UILabel *hejiLb = [[UILabel alloc]initWithFrame:CGRectMake(15, hongBaoLb.maxY, 70, 44)];
    hejiLb.text = @"合计";
    hejiLb.font = [UIFont systemFontOfSize:14];
    hejiLb.textColor = LightBlackColor;
    [otherView addSubview:hejiLb];
    
    _totalMoneyLb =  [[UILabel alloc]initWithFrame:CGRectMake(goodsLabel.maxX+5, hejiLb.y, WIDTH-(goodsLabel.maxX+5)-15, goodsLabel.height)];
    _totalMoneyLb.textAlignment = NSTextAlignmentRight;
    _totalMoneyLb.textColor  = PriceRedColor;
    _totalMoneyLb.font = [UIFont systemFontOfSize:14];
    [otherView addSubview:_totalMoneyLb];
    
    //支付方式  所在视图
    payView = [[UIView alloc]initWithFrame:CGRectMake(0, otherView.maxY+10, WIDTH, 50)];
    payView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:payView];
    
    UILabel *payLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, payView.height)];
    payLb.text = @"支付方式";
    payLb.font = [UIFont systemFontOfSize:14];
    payLb.textColor = LightBlackColor;;
    [payView addSubview:payLb];
    
    _payWayLb =  [[UILabel alloc]initWithFrame:CGRectMake(payLb.maxX+5, payLb.y, WIDTH-(payLb.maxX+5)-15, payLb.height)];
    _payWayLb.textAlignment = NSTextAlignmentRight;
    _payWayLb.textColor  = LightBlackColor;
    _payWayLb.font = [UIFont systemFontOfSize:14];
    [payView addSubview:_payWayLb];
    
    //发票信息  所在视图
    invoiceView= [[UIView alloc]initWithFrame:CGRectMake(0, payView.maxY+10, WIDTH, 50)];
    invoiceView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:invoiceView];
    
    UILabel *fapiaoLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, invoiceView.height)];
    fapiaoLb.text = @"发票";
    fapiaoLb.font = [UIFont systemFontOfSize:14];
    fapiaoLb.textColor = LightBlackColor;
    [invoiceView addSubview:fapiaoLb];
    
    _billInfoLb =  [[UILabel alloc]initWithFrame:CGRectMake(fapiaoLb.maxX+5, fapiaoLb.y, WIDTH-(payLb.maxX+5)-15, fapiaoLb.height)];
    _billInfoLb.textAlignment = NSTextAlignmentRight;
    _billInfoLb.textColor  = LightBlackColor;
    _billInfoLb.font = [UIFont systemFontOfSize:14];
    [invoiceView addSubview:_billInfoLb];
    
    //下单时间  所在视图
    timeView= [[UIView alloc]initWithFrame:CGRectMake(0, invoiceView.maxY+10, WIDTH, 50)];
    timeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:timeView];
    
    UILabel *timeLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, invoiceView.height)];
    timeLb.text = @"下单时间";
    timeLb.font = [UIFont systemFontOfSize:14];
    timeLb.textColor = LightBlackColor;;
    [timeView addSubview:timeLb];
    
    _timeLb =  [[UILabel alloc]initWithFrame:CGRectMake(timeLb.maxX+5, timeLb.y, WIDTH-(fapiaoLb.maxX+5)-15, timeLb.height)];
    _timeLb.textAlignment = NSTextAlignmentRight;
    _timeLb.textColor  = LightBlackColor;
    _timeLb.font = [UIFont systemFontOfSize:14];
    [timeView addSubview:_timeLb];
    
    //底部视图 （联系客服、查看物流，确认收货）
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    lineView.backgroundColor = LineColor;
    [bottomView addSubview:lineView];
    
    contactPersonBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-BtnWidth*3-10*2-15, (bottomView.height-BtnHeight)/2.0, BtnWidth, BtnHeight)];
    [contactPersonBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [contactPersonBtn setTitleColor:PlaceHolderColor forState:UIControlStateNormal];
    contactPersonBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    contactPersonBtn.layer.borderColor = PlaceHolderColor.CGColor;
    contactPersonBtn.layer.borderWidth = 1;
    contactPersonBtn.cornerRadius = 5;
    [contactPersonBtn addTarget:self action:@selector(contactKefu) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:contactPersonBtn];
    
    lookLogisticsBtn = [[UIButton alloc]initWithFrame:CGRectMake(contactPersonBtn.maxX+10, (bottomView.height-BtnHeight)/2.0, BtnWidth, BtnHeight)];
    [lookLogisticsBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    [lookLogisticsBtn setTitleColor:PlaceHolderColor forState:UIControlStateNormal];
    lookLogisticsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    lookLogisticsBtn.layer.borderColor = PlaceHolderColor.CGColor;
    lookLogisticsBtn.layer.borderWidth = 1;
    lookLogisticsBtn.cornerRadius = 5;
    [lookLogisticsBtn addTarget:self action:@selector(lookWuliu:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:lookLogisticsBtn];
    
    confirmReceiptBtn = [[UIButton alloc]initWithFrame:CGRectMake(lookLogisticsBtn.maxX+10, (bottomView.height-BtnHeight)/2.0, BtnWidth, BtnHeight)];
    [confirmReceiptBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    confirmReceiptBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [confirmReceiptBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    confirmReceiptBtn.layer.borderColor = AppThemeColor.CGColor;
    confirmReceiptBtn.layer.borderWidth = 1;
    confirmReceiptBtn.cornerRadius = 5;
    [confirmReceiptBtn addTarget:self action:@selector(confirmGetGoods:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:confirmReceiptBtn];
    
    if (self.order.type==UnPayOrderType) {
        invoiceView.y = otherView.maxY+10;
    } else {
        invoiceView.y = payView.maxY+10;
    }
    timeView.y = invoiceView.maxY+10;
    
    _scrollView.contentSize = CGSizeMake(WIDTH, MAX(_scrollView.height+1, timeView.maxY+10+bottomView.height));
    
    _orderNumLb.text = [NSString stringWithFormat:@"订单编号：%@",self.order.ID];
    switch (self.order.type) {
        case UnPayOrderType:
            _orderStatusLb.text = @"待付款";
            payView.hidden = YES;
            [lookLogisticsBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [confirmReceiptBtn setTitle:@"去支付" forState:UIControlStateNormal];
            break;
        case UntreatedOrderType:
            _orderStatusLb.text = @"待发货";
            contactPersonBtn.frame = CGRectMake(WIDTH-BtnWidth-15, (bottomView.height-BtnHeight)/2.0, BtnWidth, BtnHeight);
            lookLogisticsBtn.hidden = YES;
            confirmReceiptBtn.hidden = YES;
            break;
        case TreatedOrderType:
            _orderStatusLb.text = @"已发货";
            break;
        case DestroyOrderType:
            _orderStatusLb.text = @"已作废";
            bottomView.hidden = YES;
            break;
        case CompletedOrderType:
            _orderStatusLb.text = @"已完成";
            contactPersonBtn.frame = CGRectMake(WIDTH-BtnWidth-15, (bottomView.height-BtnHeight)/2.0, BtnWidth, BtnHeight);
            lookLogisticsBtn.hidden = YES;
            confirmReceiptBtn.hidden = YES;
            break;
        case RefundOrderType:
            _orderStatusLb.text = self.order.order_status;
            contactPersonBtn.frame = CGRectMake(WIDTH-BtnWidth-15, (bottomView.height-BtnHeight)/2.0, BtnWidth, BtnHeight);
            lookLogisticsBtn.hidden = YES;
            confirmReceiptBtn.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)getData{
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UserInfo share].userID, @"member_id",
                         self.order.ID, @"order_id",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_OrderDetail parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            //[Utils showToast:@"订单详情获取成功"];
            
            if (![Utils isBlankString:responseData]) {
                NSDictionary *addressDic = responseData[@"order"][@"consignee"];
                NSDictionary *payDic = responseData[@"order"][@"payment"];
                goodsList = [responseData[@"order"][@"goods_items"] mutableCopy];

                _addressNameLb.text = [NSString stringWithFormat:@"%@     %@",addressDic[@"name"],addressDic[@"mobile"]];
//                _addressNameLb.text = addressDic[@"name"];
//                _addressPhoneLb.text = addressDic[@"mobile"];
                _addressDetailLb.text = addressDic[@"addr"];
                
                _totalGoodsLb.text = [NSString stringWithFormat:@"+%@",responseData[@"order"][@"cost_item"]]; //商品合计
                _totalMoney = [NSString stringWithFormat:@"%@",responseData[@"order"][@"cost_item"]];
                //_couponLb.text = @"-0.00"; //优惠券字段暂无
                _orderYouhuiLb.text = [NSString stringWithFormat:@"-%@",responseData[@"order"][@"pmt_order"]]; //订单优惠金额
                NSString *yfPrice = [NSString stringWithFormat:@"%@",responseData[@"order"][@"cost_freight"]];
                NSString *hbPrice = [NSString stringWithFormat:@"%@",responseData[@"order"][@"red_packets"]];
                _carriageLb.text = [NSString stringWithFormat:@"+%0.2f",[yfPrice floatValue]]; //运费金额
                _redPaperLb.text = [NSString stringWithFormat:@"-%0.2f",[hbPrice floatValue]]; //红包金额
                _totalMoneyLb.text = [NSString stringWithFormat:@"+%@",responseData[@"order"][@"total_amount"]]; //合计总价钱
                _payWayLb.text = payDic[@"app_name"]; //付款方式
                if ([responseData[@"order"][@"tax_type"] isEqualToString:@"personal"]) {
                    _billInfoLb.text = @"个人";
                } else if ([responseData[@"order"][@"tax_type"] isEqualToString:@"company"]) {
                    _billInfoLb.text = responseData[@"order"][@"tax_title"];
                } else {
                    _billInfoLb.text = @"无";//无发票信息
                }
            
                _timeLb.text = [Utils getDateAccordingTime:[NSString stringWithFormat:@"%@",responseData[@"order"][@"createtime"]] formatStyle:@"YYYY-MM-dd HH-mm"];
                
                //获取数据源的个数  来改变所在的视图
                self.tableView.height = goodsList.count*TabCellHeight;
                UIView *superView = self.tableView.superview;
                superView.height = 30+10+self.tableView.height;
                otherView.y = superView.maxY+10;
                payView.y = otherView.maxY+10;
                if (self.order.type==UnPayOrderType) {
                    invoiceView.y = otherView.maxY+10;
                } else {
                    invoiceView.y = payView.maxY+10;
                }
                timeView.y = invoiceView.maxY+10;
                
                _scrollView.contentSize = CGSizeMake(WIDTH, MAX(_scrollView.height+1, timeView.maxY+10+bottomView.height));
                [self.tableView reloadData];
            }
            
        }
    }];
}

#pragma mark - 点击地址信息
- (void)AddressManager{
    NSLog(@"地址信息点击");
}

#pragma mark - 联系客服
- (void)contactKefu{
    NSLog(@"联系客服");
//    ContactUsVC *contactUsVC = [[ContactUsVC alloc] init];
//    [self.navigationController pushViewController:contactUsVC animated:YES];
    
    if ([[EMClient sharedClient] isLoggedIn]) { //环信是否登录
        [self jumpChatVC];
    } else {
        [[EMClient sharedClient] loginWithUsername:[UserInfo share].userID password:[[Utils md5HexDigest:[NSString stringWithFormat:@"ysh%@cydf",[UserInfo share].userID]] lowercaseString] completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                [self jumpChatVC];
            }
        }];
    }
}

//跳转到聊天页面
- (void)jumpChatVC {
    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:HXChatter conversationType:EMConversationTypeChat];
    NSDictionary *goodsDic = goodsList[0];
    NSString *goodsDesc = goodsDic[@"name"];
    if (goodsList.count>1) {
        goodsDesc = [NSString stringWithFormat:@"%@等%d件商品",goodsDic[@"name"],(int)goodsList.count];
    }
    NSDictionary *dataDictionary= [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"我的订单",@"title", //消息标题
                                   [NSString stringWithFormat:@"订单号：%@",self.order.ID],@"order_title", //订单标题
                                   [NSString stringWithFormat:@"￥%@",_totalMoney],@"price", //商品价格
                                   goodsDesc,@"desc", //商品描述
                                   [NSString stringWithFormat:@"%@%@",PictureUrl,goodsDic[@"thumbnail_pic_src"]],@"img_url", //商品图片链接
                                   [NSString stringWithFormat:@"%@web/Share/goodsDetails.html?iid=%@",WebUrl,goodsDic[@"goods_id"]],@"item_url", //商品页面链接
                                   [UserInfo share].userName,@"nick", //昵称
                                   [UserInfo share].avatar,@"avatar", //头像
                                   [Utils isBlankString:goodsDic[@"goods_id"]]?@"":goodsDic[@"goods_id"],@"id", //id
                                   nil];
    chatVC.info = @{@"msgtype":@{@"order":dataDictionary}};
    chatVC.infoType = @"订单";
    chatVC.height = 95;
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - 查看物流
- (void)lookWuliu:(UIButton *)btn {
    NSLog(@"查看物流");
    if ([btn.titleLabel.text isEqualToString:@"查看物流"]) {
        OrderProgressVC *orderProgressVC = [[OrderProgressVC alloc] init];
        orderProgressVC.order = self.order;
        [self.navigationController pushViewController:orderProgressVC animated:YES];
    }
    if ([btn.titleLabel.text isEqualToString:@"取消订单"]) {
        CancelOrderVC *cancelOrderVC = [[CancelOrderVC alloc] init];
        cancelOrderVC.orderID = self.order.ID;
        [self.navigationController pushViewController:cancelOrderVC animated:YES];
    }
}

#pragma mark - 确认收货
- (void)confirmGetGoods:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"确认收货"]) {
        //[Utils showToast:@"确认收货"];
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [UserInfo share].userID, @"member_id",
                             self.order.ID, @"order_id",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_ConfirmOrder parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                _orderStatusLb.text = @"已完成";
                contactPersonBtn.frame = CGRectMake(WIDTH-BtnWidth-15, (bottomView.height-BtnHeight)/2.0, BtnWidth, BtnHeight);
                lookLogisticsBtn.hidden = YES;
                confirmReceiptBtn.hidden = YES;
            }
        }];
    }
    if ([btn.titleLabel.text isEqualToString:@"去支付"]) {
        ChoosePayVC *choosePayVC = [[ChoosePayVC alloc] init];
        choosePayVC.order = self.order;
        [self.navigationController pushViewController:choosePayVC animated:YES];
    }
}

#pragma mark - 订单取消成功同步数据

- (void)orderCancelSucc {
    _orderStatusLb.text = @"已作废";
    contactPersonBtn.frame = CGRectMake(WIDTH-BtnWidth-15, (bottomView.height-BtnHeight)/2.0, BtnWidth, BtnHeight);
    lookLogisticsBtn.hidden = YES;
    confirmReceiptBtn.hidden = YES;
}

#pragma mark  UITableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell"];
    if (!cell) {
        cell = [[OrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderDetailCell"];
        cell.backgroundColor = [UIColor whiteColor]; //kColorFromRGBHex(0xf8f8f8)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *gDic = goodsList[indexPath.row];
    cell.goodsDic = gDic;
    cell.order = self.order;
    
    cell.applyServiceBtn.tag = 1000+indexPath.row;
    [cell.applyServiceBtn addTarget:self action:@selector(applyReturn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TabCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *gDic = goodsList[indexPath.row];
    //[BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",PictureUrl,gDic[@"url"]] withTitle:@"商品详情"];
    
    CGRect descRec = CGRectMake(0, 0, WIDTH, WIDTH); //目的位置
    
    CGRect originalRec;
    UIImageView *imageView = nil;
    OrderDetailCell *firstCell = (OrderDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    originalRec = [firstCell.imageV convertRect:firstCell.imageV.frame toView:self.view];
    originalRec = CGRectMake(originalRec.origin.x-15, originalRec.origin.y-10, originalRec.size.width, originalRec.size.height);
    imageView = firstCell.imageV;
    
    GoodsModel *goodsModel = [[GoodsModel alloc] init];
    goodsModel.ID = gDic[@"goods_id"];
    goodsModel.icon = [NSString stringWithFormat:@"%@%@",PictureUrl,gDic[@"thumbnail_pic_src"]];
    goodsModel.imageView = imageView;
    goodsModel.descRec = descRec;
    goodsModel.originalRec = originalRec;
    
    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
    goodsDetailVC.goodsModel = goodsModel;
    BaseNC *baseNC = (BaseNC *)self.navigationController;
    [baseNC pushViewController:goodsDetailVC imageView:goodsModel.imageView desRec:goodsModel.descRec original:goodsModel.originalRec deleagte:goodsDetailVC isAnimation:YES];
}

//申请退货
- (void)applyReturn:(UIButton *)btn {
    NSLog(@"申请退货");
    
    int index = (int)btn.tag-1000;
    NSDictionary *goodsDic = goodsList[index];
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UserInfo share].userID, @"memberID",
                         self.order.ID, @"order_id",
                         goodsDic[@"item_id"], @"item_id",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_ReturnApplyOne parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            
            ReturnApplyVC *returnApplyVC = [[ReturnApplyVC alloc] init];
            returnApplyVC.order = self.order;
            returnApplyVC.goodsDic = goodsDic;
            returnApplyVC.returnMoney = responseData[@"order_objects"][@"order_items"][@"all_payment"];
            [self.navigationController pushViewController:returnApplyVC animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
