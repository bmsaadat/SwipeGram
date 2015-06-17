//
//  HamburgerMenuView.m
//  LikedOrNope
//
//  Created by Behroz Saadat on 2015-06-17.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import "HamburgerMenuView.h"

@implementation HamburgerMenuView

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
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 60, frame.size.width - 10, 42)];
        [searchBar setBackgroundImage:[UIImage new]];
        searchBar.delegate = self;
        [searchBar setTranslucent:YES];
        
        [self addSubview:searchBar];
        
        UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(5, 120, frame.size.width - 10, 32)];
        segmentControl.tintColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];
        [segmentControl insertSegmentWithTitle:@"Feed" atIndex:0 animated:NO];
        [segmentControl insertSegmentWithTitle:@"Explore" atIndex:1 animated:NO];
        [segmentControl setSelectedSegmentIndex:0];
        [self addSubview:segmentControl];
    }
    return self;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
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
