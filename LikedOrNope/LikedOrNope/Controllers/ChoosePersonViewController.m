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
    [self defaultPeople];
}

- (void)tearDownLoginView {
    //[loginView removeFromSuperview];
    _people = [[self defaultPeople] mutableCopy];
}



- (void)loadMainViews {
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.topCardView = [self popDownPersonViewWithFrame:[self topCardViewFrame]];
    [self.view addSubview:self.topCardView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.bottomCardView = [self popUpPersonViewWithFrame:[self bottomCardViewFrame]];
    [self.view addSubview:self.bottomCardView];
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
    if ((self.topCardView = [self popDownPersonViewWithFrame:[self topCardViewFrame]])) {
        // Fade the back card into view.
        self.topCardView.alpha = 0.f;
        [self.view insertSubview:self.topCardView belowSubview:self.topCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.topCardView.alpha = 1.f;
                         } completion:nil];
        
    }
    if ((self.bottomCardView = [self popUpPersonViewWithFrame:[self bottomCardViewFrame]])) {
        self.bottomCardView.alpha = 0.f;
        [self.view insertSubview:self.bottomCardView belowSubview:self.bottomCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.bottomCardView.alpha = 1.f;
                         } completion:nil];
    }
}

#pragma mark - Internal Methods

- (void)settopCardView:(ChoosePersonView *)topCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _topCardView = topCardView;
    self.currentUpPerson = topCardView.person;
}

- (void)setbottomCardView:(ChoosePersonView *)bottomCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _bottomCardView = bottomCardView;
    self.currentDownPerson = bottomCardView.person;
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
}

- (ChoosePersonView *)popUpPersonViewWithFrame:(CGRect)frame {
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
        CGRect frame = [self topCardViewFrame];
        self.topCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };

    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                    person:self.people[0]
                                                                   options:options];
    [self.people removeObjectAtIndex:0];
    return personView;
}

- (ChoosePersonView *)popDownPersonViewWithFrame:(CGRect)frame {
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
        CGRect frame = [self bottomCardViewFrame];
        self.bottomCardView.frame = CGRectMake(frame.origin.x,
                                              frame.origin.y - (state.thresholdRatio * 10.f),
                                              CGRectGetWidth(frame),
                                              CGRectGetHeight(frame));
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

- (CGRect)topCardViewFrame {
    CGFloat horizontalPadding = 30.f;
    CGFloat topPadding = 65.f;
    CGFloat bottomPadding = 380.f;
    return CGRectMake(10,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)bottomCardViewFrame {
    CGFloat horizontalPadding = 30.f;
    CGFloat topPadding = 280.f;
    CGFloat bottomPadding = 380.f;
    return CGRectMake(50,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}


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

@end
