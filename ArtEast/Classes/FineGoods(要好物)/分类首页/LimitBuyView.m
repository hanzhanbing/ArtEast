//
//  LimitBuyView.m
//  ArtEast
//
//  Created by yibao on 2017/2/17.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "LimitBuyView.h"

@interface LimitBuyView ()
{
    UILabel *_titleLab;
    UILabel *_flagLab;
    UILabel *_hourLab;
    UILabel *_minuteLab;
    UILabel *_secondLab;
    UILabel *_priceLab;
    UILabel *_mktPriceLab;
    UIView  *_deleteView;
    UIImageView *_imageView;
}
@end

@implementation LimitBuyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, WIDTH/2-30, 15)];
        _titleLab.numberOfLines = 0;
        _titleLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLab];
        
        _flagLab = [[UILabel alloc] initWithFrame:CGRectMake(20, _titleLab.maxY+10, _titleLab.width, 15)];
        _flagLab.textColor = [UIColor grayColor];
        _flagLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:_flagLab];
        
        //时
        _hourLab = [[UILabel alloc] initWithFrame:CGRectMake(_flagLab.x, _flagLab.maxY+10, 30, 25)];
        _hourLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _hourLab.layer.borderWidth = 0.5;
        _hourLab.text = @"06";
        _hourLab.textColor = LightBlackColor;
        _hourLab.textAlignment = NSTextAlignmentCenter;
        _hourLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_hourLab];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(_hourLab.maxX, _hourLab.y, 16, _hourLab.height)];
        lab1.text = @":";
        lab1.font = [UIFont systemFontOfSize:15];
        lab1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab1];
        
        //分
        _minuteLab = [[UILabel alloc] initWithFrame:CGRectMake(lab1.maxX, _hourLab.y, 30, 25)];
        _minuteLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _minuteLab.layer.borderWidth = 0.5;
        _minuteLab.text = @"23";
        _minuteLab.textColor = LightBlackColor;
        _minuteLab.textAlignment = NSTextAlignmentCenter;
        _minuteLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_minuteLab];
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(_minuteLab.maxX, _hourLab.y, 16, _hourLab.height)];
        lab2.text = @":";
        lab2.font = [UIFont systemFontOfSize:15];
        lab2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab2];
        
        //秒
        _secondLab = [[UILabel alloc] initWithFrame:CGRectMake(lab2.maxX, _hourLab.y, 30, 25)];
        _secondLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _secondLab.layer.borderWidth = 0.5;
        _secondLab.text = @"02";
        _secondLab.textColor = LightBlackColor;
        _secondLab.textAlignment = NSTextAlignmentCenter;
        _secondLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_secondLab];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(15, _flagLab.maxY+10, 100, 15)];
        _priceLab.textColor = PriceRedColor;
        _priceLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_priceLab];
        
        _mktPriceLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _mktPriceLab.textColor = [UIColor grayColor];
        _mktPriceLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:_mktPriceLab];
        
        //删除线
        _deleteView = [[UIView alloc] initWithFrame:CGRectZero];
        _deleteView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        [self addSubview:_deleteView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2+20, 15, self.height-30, self.height-30)];
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpBuy)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setLimitDic:(NSMutableDictionary *)limitDic {
 
    _limitDic = limitDic;
    
    _titleLab.text = @"限时购";
    _flagLab.text = @"距结束还有";
    
    int seconds = [_limitDic[@"daojishi"] intValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",seconds%60];
    
    _hourLab.text = str_hour;
    _minuteLab.text = str_minute;
    _secondLab.text = str_second;
    
    NSString *price = @"￥0";
    NSString *mktprice = @"￥0";
    NSString *picture = @"";
    if ([_limitDic[@"goods"] isKindOfClass:[NSDictionary class]]) {
        price = [NSString stringWithFormat:@"￥%@",_limitDic[@"goods"][@"price"]];
        mktprice = [NSString stringWithFormat:@"￥%@",_limitDic[@"goods"][@"mktprice"]];
        picture = _limitDic[@"goods"][@"picture"];
    }
    _priceLab.text = price;
    _mktPriceLab.text = mktprice;
    
    _priceLab.frame = CGRectMake(17, self.height-32, [Utils getTextWidth:_priceLab.text fontSize:14 forHeight:15], 15);
    _mktPriceLab.frame = CGRectMake(_priceLab.maxX+8, self.height-32, 100, 15);
    _deleteView.frame = CGRectMake(_priceLab.maxX+6, 0, [Utils getTextWidth:_mktPriceLab.text fontSize:12 forHeight:15]+5, 0.5);
    _deleteView.centerY = _mktPriceLab.centerY;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureUrl,picture]] placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
}

//跳转到限时购
- (void)jumpBuy {
    if (self.buyBlock) {
        self.buyBlock(HTML_Seckill);
    }
}

@end
