//
//  YJPageControlView.h
//  YJPageController
//
//  Created by 于英杰 on 2019/4/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KStatushight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KNavhight self.navigationController.navigationBar.frame.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KSystemHeight  [UIScreen mainScreen].bounds.size.height
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@protocol YJPageControlViewDelegate <NSObject>

@optional
/**
 * 切换位置后的代理方法
 */
- (void)SelectAtIndex:(NSInteger)index;

@end

@interface YJPageControlView : UIView
@property (nonatomic, weak) id <YJPageControlViewDelegate>delegate;
/** 默认选择的index */
@property (nonatomic, assign) NSInteger selectedIndex;
/** scrollEnabled 是否支持滑动*/
@property (nonatomic, assign) BOOL scrollEnabled;
/** lineColor */
@property (nonatomic, strong) UIColor* lineColor;

/**初始化方法*/
-(instancetype)initWithFrame:(CGRect)frame Titles:(NSArray <NSString *>*)titles viewControllers:(NSArray <UIViewController *>*)viewControllers Selectindex:(NSInteger)selectedIndex;
/**标题显示在ViewController中*/
-(void)showInViewController:(UIViewController *)viewController;
/**标题显示在NavigationBar中*/
-(void)showInNavigationController:(UINavigationController *)navigationController;
@end
