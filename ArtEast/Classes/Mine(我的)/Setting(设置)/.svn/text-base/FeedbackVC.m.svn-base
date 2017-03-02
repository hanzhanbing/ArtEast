//
//  FeedbackVC.m
//  ArtEast
//
//  Created by yibao on 16/10/13.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "FeedbackVC.h"

#define kMaxTextCount  500

@interface FeedbackVC ()

@property (nonatomic,retain) UITextView *contentTV;
@property (nonatomic,retain) UILabel *tipLab;
@property (nonatomic,retain) UILabel *countLab;

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    [self initView];
}

- (void)initView {
    UIButton *navRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 80, 44)];
    [navRightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    navRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [navRightBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 80, WIDTH-20, 200)];
    bgView.layer.cornerRadius = 3;
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = [UIColor grayColor].CGColor;
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    _contentTV = [[UITextView alloc] initWithFrame:CGRectMake(15, 85, WIDTH-30, 165)];
    _contentTV.backgroundColor = [UIColor clearColor];
    _contentTV.delegate = self;
    _contentTV.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_contentTV];
    
    _tipLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, WIDTH-60, 20)];
    _tipLab.text = @"佑生活期待您的意见";
    _tipLab.font = [UIFont systemFontOfSize:14];
    _tipLab.textColor = [UIColor grayColor];
    [self.view addSubview:_tipLab];
    
    _countLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-50, 255, 30, 20)];
    _countLab.text = [NSString stringWithFormat:@"%d",kMaxTextCount];
    _countLab.textAlignment = NSTextAlignmentRight;
    _countLab.font = [UIFont systemFontOfSize:14];
    _countLab.textColor = [UIColor grayColor];
    [self.view addSubview:_countLab];
}

#pragma mark - methods

- (void)submit {
    DLog(@"提交");
    
    [self.view endEditing:YES];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"iOS端意见反馈", @"subject",
                         _contentTV.text, @"comment",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_Feedback parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        [JHHJView hideLoading]; //结束加载
        
        if (status == Request_Success) {
            [Utils showToast:@"谢谢您的反馈"];
            [self.navigationController popViewControllerAnimated:YES]; //关闭页面
        }
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length>kMaxTextCount) {
        textView.text = [textView.text substringToIndex:kMaxTextCount];
        [_contentTV resignFirstResponder];
        
        [Utils showToast:@"您已经超过了最大字数限制"];
    }
    
    if (textView.text.length>0) {
        _tipLab.hidden = YES;
    } else {
        _tipLab.hidden = NO;
    }
    
    _countLab.text = [NSString stringWithFormat:@"%lu",kMaxTextCount - textView.text.length];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
