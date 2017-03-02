//
//  BaseNC.m
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "BaseNC.h"
#import "AEAnimator.h"

// 弄一个子类继承nvc,在这里实现返回动画的代理方法
@interface BaseNC () <UINavigationControllerDelegate>
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) CGRect destinationRec;
@property (nonatomic,assign) CGRect originalRec;
@property (nonatomic,assign) BOOL isPush;
@property (nonatomic,assign) id animationDelegate; // 动画的代理temp
@end

@implementation BaseNC

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 设置UINavigationBar的样式
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [UIFont systemFontOfSize:17], NSFontAttributeName, nil]]; //kColorFromRGBHex(0x2a2a2a)
}

- (void)pushViewController:(UIViewController *)viewController imageView:(UIImageView *)imageView desRec:(CGRect)desRec original:(CGRect)originalRec deleagte:(id<AEAnimatorDelegate>)delegate isAnimation:(BOOL)isAnimation
{
    [[NSUserDefaults standardUserDefaults] setBool:isAnimation forKey:@"ImageJumpAnimation"];
    self.delegate = self; //  让自身成为代理，实现下面的方法
    self.imageView = imageView;
    self.destinationRec = desRec;
    self.originalRec = originalRec;
    self.isPush = YES;
    self.animationDelegate = delegate; // 让动画的代理成为destinationVC
    [super pushViewController:viewController animated:YES];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    self.isPush = NO;
    return  [super popViewControllerAnimated:animated];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ImageJumpAnimation"]) {
        if (self.isPush==NO) { //动画Pop
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ImageJumpAnimation"];
        }
        // 普通push的时候就是小红书类型的
        AEAnimator *animator = [[AEAnimator alloc] init];
        animator.imageView = self.imageView;
        animator.destinationRec = self.destinationRec;
        animator.originalRec = self.originalRec;
        animator.isPush = self.isPush;
        animator.delegate = self.animationDelegate;
        return animator;
    } else {
        return nil;
    }
}

@end
