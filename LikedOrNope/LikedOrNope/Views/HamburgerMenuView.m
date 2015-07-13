//
//  HamburgerMenuView.m
//  LikedOrNope
//
//  Created by Behroz Saadat on 2015-06-17.
//  Copyright (c) 2015 modocache. All rights reserved.
//
#import "AppDelegate.h"
#import "HamburgerMenuView.h"
#define buttonSizeWidth     200
#define buttonSizeHeight    42

@implementation HamburgerMenuView
@synthesize delegate;
- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (NSClassFromString(@"UIVisualEffectView")) {
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]] ;
            effectView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            [self addSubview:effectView];
        } else {
            self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
        }
        
        UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,50)];
        menuLabel.font = [UIFont systemFontOfSize:20];
        menuLabel.textColor = [UIColor colorWithRed:text_colour green:text_colour blue:text_colour alpha:1.0];
        menuLabel.text = @"Menu";
        menuLabel.backgroundColor = [UIColor clearColor];
        menuLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:menuLabel];
        
        // Search bar
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 60, frame.size.width - 10, 42)];
        [searchBar setBackgroundImage:[UIImage new]];
        searchBar.delegate = self;
        [searchBar setTranslucent:YES];
        
        [self addSubview:searchBar];
        
        UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(5, 120, frame.size.width - 10, 32)];
        segmentControl.tintColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];
        [segmentControl insertSegmentWithTitle:@"Feed" atIndex:0 animated:NO];
        [segmentControl insertSegmentWithTitle:@"Explore" atIndex:1 animated:NO];
        [segmentControl addTarget:self action:@selector(feedChanged:) forControlEvents:UIControlEventValueChanged];
        [segmentControl setSelectedSegmentIndex:0];
        [self addSubview:segmentControl];
        
        UIButton *googleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //loginButton.backgroundColor = [UIColor colorWithRed:81/255.0 green:127/255.0 blue:164/255.0 alpha:1.0];
        googleButton.backgroundColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];
        
        [googleButton setTitle:@"Use Google Places" forState:UIControlStateNormal];
        googleButton.frame = CGRectMake((frame.size.width - buttonSizeWidth)*0.5, frame.size.height - buttonSizeHeight - 80, buttonSizeWidth, buttonSizeHeight);
        [googleButton addTarget:self action:@selector(googlePressed:) forControlEvents:UIControlEventTouchUpInside];
        [googleButton addTarget:self action:@selector(googleTouchBegan:) forControlEvents:UIControlEventTouchDown];
        [googleButton addTarget:self action:@selector(googleTouchEnded:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];
        [self addSubview:googleButton];
    }
    return self;
}

- (void)feedChanged:(UISegmentedControl *)control {
    [self.delegate changeFeedWithIndex:control.selectedSegmentIndex];    
}

- (void)googlePressed:(UIButton*) button {
    [self.delegate addGooglePlacesPressed];
    [self googleTouchEnded:button];
    
    // Toggle
    if ([button.titleLabel.text isEqualToString:@"Use Google Places"]) {
        [button setTitle:@"Use Instagram" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"Use Google Places" forState:UIControlStateNormal];
    }
}

- (void)googleTouchBegan:(UIButton *)button {
    button.backgroundColor = [UIColor colorWithRed:r_colour * 0.8 green:g_colour * 0.8 blue:b_colour * 0.8 alpha:1.0];
}

- (void)googleTouchEnded:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.backgroundColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];
    }];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)sb {
    [sb resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)sb {
    NSString *searchString = [sb.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self.delegate addSearch:searchString];   
    [sb resignFirstResponder];
}

- (void)dismissKeyboard {
    [searchBar resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
