//
//  InstagramLoginView.m
//  LikedOrNope
//
//  Created by Behroz Saadat on 2015-06-08.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import "InstagramLoginView.h"
#import "AppDelegate.h"
#define buttonSizeWidth     200
#define buttonSizeHeight    42

@implementation InstagramLoginView

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.backgroundColor = [UIColor colorWithRed:81/255.0 green:127/255.0 blue:164/255.0 alpha:1.0];
        [loginButton setTitle:@"Login" forState:UIControlStateNormal];
        loginButton.frame = CGRectMake((frame.size.width - buttonSizeWidth)*0.5, (frame.size.height - buttonSizeHeight)*0.5, buttonSizeWidth, buttonSizeHeight);
        [loginButton addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginButton];       
        
    }
    return self;
}

- (void)loginPressed: (UIButton*) button {
    NSLog(@"Button Pressed");
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
