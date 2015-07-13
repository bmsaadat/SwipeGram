//
//  HamburgerMenuView.h
//  LikedOrNope
//
//  Created by Behroz Saadat on 2015-06-17.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@protocol HamburgerMenuViewDelegate <NSObject>

- (void)addGooglePlacesPressed;

@end

@interface HamburgerMenuView : UIView <UISearchBarDelegate>
@property (nonatomic, weak) id <HamburgerMenuViewDelegate> delegate;

@end
