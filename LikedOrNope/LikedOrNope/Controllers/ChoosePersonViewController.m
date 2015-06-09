//
// ChoosePersonViewController.m
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

#import "ChoosePersonViewController.h"
#import "Person.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "AppDelegate.h"

//static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
//static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@interface ChoosePersonViewController ()
@property (nonatomic, strong) NSMutableArray *people;
@end

@implementation ChoosePersonViewController
@synthesize loginView;
#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        // This view controller maintains a list of ChoosePersonView
        // instances to display.
        //_people = [[self defaultPeople] mutableCopy];
    }
    return self;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self loadMainViews];
    [self loadLoginView];
    
    
    /*
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];

    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.view addSubview:self.backCardView];

    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
//    [self constructNopeButton];
//    [self constructLikedButton];
     
     */
}

- (void)tearDownLoginView {
    [loginView removeFromSuperview];
    _people = [[self defaultPeople] mutableCopy];
}

- (void)loadLoginView {
    loginView = [[InstagramLoginView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loginView];

    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    // here i can set accessToken received on previous login
    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    appDelegate.instagram.sessionDelegate = self;
    if ([appDelegate.instagram isSessionValid]) {
        // Tear down login view
        [self tearDownLoginView];
    }
}

- (void)loadMainViews {
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.view addSubview:self.backCardView];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
//- (void)viewDidCancelSwipe:(UIView *)view {
//    NSLog(@"You couldn't decide on %@.", self.currentUpPerson.name);
//}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]])) {
        // Fade the back card into view.
        self.frontCardView.alpha = 0.f;
        [self.view insertSubview:self.frontCardView belowSubview:self.backCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.frontCardView.alpha = 1.f;
                         } completion:nil];
    }
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(ChoosePersonView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentUpPerson = frontCardView.person;
}

- (void)setBackCardView:(ChoosePersonView *)backCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _backCardView = backCardView;
    self.currentDownPerson = backCardView.person;
}

- (NSArray *)defaultPeople {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"users/self/feed" forKey:@"method"];
    [params setObject:appDelegate.instagram.accessToken forKey:@"access_token"];
    // Make request for this users feed.
    IGRequest *feedRequest = [appDelegate.instagram requestWithParams:params delegate:nil];
    feedRequest.delegate = self;
    
    
    return imageArray;
    
    
    /*
    // It would be trivial to download these from a web service
    // as needed, but for the purposes of this sample app we'll
    // simply store them in memory.
    return @[
             
             
             
             
             
             
             
        [[Person alloc] initWithName:@"Finn"
                               image:[UIImage imageNamed:@"finn"]
                                 age:15
               numberOfSharedFriends:3
             numberOfSharedInterests:2
                      numberOfPhotos:1],
        [[Person alloc] initWithName:@"Jake"
                               image:[UIImage imageNamed:@"jake"]
                                 age:28
               numberOfSharedFriends:2
             numberOfSharedInterests:6
                      numberOfPhotos:8],
        [[Person alloc] initWithName:@"Fiona"
                               image:[UIImage imageNamed:@"fiona"]
                                 age:14
               numberOfSharedFriends:1
             numberOfSharedInterests:3
                      numberOfPhotos:5],
        [[Person alloc] initWithName:@"P. Gumball"
                               image:[UIImage imageNamed:@"prince"]
                                 age:18
               numberOfSharedFriends:1
             numberOfSharedInterests:1
                      numberOfPhotos:2],
    ];*/
}

- (ChoosePersonView *)popPersonViewWithFrame:(CGRect)frame {
    if ([self.people count] == 0) {
        return nil;
    }

    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
//        self.frontCardView.frame = CGRectMake([self frontCardViewFrame].origin.x,
//                                              [self frontCardViewFrame].origin.y - (state.thresholdRatio * 10.f),
//                                              CGRectGetWidth([self frontCardViewFrame]),
//                                              CGRectGetHeight([self frontCardViewFrame]));
    };

    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                    person:self.people[0]
                                                                   options:options];
    [self.people removeObjectAtIndex:0];
    return personView;
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 30.f;
    CGFloat topPadding = 45.f;
    CGFloat bottomPadding = 350.f;
    return CGRectMake(10,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGFloat horizontalPadding = 30.f;
    CGFloat topPadding = 300.f;
    CGFloat bottomPadding = 350.f;
    return CGRectMake(50,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}


// IGSessionDelegate
#pragma mark - IGSessionDelegate

-(void)igDidLogin {
    NSLog(@"Instagram did login");
    // here i can store accessToken
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //IGListViewController* viewController = [[IGListViewController alloc] init];
    //[self.navigationController pushViewController:viewController animated:YES];
    [self tearDownLoginView];
}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}



//// Create and add the "nope" button.
//- (void)constructNopeButton {
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    UIImage *image = [UIImage imageNamed:@"nope"];
//    button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding,
//                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
//                              image.size.width,
//                              image.size.height);
//    [button setImage:image forState:UIControlStateNormal];
//    [button setTintColor:[UIColor colorWithRed:247.f/255.f
//                                         green:91.f/255.f
//                                          blue:37.f/255.f
//                                         alpha:1.f]];
//    [button addTarget:self
//               action:@selector(nopeFrontCardView)
//     forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//}
//
//// Create and add the "like" button.
//- (void)constructLikedButton {
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    UIImage *image = [UIImage imageNamed:@"liked"];
//    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding,
//                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
//                              image.size.width,
//                              image.size.height);
//    [button setImage:image forState:UIControlStateNormal];
//    [button setTintColor:[UIColor colorWithRed:29.f/255.f
//                                         green:245.f/255.f
//                                          blue:106.f/255.f
//                                         alpha:1.f]];
//    [button addTarget:self
//               action:@selector(likeFrontCardView)
//     forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//}

#pragma mark - Request Callbacks

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(IGRequest *)request {
    
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(IGRequest *)request didReceiveResponse:(NSURLResponse *)response {
    
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(IGRequest *)request didLoad:(id)result {
    NSMutableArray *newPeopleArray = [NSMutableArray array];
    
    NSDictionary *dict = (NSDictionary *)result;
    NSArray *data = [dict objectForKey:@"data"];
    for (NSDictionary *post in data) {
        // Contains low/standard/high resolution images
        NSDictionary *imageDict = [post objectForKey:@"images"];
        NSDictionary *lowResImageDict = [imageDict objectForKey:@"low_resolution"];
        NSString *imageURL = [lowResImageDict objectForKey:@"url"];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        UIImage *image = [UIImage imageWithData:imageData];
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        //[self.view addSubview:imageView];
        
        Person *person = [[Person alloc] initWithName:@"Finn"
                               image:image
                                 age:15
               numberOfSharedFriends:3
             numberOfSharedInterests:2
                      numberOfPhotos:1];
        [newPeopleArray addObject:person];
        
    }
    
    _people = [newPeopleArray mutableCopy];
    
    
    [self loadMainViews];
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(IGRequest *)request didLoadRawResponse:(NSData *)data {
    
}

#pragma mark Control Events

//// Programmatically "nopes" the front card view.
//- (void)likeFrontCardView {
//    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
//
//}
//
//// Programmatically "likes" the front card view.
//- (void)likeBackCardView {
//    [self.backCardView mdc_swipe:MDCSwipeDirectionRight];
//}

@end
