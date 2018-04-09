//
//  GoodsCommentVC.m
//  ArtEast
//
//  Created by mac on 2016/11/2.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "GoodsCommentVC.h"
#import "StarRatingView.h"
#import "TZImagePickerController.h"
#import "ImageViewer.h"
#import <UIImageView+AFNetworking.h>
#import "AEFilePath.h"
#import "BaseWebVC.h"
#import "GoodsModel.h"
#import "GoodsDetailVC.h"
#import "BaseNC.h"

#define Count 5  //一行最多放几张图片
#define ImageWidth ([UIScreen mainScreen].bounds.size.width-80)/Count
#define MaxCount 5
#define BottomHeight 45

@interface CommentCell : UICollectionViewCell
@property (nonatomic , retain)UIImageView *imageView;
@property (nonatomic , retain) UIButton *cancelBtn;
@property (nonatomic , retain) UIButton *cancelTapBtn;
@end

@implementation CommentCell


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


@interface GoodsCommentVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate,
UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate,StarRatingViewDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_goodsImgV;
    UILabel *_goodsTileLabel;
    UILabel *_goodsAttributeLabel;
    
    StarRatingView *rateView1;
    StarRatingView *rateView2;
    
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

@implementation GoodsCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品评论";
    imageArr = [NSMutableArray array];
    imageStr = [NSMutableArray array];
    
    [self initViews];
}


- (void)initViews{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavBarH, WIDTH, HEIGHT-BottomHeight-kNavBarH)];
    _scrollView.backgroundColor = [UIColor redColor];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_scrollView];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 80)];
    view1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view1];
    
    _goodsImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, (view1.height-60)/2.0, 60, 60)];
    _goodsImgV.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImgV.clipsToBounds = YES;
    [view1 addSubview:_goodsImgV];
    [_goodsImgV setImageWithURL:[NSURL URLWithString:self.order.thumbnail_pic_src]
              placeholderImage:[UIImage imageNamed:@"GoodsDefault"]];
    
    _goodsTileLabel = [[UILabel alloc]initWithFrame:CGRectMake(_goodsImgV.maxX+10, 10, WIDTH-(_goodsImgV.maxX+5)-15-30, (view1.height-10*2)/2.0)];
    _goodsTileLabel.textColor = kColorFromRGBHex(0x444444);
    _goodsTileLabel.font = [UIFont systemFontOfSize:14];
    _goodsTileLabel.numberOfLines = 0;
    _goodsTileLabel.minimumScaleFactor = 0.8;
    [view1 addSubview:_goodsTileLabel];
    _goodsTileLabel.text = self.order.name;
    
    _goodsAttributeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_goodsTileLabel.x, _goodsTileLabel.maxY, _goodsTileLabel.width, _goodsTileLabel.height)];
    _goodsAttributeLabel.text = [NSString stringWithFormat:@"￥%@",self.order.total_amount];
    _goodsAttributeLabel.textColor = AppThemeColor;
    _goodsAttributeLabel.font = [UIFont systemFontOfSize:14];
    [view1 addSubview:_goodsAttributeLabel];
    
    UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(_goodsTileLabel.maxX, 0, 30, view1.height)];
    arrowImg.image = [UIImage imageNamed:@"Back"];
    arrowImg.contentMode = UIViewContentModeCenter;
    arrowImg.transform = CGAffineTransformMakeRotation( M_PI);
    [view1 addSubview:arrowImg];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, view1.height-0.5, WIDTH, 0.5)];
    lineView.backgroundColor = kColorFromRGBHex(0xe4e4e4);
    [view1 addSubview:lineView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view1.frame;
    [btn addTarget:self action:@selector(showGoodsDetaile) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    
    //商品质量星星 评价
    UIView *startView1 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.maxY, WIDTH, 50)];
    startView1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:startView1];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(_goodsImgV.x, 0, 75, startView1.height)];
    label1.text = @"商品质量：";
    label1.textColor = kColorFromRGBHex(0x444444);
    label1.font = [UIFont systemFontOfSize:14];
    [startView1 addSubview:label1];
    
    rateView1 = [[StarRatingView alloc]initWithFrame:CGRectMake(label1.maxX, 0, WIDTH-label1.maxX-15, startView1.height) type:StarTypeLarge];
    rateView1.tag = 1000;
    rateView1.rate = 5;
    rateView1.delegate = self;
    [startView1 addSubview:rateView1];
    
    
    //物流服务 星星评价
    UIView *startView2 = [[UIView alloc]initWithFrame:CGRectMake(0, startView1.maxY+10, WIDTH, startView1.height)];
    startView2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:startView2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.x, 0, label1.width, startView1.height)];
    label2.text = @"物流服务：";
    label2.textColor = kColorFromRGBHex(0x444444);
    label2.font = [UIFont systemFontOfSize:14];
    [startView2 addSubview:label2];
    
    rateView2 = [[StarRatingView alloc]initWithFrame:CGRectMake(label1.maxX, 0, WIDTH-label1.maxX-15, startView1.height) type:StarTypeLarge];
    rateView2.tag = 2000;
    rateView2.rate = 5;
    rateView2.delegate = self;
    [startView2 addSubview:rateView2];
    
    //评价内容展示
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, startView2.maxY+10, WIDTH, 80)];
    contentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:contentView];
    
    contentTV = [[UITextView alloc]initWithFrame:CGRectMake(_goodsImgV.x-4, 10, WIDTH-_goodsImgV.x*2, contentView.height-10)];
    contentTV.font = [UIFont systemFontOfSize:14];
    contentTV.delegate = self;
    [contentView addSubview:contentTV];
    
    tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(contentTV.x+5, 16, contentTV.width, 20)];
    tishiLabel.text = @"说的什么吧...";
    tishiLabel.textColor = kColorFromRGBHex(0x868686);
    tishiLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:tishiLabel];
    
    //评价图片展示
    UIView *pictureView = [[UIView alloc]initWithFrame:CGRectMake(0, contentView.maxY, WIDTH, ImageWidth+10*2)];
    pictureView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:pictureView];
    
    
    //添加图片的按钮
    addImg = [UIButton buttonWithType:UIButtonTypeCustom];
    addImg.frame = CGRectMake(_goodsImgV.x, 10, ImageWidth, ImageWidth);
    [addImg setBackgroundImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
    [addImg addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [pictureView addSubview:addImg];
    
    //存放图片的UICollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(addImg.maxX+10, 5, WIDTH-10-addImg.maxX-10, ImageWidth+10) collectionViewLayout:flowLayout];
    [collection registerClass:[CommentCell class] forCellWithReuseIdentifier:@"myCell"];
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
    [submitBtn setTitle:@"立即评价" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = ButtonFontSize;
    [submitBtn setTitleColor:ButtonFontColor forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

- (void)showGoodsDetaile{
    NSLog(@"商品点击");
    //[BaseWebVC showWithContro:self withUrlStr:self.order.url withTitle:@"商品详情"];
    
    CGRect descRec = CGRectMake(0, 0, WIDTH, WIDTH); //目的位置
    
    CGRect originalRec;
    UIImageView *imageView = nil;
    originalRec = [_goodsImgV convertRect:_goodsImgV.frame toView:self.view];
    originalRec = CGRectMake(originalRec.origin.x-15, originalRec.origin.y-10, originalRec.size.width, originalRec.size.height);
    imageView = _goodsImgV;
    
    GoodsModel *goodsModel = [[GoodsModel alloc] init];
    goodsModel.ID = self.order.ID;
    goodsModel.icon = self.order.thumbnail_pic_src;
    goodsModel.imageView = imageView;
    goodsModel.descRec = descRec;
    goodsModel.originalRec = originalRec;
    
    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
    goodsDetailVC.goodsModel = goodsModel;
    BaseNC *baseNC = (BaseNC *)self.navigationController;
    [baseNC pushViewController:goodsDetailVC imageView:goodsModel.imageView desRec:goodsModel.descRec original:goodsModel.originalRec deleagte:goodsDetailVC isAnimation:YES];
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
    CommentCell *cell = (CommentCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
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
    CommentCell *cell = (CommentCell *)btn.superview;
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

#pragma mark - 立即评价

- (void)submitData {
    NSLog(@"立即评价");
    
    if ([Utils isBlankString:contentTV.text]) {
        [Utils showToast:@"评论内容不能为空"];
        return;
    }
    photoCount = 0;
    [imageStr removeAllObjects];
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    [self photoUpload]; //单张循环上传
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
                
                //提交评论
                photoCount = 0;
                
                NSString *pointStr = [NSString stringWithFormat:@"%d,%d",(int)rateView1.rate,(int)rateView2.rate];
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     contentTV.text, @"comment",
                                     self.order.goods_id, @"goods_id",
                                     [UserInfo share].userID, @"member_id",
                                     self.order.ID, @"order_id",
                                     pointStr, @"point_json",
                                     picStr, @"images",
                                     self.order.product_id, @"product_id",
                                     nil];
                [[NetworkManager sharedManager] postJSON:URL_GoodsComment parameters:dic imagePath:filePath completion:^(id responseData, RequestState status, NSError *error) {
                    
                    [JHHJView hideLoading]; //结束加载
                    
                    if (status == Request_Success) {
                        [Utils showToast:@"感谢您的评价，谢谢支持"];
                        [self.navigationController popViewControllerAnimated:YES]; //关闭页面
                    }
                    
                }];
            }
        }];
    } else {
        //提交评论
        NSString *pointStr = [NSString stringWithFormat:@"%d,%d",(int)rateView1.rate,(int)rateView2.rate];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             contentTV.text, @"comment",
                             self.order.goods_id, @"goods_id",
                             [UserInfo share].userID, @"member_id",
                             self.order.ID, @"order_id",
                             pointStr, @"point_json",
                             @"", @"images",
                             self.order.product_id, @"product_id",
                             nil];
        
        NSLog(@"rthytjyukjuk%@",dic);
        [[NetworkManager sharedManager] postJSON:URL_GoodsComment parameters:dic imagePath:@"" completion:^(id responseData, RequestState status, NSError *error) {
            
            [JHHJView hideLoading]; //结束加载
            
            if (status == Request_Success) {
                [Utils showToast:@"感谢您的评价，谢谢支持"];
                [self.navigationController popViewControllerAnimated:YES]; //关闭页面
            }
            
        }];
    }
}

#pragma mark - StarRatingViewDelegate

- (void)starRatingView:(StarRatingView *)view rateDidChange:(float)rate {
    if (view.tag == 1000) {
        rateView1.rate = rate;
    }
    if (view.tag == 2000) {
        rateView2.rate = rate;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
