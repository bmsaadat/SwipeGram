//
//  LoginViewController.h
//  LikedOrNope
//
//  Created by Behroz Saadat on 2015-06-12.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramLoginView.h"
#import "Instagram.h"

@interface LoginViewController : UIViewController <IGSessionDelegate>

@property (nonatomic, strong) InstagramLoginView *loginView;

@end
