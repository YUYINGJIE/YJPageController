//
//  YJDemo.m
//  YJPageController
//
//  Created by 于英杰 on 2019/4/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "YJDemo.h"
#import "YJPageControlView.h"
#import "YJListViewController.h"

#define KStatushight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KNavhight self.navigationController.navigationBar.frame.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KSystemHeight  [UIScreen mainScreen].bounds.size.height

@interface YJDemo ()
{
    YJPageControlView * PageControlView;
}
@property(nonatomic,strong) NSMutableArray *viewControllers;
@end

@implementation YJDemo

- (void)viewDidLoad {
    [super viewDidLoad];

   
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.viewControllers = [NSMutableArray array];
    NSArray *titles = @[@"Trending", @"News", @"Library",@"Trending", @"News", @"Library",@"Trending", @"News", @"Library",@"Trending", @"News", @"Library"];
    CGRect frame =CGRectMake(0, 0, kScreenWidth, self.view.bounds.size.height-KNavhight-KStatushight);

    for (int i = 0 ; i<titles.count; i++) {
        YJListViewController *vc = [self viewControllerIndex:i];
        if ([self.VCtype integerValue]==0) {
            vc.viewheight =frame.size.height-40;
        }else{
            vc.viewheight =frame.size.height;
        }
        [self.viewControllers addObject:vc];
    }
    PageControlView = [[YJPageControlView alloc] initWithFrame:frame Titles:titles viewControllers:self.viewControllers Selectindex:0];
    
    if ([self.VCtype integerValue]==0) {
        
        [PageControlView showInViewController:self];
    }
    else{
        [PageControlView showInNavigationController:self.navigationController];

    }

}
- (YJListViewController *)viewControllerIndex:(NSInteger)index {
    YJListViewController *vc = [[YJListViewController alloc] init];
    
    switch (index%2) {
        case 0:
        {
            vc.pageVCindex = [NSString stringWithFormat:@"%zd",index];
        }
            break;
        case 1:
        {
            vc.pageVCindex = [NSString stringWithFormat:@"%zd",index];
            
        }
            break;
        default:
            break;
    }
    return vc;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
