//
//  ReturnApplyVC.m
//  ArtEast
//
//  Created by mac on 2016/11/3.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "ReturnApplyVC.h"

#import "StarRatingView.h"
#import "TZImagePickerController.h"
#import "ImageViewer.h"
#import "AEFilePath.h"

#define Count 5  //一行最多放几张图片
#define ImageWidth ([UIScreen mainScreen].bounds.size.width-80)/Count
#define MaxCount 5
#define BottomHeight 45

@interface CommentCell1 : UICollectionViewCell
@property (nonatomic , retain)UIImageView *imageView;
@property (nonatomic , retain) UIButton *cancelBtn;
@property (nonatomic , retain) UIButton *cancelTapBtn;
@end

@implementation CommentCell1


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageWidth)];
        [self addSubview:_imageView];
        
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ImageWidth-15, -10, 30, 30)];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"DeletePic"] forState:UIControlStateNormal];
        [self addSubview:_cancelBtn];
        
        _cancelTapBtn = [[UIButton alloc] initWithFrame:CGRectMake(ImageWidth-30, 0, 30, 30)];
        _cancelTapBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_cancelTapBtn];
    }

    return self;
}

@end

@interface ReturnApplyVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate,
UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate>

{
    UIScrollView *_scrollView;

    UITextField *returnResonTF;
    UITextField *returnMoneyTF;

    UITextView *contentTV;
    UILabel *tishiLabel;
    UIButton        *addImg; //中间添加图片按钮
    UICollectionView *collection; //存放图片的容器
    
    NSMutableArray  *imageArr; //存放图片数据源
    NSMutableArray  *imageStr; //存放图片数据源地址
    int photoCount; //上传照片数量

    //有关点击头像弹出照相机还是本地图库的菜单
    UIActionSheet   *myActionSheet;
}
@end

@implementation ReturnApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"退货申请";
    imageArr = [NSMutableArray array];
    imageStr = [NSMutableArray array];
    
    [self initViews];
}

- (void)initViews{

    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-BottomHeight-64)];
    _scrollView.backgroundColor = [UIColor redColor];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_scrollView];


    //商品质量星星 评价
    UIView *startView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 50)];
    startView1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:startView1];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, startView1.height)];
    label1.text = @"退货理由：";
    label1.textColor = LightBlackColor;
    label1.font = kFont14Size;
    [startView1 addSubview:label1];

    returnResonTF = [[UITextField alloc]initWithFrame:CGRectMake(label1.maxX, 0, WIDTH-label1.maxX-15, startView1.height)];
    returnResonTF.placeholder = @"输入您的退货理由";
    //[returnResonTF setValue:PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    returnResonTF.font = kFont14Size;
    returnResonTF.delegate = self;
    [startView1 addSubview:returnResonTF];


    //物流服务 星星评价
    UIView *startView2 = [[UIView alloc]initWithFrame:CGRectMake(0, startView1.maxY+10, WIDTH, startView1.height)];
    startView2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:startView2];

    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.x, 0, label1.width, startView1.height)];
    label2.text = @"退款金额：";
    label2.textColor = LightBlackColor;
    label2.textColor = kColorFromRGBHex(0x444444);
    label2.font = [UIFont systemFontOfSize:13];
    [startView2 addSubview:label2];

    returnMoneyTF = [[UITextField alloc]initWithFrame:CGRectMake(label1.maxX, 0, WIDTH-label1.maxX-15, startView1.height)];
    returnMoneyTF.textColor = LightBlackColor;
    returnMoneyTF.keyboardType = UIKeyboardTypeNumberPad;
    returnMoneyTF.font = [UIFont systemFontOfSize:14];
    returnMoneyTF.delegate = self;
    returnMoneyTF.placeholder = [NSString stringWithFormat:@"最大退款金额是%@元",self.returnMoney];
    [startView2 addSubview:returnMoneyTF];

    //评价内容展示
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, startView2.maxY+10, WIDTH, 100)];
    contentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:contentView];

    contentTV = [[UITextView alloc]initWithFrame:CGRectMake(15, 0, WIDTH-15*2, contentView.height)];
    contentTV.textColor = LightBlackColor;
    contentTV.font = [UIFont systemFontOfSize:14];
    contentTV.delegate = self;
    [contentView addSubview:contentTV];

    tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(contentTV.x+3, 5, contentTV.width, 20)];
    tishiLabel.text = @"输入您的详细描述。";
    tishiLabel.textColor = LightBlackColor;
    tishiLabel.textColor = kColorFromRGBHex(0x868686);
    tishiLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:tishiLabel];

    //评价图片展示
    UIView *pictureView = [[UIView alloc]initWithFrame:CGRectMake(0, contentView.maxY, WIDTH, ImageWidth+10*2)];
    pictureView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:pictureView];


    //添加图片的按钮
    addImg = [UIButton buttonWithType:UIButtonTypeCustom];
    addImg.frame = CGRectMake(15, 10, ImageWidth, ImageWidth);
    [addImg setBackgroundImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
    [addImg addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [pictureView addSubview:addImg];

    //存放图片的UICollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(addImg.maxX+10, 5, WIDTH-10-addImg.maxX-10, ImageWidth+10) collectionViewLayout:flowLayout];
    [collection registerClass:[CommentCell1 class] forCellWithReuseIdentifier:@"myCell"];
    [collection setAllowsMultipleSelection:YES];
    collection.showsHorizontalScrollIndicator = NO;
    collection.delegate = self;
    collection.dataSource = self;
    collection.alwaysBounceHorizontal = YES;
    collection.backgroundColor = [UIColor clearColor];
    [pictureView addSubview:collection];


    _scrollView.contentSize = CGSizeMake(WIDTH, MAX(_scrollView.height+1, pictureView.maxY+20));


    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, HEIGHT-BottomHeight, WIDTH, BottomHeight)];
    submitBtn.backgroundColor = ButtonBgColor;
    [submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitBtn setTitleColor:ButtonFontColor forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

-(void)addImage{
    if (imageArr.count>=MaxCount) {
        //[BHUD showErrorMessage:@"亲，最多只能上传9张图片哦~~"];
        NSLog(@"亲，最多只能上传9张图片哦~~");
    } else {
        [self.view endEditing:YES];

        myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从本地图库获取", nil];
        [myActionSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0://打开照相机拍照
            [self takePhoto];
            break;
        case 1://打开本地相册
            [self LocalPhoto];
            break;
    }
}

#pragma mark - 打开照相机
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //NSLog(@"模拟器中无法使用照相机，请在真机中使用");
    }
}

#pragma mark - 打开本地图库
-(void)LocalPhoto{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAX(0, MaxCount-imageArr.count) delegate:self];
    // 你可以通过block或者代理，来得到用户选择的照片
    imagePickerVc.allowPickingOriginalPhoto = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *iamges, NSArray *assets, BOOL bo) {
        for (NSInteger i = 0; i < iamges.count; i++) {
            NSData *data = UIImageJPEGRepresentation(iamges[i], 0.5);
            [imageArr addObject:data];
        }
        if (imageArr.count>=MaxCount) {
            addImg.hidden = YES;
            collection.x = 15;
            collection.width = WIDTH-15*2;
        }else{
            addImg.hidden = NO;
            collection.x = addImg.maxX+10;
            collection.width = WIDTH-(addImg.maxX+10)-10;

        }
        [collection reloadData];

    }];
    
    imagePickerVc.barItemTextColor = kColorFromRGBHex(0x2a2a2a);
    [imagePickerVc.navigationBar setTitleTextAttributes:@{
                                                          NSForegroundColorAttributeName :  kColorFromRGBHex(0x2a2a2a), NSFontAttributeName:[UIFont fontWithName:@"Heiti TC" size:18]
                                                          }];
    imagePickerVc.navigationBar.tintColor = [UIColor grayColor];
    imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - 照片选取取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //[picker dismissViewControllerAnimated:YES completion:nil];
    if ([picker isKindOfClass:[TZImagePickerController class]]) {
        TZImagePickerController *pc = (TZImagePickerController *)picker;
        [pc hideProgressHUD];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ImageWidth, ImageWidth);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"myCell";
    CommentCell1 *cell = (CommentCell1 *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.imageView.image = [UIImage imageWithData:imageArr[indexPath.row]];
    cell.cancelTapBtn.tag = indexPath.row;
    [cell.cancelTapBtn addTarget:self action:@selector(cancelImg:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    ImageViewer *vvv = [[ImageViewer alloc]initWithFrame1:CGRectMake(0, 0, WIDTH, HEIGHT) andData:imageArr tag:indexPath.row];
    [[UIApplication sharedApplication].keyWindow addSubview:vvv];

}

#pragma mark - 取消选择的图片
- (void)cancelImg:(UIButton *)btn {
    CommentCell1 *cell = (CommentCell1 *)btn.superview;
    NSIndexPath *indexPath = [collection indexPathForCell:cell];
    [imageArr removeObjectAtIndex:indexPath.row];
    if (imageArr.count<MaxCount) {
        addImg.hidden = NO;
        //添加图片的按钮在第一行
        collection.x = addImg.maxX+10;
        collection.width = WIDTH-(addImg.maxX+10)-10;
        [collection reloadData];
    } else {
        addImg.hidden = YES; //最多上传6张图片
        collection.x = 15;
        collection.width = WIDTH-15*2;

    }

}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;

}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        [UIView animateWithDuration:0.2 animations:^{
            tishiLabel.alpha = 0.0;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            tishiLabel.alpha = 1.0;
        }];
    }
}

- (void)submitData{
    NSLog(@"立即评价");
    
    CGFloat money = [returnMoneyTF.text floatValue];
    
    if ([Utils isBlankString:returnResonTF.text]) {
        [Utils showToast:@"请输入退货理由"];
    } else if ([Utils isBlankString:returnMoneyTF.text]) {
        [Utils showToast:@"请输入退款金额"];
    } else if ([Utils isBlankString:contentTV.text]) {
        [Utils showToast:@"请输入详细描述"];
    } else if (money>[self.returnMoney floatValue]) {
        [Utils showToast:@"退款金额过大，请重新填写"];
    } else {
        photoCount = 0;
        [imageStr removeAllObjects];
        [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
        [self photoUpload]; //单张循环上传
    }
}

#pragma mark - 图片资源上传

- (void)photoUpload {
    
    if (imageArr.count>0) {
        NSData *data = imageArr[photoCount];
        NSString *filePath = [AEFilePath filePathWithType:AEFilePathType_IconPath withFileName:nil];
        [data writeToFile:filePath atomically:YES];
        
        NSDictionary *dic = [NSDictionary dictionary];
        [[NetworkManager sharedManager] postJSON:URL_CommentPicUpload parameters:dic imagePath:filePath completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                [imageStr addObject:responseData];
            }
            
            photoCount++;
            
            if (photoCount<imageArr.count) {
                [self photoUpload];
            } else {
                NSString *picStr = @"";
                for (int i = 0; i<imageStr.count; i++) {
                    if (i == 0) {
                        picStr = imageStr[i];
                    } else {
                        picStr = [NSString stringWithFormat:@"%@,%@",picStr,imageStr[i]];
                    }
                }
                
                //申请退货
                photoCount = 0;
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     contentTV.text, @"content",
                                     [UserInfo share].userID, @"member_id",
                                     self.order.ID, @"order_id",
                                     picStr, @"images",
                                     _goodsDic[@"bn"], @"product_bn",
                                     returnMoneyTF.text, @"product_price",
                                     returnResonTF.text, @"title",
                                     nil];
                [[NetworkManager sharedManager] postJSON:URL_ReturnApplyTwo parameters:dic imagePath:filePath completion:^(id responseData, RequestState status, NSError *error) {
                    
                    [JHHJView hideLoading]; //结束加载
                    
                    if (status == Request_Success) {
                        [Utils showToast:@"申请退货成功，请您耐心等待"];
                        [self.navigationController popViewControllerAnimated:YES]; //关闭页面
                    }
                    
                }];
            }
        }];
    } else {
        //申请退货
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             contentTV.text, @"content",
                             [UserInfo share].userID, @"member_id",
                             self.order.ID, @"order_id",
                             @"", @"images",
                             _goodsDic[@"bn"], @"product_bn",
                             returnMoneyTF.text, @"product_price",
                             returnResonTF.text, @"title",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_ReturnApplyTwo parameters:dic imagePath:nil completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                [Utils showToast:@"申请退货成功，请您耐心等待"];
                [self.navigationController popViewControllerAnimated:YES]; //关闭页面
            }
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
