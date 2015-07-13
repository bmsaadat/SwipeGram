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
- (void)changeFeedWithIndex:(NSInteger)index;
- (void)addSearch:(NSString *)search;
@end

@interface HamburgerMenuView : UIView <UISearchBarDelegate> {
    UISearchBar *searchBar;
}
@property (nonatomic, weak) id <HamburgerMenuViewDelegate> delegate;

- (void)dismissKeyboard;

@end
