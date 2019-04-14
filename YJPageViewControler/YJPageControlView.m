//
//  YJPageControlView.m
//  YJPageController
//
//  Created by 于英杰 on 2019/4/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "YJPageControlView.h"
#import "HMSegmentedControl.h"


@interface YJPageControlView ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong)UIPageViewController *PageViewController;

@end


@implementation YJPageControlView
static const CGFloat SegmentHeight = 40.0f;

-(instancetype)initWithFrame:(CGRect)frame Titles:(NSArray <NSString *>*)titles viewControllers:(NSArray <UIViewController *>*)viewControllers Selectindex:(NSInteger)selectedIndex{
    self = [super initWithFrame:frame];
    if (self) {
        [self SetUpUI];
        self.titles = titles;
        self.viewControllers = viewControllers;
        self.selectedIndex = selectedIndex;
        self.backgroundColor=[UIColor redColor];
    }
    
    return self;
}

-(void)SetUpUI{
    [self addSubview:self.segmentedControl];
    [self addSubview:self.PageViewController.view];
    
}
-(void)setScrollEnabled:(BOOL)scrollEnabled{
    
    for (UIScrollView *scrollView in self.PageViewController.view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            scrollView.scrollEnabled=NO;
        }
    }
    
}
- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    _segmentedControl.sectionTitles = _titles;
    _segmentedControl.selectedSegmentIndex = 0;
}
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    self.segmentedControl.selectedSegmentIndex = _selectedIndex;
    [self SelecteViewControllerIndex:_selectedIndex];
}

- (void)SelecteViewControllerIndex:(NSInteger)index {
    __weak __typeof(self)weakSelf = self;
    [self.PageViewController setViewControllers:@[_viewControllers[index]] direction:index<_selectedIndex animated:YES completion:^(BOOL finished) {
        _selectedIndex = index;
        [weakSelf performSwitchDelegateMethod];
    }];
    
}

/**
 当视图即将加入父视图时 / 当视图即将从父视图移除时调用
*/
- (void)willMoveToSuperview:(UIView *)newSuperview {
   [super willMoveToSuperview:newSuperview];
    [self SelecteViewControllerIndex:_selectedIndex];
}
- (void)showInViewController:(UIViewController *)viewController {
    [viewController addChildViewController:self.PageViewController];
    NSLog(@"-------%@",@(self.PageViewController.view.frame));
    [viewController.view addSubview:self];
}

- (void)showInNavigationController:(UINavigationController *)navigationController {
    [navigationController.topViewController.view addSubview:self];
    [navigationController.topViewController addChildViewController:self.PageViewController];
    navigationController.topViewController.navigationItem.titleView = self.segmentedControl;
    self.PageViewController.view.frame = self.bounds;
    self.segmentedControl.backgroundColor = [UIColor clearColor];
}
#pragma mark --UISegmentedControl 事件
- (void)segmentValueChanged:(UISegmentedControl *)SegmentedControl {
    NSInteger index = SegmentedControl.selectedSegmentIndex;
    [self SelecteViewControllerIndex:index];
}

#pragma mark --UIPageViewControllerDelegate  DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    UIViewController *vc;
    if (_selectedIndex + 1 < _viewControllers.count) {
        vc = _viewControllers[_selectedIndex + 1];
        vc.view.bounds = pageViewController.view.bounds;
    }
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController *vc;
    if (_selectedIndex - 1 >= 0) {
        vc = _viewControllers[_selectedIndex - 1];
        vc.view.bounds = pageViewController.view.bounds;
    }
    return vc;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.selectedIndex = [_viewControllers indexOfObject:pageViewController.viewControllers.firstObject];
    self.segmentedControl.selectedSegmentIndex = _selectedIndex;
    [self performSwitchDelegateMethod];
}

//代理方法
- (void)performSwitchDelegateMethod {
    if ([self.delegate respondsToSelector:@selector(SelectAtIndex:)]) {
        [self.delegate SelectAtIndex:self.selectedIndex];
    }
}
-(HMSegmentedControl*)segmentedControl{
    if (_segmentedControl==nil) {
        CGFloat viewWidth = CGRectGetWidth(self.frame);
        _segmentedControl= [[HMSegmentedControl alloc] initWithSectionTitles:self.titles];
        _segmentedControl.frame = CGRectMake(0, 0, viewWidth, SegmentHeight);
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        //indicator和文本等宽（含inset）、和segment一样宽，背景大方块，箭头
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        //indicator位置
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        //选中indicator
        _segmentedControl.selectionIndicatorColor = RGBACOLOR(228, 0, 54, 1);
        _segmentedControl.selectionIndicatorHeight = 1.0f;
        _segmentedControl.backgroundColor =[UIColor whiteColor];
        //标题属性
        _segmentedControl.titleTextAttributes = @{
                                                  NSForegroundColorAttributeName : [UIColor blackColor],
                                                  NSFontAttributeName:[UIFont systemFontOfSize:15.0]
                                                  };
        //选中标题属性
        _segmentedControl.selectedTitleTextAttributes =@{
                                                         NSForegroundColorAttributeName : RGBACOLOR(228, 0, 54, 1),
                                                         NSFontAttributeName:[UIFont systemFontOfSize:15.0]
                                                         };
        _segmentedControl.selectedSegmentIndex = _selectedIndex;
        [_segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];


    }
    return _segmentedControl;
    
}
-(UIPageViewController*)PageViewController{
    
    if (_PageViewController==nil) {
        _PageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _PageViewController.view.frame = CGRectMake(0, SegmentHeight, self.bounds.size.width, self.bounds.size.height - SegmentHeight);
        _PageViewController.delegate = self;
        _PageViewController.dataSource = self;
    }
    
    return _PageViewController;
}

@end
