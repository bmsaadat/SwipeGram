//
//  LoginViewController.m
//  LikedOrNope
//
//  Created by Behroz Saadat on 2015-06-12.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "TabBarController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadLoginView];
}

- (void)loadLoginView {
    loginView = [[InstagramLoginView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loginView];
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    // here i can set accessToken received on previous login
    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    appDelegate.instagram.sessionDelegate = self;
    if ([appDelegate.instagram isSessionValid]) {
        // Tear down login view
        [self tearDownLoginView];
    }
}

- (void)tearDownLoginView {
    TabBarController *tabBarController = [[TabBarController alloc] init];
    [self.navigationController pushViewController:tabBarController animated:NO];
    [self removeFromParentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// IGSessionDelegate
#pragma mark - IGSessionDelegate

-(void)igDidLogin {
    // here i can store accessToken
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self tearDownLoginView];
}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
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
