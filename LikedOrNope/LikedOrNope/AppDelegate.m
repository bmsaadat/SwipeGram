//
// AppDelegate.m
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@implementation AppDelegate

@synthesize instagram;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.instagram = [[Instagram alloc] initWithClientId:INSTAGRAM_CLIENT_ID delegate:nil];

    [GMSServices provideAPIKey:GOOGLE_ID];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    //self.window.rootViewController = [ChoosePersonViewController new];
    UINavigationController *navController = [[UINavigationController alloc] init];
    navController.navigationBar.hidden = YES;
    if ([navController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [navController pushViewController:[LoginViewController new] animated:NO];
    [navController setEdgesForExtendedLayout:UIRectEdgeNone];
    self.window.rootViewController = navController;
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"aKHr5kUMc4jV0Pj48NAokXxA4djuSPFI19QWnGId"
                  clientKey:@"rPheafbEuOIHeL6bgBe2A0Lznk5m9oOoY30tBoEh"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // ...
    
    Kiip *kiip = [[Kiip alloc] initWithAppKey:@"954f31fc4114d71e8d44140ecaaf06b0" andSecret:@"46f69dafee6ff9742131700edea4a6b3"];
    kiip.delegate = self;
    [Kiip setSharedInstance:kiip];
    return YES;
}


// YOU NEED TO CAPTURE igAPPID:// schema
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.instagram handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.instagram handleOpenURL:url];
}

@end
