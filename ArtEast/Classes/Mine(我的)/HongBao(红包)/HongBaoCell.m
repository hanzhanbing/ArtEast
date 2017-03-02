//
//  HongBaoCell.m
//  ArtEast
//
//  Created by yibao on 2017/1/9.
//  Copyright © 2017年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "HongBaoCell.h"

@implementation HongBaoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addContentView];
    }
    return self;
}

- (void)addContentView {
    //日期
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 50, 20)];
    _dateLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    _dateLab.font = kFont14Size;
    [self.contentView addSubview:_dateLab];
    
    //时间
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, _dateLab.maxY+5, 50, 20)];
    _timeLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    _timeLab.font = kFont14Size;
    [self.contentView addSubview:_timeLab];
    
    //图片
    _statusImg = [[UIImageView alloc] initWithFrame:CGRectMake(_dateLab.maxX, 15, 45, 45)];
    [self.contentView addSubview:_statusImg];
    
    //金额
    _moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(_statusImg.maxX+15, 15, 100, 20)];
    _moneyLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    _moneyLab.font = kFont14Size;
    [self.contentView addSubview:_moneyLab];
    
    //内容
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(_statusImg.maxX+15, _moneyLab.maxY+5, 100, 20)];
    _contentLab.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    _contentLab.font = kFont14Size;
    [self.contentView addSubview:_contentLab];
}

- (void)setHongBaoModel:(HongBaoModel *)hongBaoModel {
    
    //时间戳转换成日期
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[hongBaoModel.alttime intValue]];
    NSDate *nowDate = [NSDate date];
    //系统自带计算时间，返回的是秒
    NSTimeInterval time = [nowDate timeIntervalSinceDate:date];
    double valiableTime = time;
    //计算天数
    NSInteger val_days = valiableTime/60/60/24;
    
    NSLog(@"rthtjykjuyk%ld",(long)val_days);
    
    if (val_days==0) {
        _dateLab.text = @"今天";
        _timeLab.text = [Utils getDateAccordingTime:hongBaoModel.alttime formatStyle:@"HH:mm"];
    } else if (val_days==1) {
        _dateLab.text = @"昨天";
        _timeLab.text = [Utils getDateAccordingTime:hongBaoModel.alttime formatStyle:@"HH:mm"];
    } else {
        _dateLab.text = [Utils getWeekDayFordate:[hongBaoModel.alttime intValue]];
        _timeLab.text = [Utils getDateAccordingTime:hongBaoModel.alttime formatStyle:@"MM-dd"];
    }
    
    NSString *moneyStr = hongBaoModel.red_packets_amount;
    if ([moneyStr floatValue]>0) {
        _statusImg.image = [UIImage imageNamed:@"CaiHongBao"];
    } else {
        _statusImg.image = [UIImage imageNamed:@"CaiHongBao"];
    }
    
    _moneyLab.text = hongBaoModel.red_packets_amount;
    _contentLab.text = hongBaoModel.operate_name;
}

+ (CGFloat)getHeight:(HongBaoModel *)hongBaoModel {
    return 75;
}

@end
