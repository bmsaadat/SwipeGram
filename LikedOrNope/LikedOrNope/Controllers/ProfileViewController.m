//
//  ProfileViewController.m
//  LikedOrNope
//
//  Created by Abhishek Sisodia on 2015-06-16.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIView+Facade.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

#define buttonSizeWidth     200
#define buttonSizeHeight    42

static NSString * const kLabelFont = @"OpenSans-Semibold";

@interface ProfileViewController () {
    UIScrollView *_scrollView;
    
    UIImageView *_headerImageView;
    
    UIImageView *_avatarImageView;
    UILabel *_nameLabel;
    UILabel *_usernameLabel;
    UIButton *_scoreButton;
    UIButton *logoutButton;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)setupSubviews {
    UIColor *componentColor = [UIColor colorWithRed:11/255.0 green:179/255.0 blue:252/255.0 alpha:1.0];
    
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    
    _headerImageView = [UIImageView new];
    _headerImageView.image = [UIImage imageNamed:@"foodie.png"];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;
    _headerImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_headerImageView];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = [UIImage imageNamed:@"jake.jpg"];
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.layer.cornerRadius = 50;
    _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarImageView.layer.borderWidth = 1.5;
    [_scrollView addSubview:_avatarImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"Drake";
    _nameLabel.font = [UIFont boldSystemFontOfSize:25];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_nameLabel];
    
    _usernameLabel = [UILabel new];
    _usernameLabel.text = @"_ilovefood93";
    _usernameLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_usernameLabel];
    
    _scoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scoreButton setTitle:@"19,3030" forState:UIControlStateNormal];
    [_scoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scoreButton setBackgroundColor:componentColor];
    _scoreButton.layer.cornerRadius = 5;
    _scoreButton.layer.borderWidth = 1;
    _scoreButton.layer.borderColor = componentColor.CGColor;
    [_scrollView addSubview:_scoreButton];
    
    
    logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.backgroundColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    logoutButton.frame = CGRectMake((_scrollView.frame.size.width - buttonSizeWidth)*0.5, (_scrollView.frame.size.height - buttonSizeHeight)*0.5, buttonSizeWidth, buttonSizeHeight);
    [logoutButton addTarget:self action:@selector(logoutPressed:) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton addTarget:self action:@selector(logoutTouchBegin:) forControlEvents:UIControlEventTouchDown];
    [logoutButton addTarget:self action:@selector(logoutTouchEnded:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];

    [_scrollView addSubview:logoutButton];
}

- (void)logoutTouchBegin:(UIButton *)button {
    button.backgroundColor = [UIColor colorWithRed:r_colour * 0.8 green:g_colour * 0.8 blue:b_colour * 0.8 alpha:1.0];
}

- (void)logoutPressed:(UIButton *)button {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.instagram.sessionDelegate = self;
    [appDelegate.instagram logout];
    [self logoutTouchEnded:button];
}

- (void)logoutTouchEnded:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.backgroundColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self layoutFacade];
}

- (void)layoutFacade {
    [_scrollView fillSuperview];
    [_headerImageView anchorTopCenterFillingWidthWithLeftAndRightPadding:0 topPadding:0 height:250];
    [_avatarImageView alignUnder:_headerImageView matchingCenterWithTopPadding:-50 width:100 height:100];
    [_nameLabel alignUnder:_avatarImageView centeredFillingWidthWithLeftAndRightPadding:7 topPadding:14 height:28];
    [_usernameLabel alignUnder:_nameLabel centeredFillingWidthWithLeftAndRightPadding:7 topPadding:2 height:19];
    [_scoreButton alignUnder:_usernameLabel matchingCenterWithTopPadding:20 width:250 height:44];
    [logoutButton alignUnder:_scoreButton matchingCenterWithTopPadding:20 width:250 height:44];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}

@end
