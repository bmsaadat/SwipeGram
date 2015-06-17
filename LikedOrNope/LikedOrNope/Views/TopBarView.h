//
//  TopBarView.h
//  LikedOrNope
//
//  Created by Behroz Saadat on 2015-06-17.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopBarViewDelegate <NSObject>

- (void)hamburgerButtonPressed;

@end

@interface TopBarView : UIView

@property (nonatomic, weak) id <TopBarViewDelegate> delegate;
@property (nonatomic, strong) UILabel *score;

- (void)incrementScoreBy:(NSInteger)amount;

@end
