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
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        //logo.backgroundColor = [UIColor redColor];
        CGRect logoFrame = logo.frame;
        logoFrame.origin = CGPointMake(-20, 75);
        logo.frame = logoFrame;
        [self addSubview:logo];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //loginButton.backgroundColor = [UIColor colorWithRed:81/255.0 green:127/255.0 blue:164/255.0 alpha:1.0];
        loginButton.backgroundColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];

        [loginButton setTitle:@"Login" forState:UIControlStateNormal];
        loginButton.frame = CGRectMake((frame.size.width - buttonSizeWidth)*0.5, (frame.size.height - buttonSizeHeight)*0.5 + 125, buttonSizeWidth, buttonSizeHeight);
        [loginButton addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
        [loginButton addTarget:self action:@selector(loginTouchBegin:) forControlEvents:UIControlEventTouchDown];
        [loginButton addTarget:self action:@selector(loginTouchEnded:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];
        [self addSubview:loginButton];       
        
    }
    return self;
}

- (void)loginPressed: (UIButton*) button {
    NSLog(@"Button Pressed");
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
    [self loginTouchEnded:button];
}

- (void)loginTouchBegin:(UIButton *)button {
    button.backgroundColor = [UIColor colorWithRed:r_colour * 0.8 green:g_colour * 0.8 blue:b_colour * 0.8 alpha:1.0];
}

- (void)loginTouchEnded:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.backgroundColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
