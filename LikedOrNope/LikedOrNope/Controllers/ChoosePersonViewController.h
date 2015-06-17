//
// ChoosePersonViewController.h
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

#import <UIKit/UIKit.h>
#import "ChoosePersonView.h"
#import "Instagram.h"
#import "TopBarView.h"
#import "HamburgerMenuView.h"

@interface ChoosePersonViewController : UIViewController <MDCSwipeToChooseDelegate, IGSessionDelegate, IGRequestDelegate, TopBarViewDelegate>

@property (nonatomic, strong) Person *currentDownPerson;
@property (nonatomic, strong) Person *currentUpPerson;
@property (nonatomic, strong) ChoosePersonView *topCardView;
@property (nonatomic, strong) ChoosePersonView *bottomCardView;
@property (nonatomic, strong) UIView *cardContainer;
@property (nonatomic, strong) TopBarView *topBar;
@property (nonatomic, strong) HamburgerMenuView *hamburgerMenu;

// Pagination -- specifies the next feed of images
@property (nonatomic, strong) NSString *max_id;
@end
