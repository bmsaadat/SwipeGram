//
//  TabBarController.m
//  LikedOrNope
//
//  Created by Behroz Saadat on 2015-06-12.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import "TabBarController.h"
#import "ChoosePersonViewController.h"
#import "ProfileViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ProfileViewController *view1 = [[ProfileViewController alloc] init];
    ChoosePersonViewController *view2 = [[ChoosePersonViewController alloc] init];
    UIViewController *view3 = [[UIViewController alloc] init];
    
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    [tabViewControllers addObject:view1];
    [tabViewControllers addObject:view2];
    [tabViewControllers addObject:view3];
    
    [self setViewControllers:tabViewControllers];
    //can't set this until after its added to the tab bar
    //view1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    view1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"profile.png"] tag:1];
    view2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:2];
    view3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Leaderboards" image:[UIImage imageNamed:@"leaderboard.png"] tag:3];
    [self setSelectedViewController:view2];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0]];
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
