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
#import <Parse/Parse.h>

//static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
//static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@interface ChoosePersonViewController () {
    UIButton *closeButton;
}
@property (nonatomic, strong) NSMutableArray *imageUrls;
@end

@implementation ChoosePersonViewController
@synthesize max_id;
@synthesize topBar;
@synthesize hamburgerMenu;
@synthesize cardContainer;
@synthesize placesClient;
@synthesize locationManager;
@synthesize currentDataSource;
#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        // This view controller maintains a list of ChoosePersonView
        // instances to display.
        _imageUrls = [NSMutableArray array];
    }
    return self;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    //default to instagram
    currentDataSource = instagram;
    // Create container for cards to be added onto
    cardContainer = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:cardContainer];
    
    // Load top bar
    topBar = [[TopBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 42)];
    topBar.delegate = self;
    [self.view addSubview:topBar];
    
    // Load hamburger menu offscreen
    CGFloat hamburgerWidth = self.view.frame.size.width - 100;
    hamburgerMenu = [[HamburgerMenuView alloc] initWithFrame:CGRectMake(-hamburgerWidth, 0, hamburgerWidth, self.view.frame.size.height)];
    hamburgerMenu.delegate = self;
    [self.view addSubview:hamburgerMenu];
    
    placesClient = [[GMSPlacesClient alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    [self defaultPeople];
}

- (void)loadMainViews {
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.topCardView = [self popDownPersonViewWithFrame:[self topCardViewFrame]];
    [cardContainer addSubview:self.topCardView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.bottomCardView = [self popUpPersonViewWithFrame:[self bottomCardViewFrame]];
    [cardContainer addSubview:self.bottomCardView];
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
    if (self.imageUrls.count < 4) {
        if (currentDataSource == instagram) {
            [self defaultPeople];
        } else if (currentDataSource == google) {
            [self requestGooglePlacesImages];
        }
    }
    [topBar incrementScoreBy:10];
    [self checkForRewards];
        [self.bottomCardView removeFromSuperview];
        self.bottomCardView = [self popUpPersonViewWithFrame:[self bottomCardViewFrame]];
        self.bottomCardView.alpha = 0.f;
        [cardContainer addSubview:self.bottomCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.bottomCardView.alpha = 1.f;
                         } completion:nil];

        [self.topCardView removeFromSuperview];
        self.topCardView = [self popDownPersonViewWithFrame:[self topCardViewFrame]];
        self.topCardView.alpha = 0.f;
        [cardContainer addSubview:self.topCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.topCardView.alpha = 1.f;
                         } completion:nil];
    
}

- (void) checkForRewards {
    NSString *savedScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedScore"];
    if (([savedScore integerValue] % 1000) == 0) {
        [[Kiip sharedInstance] saveMoment:@"thousand_pointer" withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
            if (error) {
                NSLog(@"something's wrong");
                // handle with an Alert dialog.
            }
            if (poptart) {
                [poptart show];
            }
            if (!poptart) {
                // handle logic when there is no reward to give.
            }
        }];
    }
}

#pragma mark - Internal Methods

- (void)settopCardView:(ChoosePersonView *)topCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _topCardView = topCardView;
}

- (void)setbottomCardView:(ChoosePersonView *)bottomCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _bottomCardView = bottomCardView;
}

- (void)defaultPeople {
    if (currentDataSource == google) {
        currentDataSource = instagram;
        @synchronized(self.imageUrls) {
            [self.imageUrls removeAllObjects];
        }
    }
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"users/self/feed" forKey:@"method"];
    [params setObject:appDelegate.instagram.accessToken forKey:@"access_token"];
    if (max_id) {
        [params setObject:max_id forKey:@"max_id"];
    }
    
    // Make request for this users feed.
    IGRequest *feedRequest = [appDelegate.instagram requestWithParams:params delegate:nil];
    feedRequest.delegate = self;
}

- (ChoosePersonView *)popUpPersonViewWithFrame:(CGRect)frame {
    if ([self.imageUrls count] == 0) {
        return nil;
    }

    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 100.f;
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
                                                                    url:self.imageUrls[0]
                                                                   options:options];
    personView.isTop = NO;
    @synchronized(self.imageUrls) {
        [self.imageUrls removeObjectAtIndex:0];
    }
    return personView;
}

- (ChoosePersonView *)popDownPersonViewWithFrame:(CGRect)frame {
    if ([self.imageUrls count] == 0) {
        return nil;
    }
    
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 100.f;
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
                                                                    url:self.imageUrls[0]
                                                                   options:options];
    personView.isTop = YES;
    @synchronized(self.imageUrls) {
        [self.imageUrls removeObjectAtIndex:0];
    }
    return personView;
}

#pragma mark View Contruction

- (CGRect)topCardViewFrame {
    return CGRectMake(20,
                      65.f,
                      200.f,
                      200.f);
}

- (CGRect)bottomCardViewFrame {
    return CGRectMake(100,
                      290.f,
                      200.f,
                      200.f);
}


#pragma mark - Top Bar Delegate
- (void)hamburgerButtonPressed {
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = self.view.frame;
    [closeButton addTarget:self action:@selector(closeHamburgerMenu:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
    [self.view insertSubview:closeButton belowSubview:hamburgerMenu];
    
    CGRect inViewFrame = CGRectMake(0, 0, hamburgerMenu.frame.size.width, hamburgerMenu.frame.size.height);
    // SLide in new hamburger view
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         hamburgerMenu.frame = inViewFrame;
                     } completion:nil];
}

- (void)closeHamburgerMenu: (UIButton *)button {
    [button removeFromSuperview];
    CGRect inViewFrame = CGRectMake(-hamburgerMenu.frame.size.width, 0, hamburgerMenu.frame.size.width, hamburgerMenu.frame.size.height);
    // SLide out new hamburger view
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         hamburgerMenu.frame = inViewFrame;
                     } completion:nil];
}

#pragma mark - Hamburger Menu Delegate
- (void)addGooglePlacesPressed {
    [self closeHamburgerMenu:closeButton];
    // Toggle between instagram/google
    if (currentDataSource == google) {
        // Instagram request
        [self defaultPeople];
    } else if (currentDataSource == instagram) {
        [self requestGooglePlacesImages];
    }
}

- (void)requestGooglePlacesImages {
    if (currentDataSource == instagram) {
        currentDataSource = google;
        @synchronized(self.imageUrls) {
            [self.imageUrls removeAllObjects];
        }
    }
    
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
        if (error != nil) {
            NSLog(@"Current Place error %@", [error localizedDescription]);
            return;
        }
        
        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
            GMSPlace* place = likelihood.place;
            NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
            NSLog(@"Current Place address %@", place.formattedAddress);
            NSLog(@"Current Place attributions %@", place.attributions);
            NSLog(@"Current PlaceID %@", place.placeID);
            
            NSString *detailsRequest = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",place.placeID, GOOGLE_ID];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:detailsRequest]];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (!error) {
                    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    NSDictionary *result = [jsonResponse objectForKey:@"result"];
                    NSArray *photos = [result objectForKey:@"photos"];
                    for (NSDictionary *photoData in photos) {
                        NSString *photoReference = [photoData objectForKey:@"photo_reference"];
                        NSString *photoURL = [NSString stringWithFormat:
                                              @"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=%@", photoReference, GOOGLE_ID];
                        // Add it to the queue
                        @synchronized(self.imageUrls) {
                            [self.imageUrls addObject:photoURL];
                        }
                    }
                    
                    
                } else {
                    
                }
            }];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //NSLog(@"Yes");
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
    NSMutableArray *newUrlArray = [NSMutableArray array];
    
    NSDictionary *dict = (NSDictionary *)result;
    NSDictionary *pagination = [dict objectForKey:@"pagination"];
    self.max_id = [pagination objectForKey:@"next_max_id"];
    
    NSArray *data = [dict objectForKey:@"data"];
    for (NSDictionary *post in data) {
            // Contains low/standard/high resolution images
            NSDictionary *imageDict = [post objectForKey:@"images"];
            NSDictionary *lowResImageDict = [imageDict objectForKey:@"low_resolution"];
            NSString *imageURL = [lowResImageDict objectForKey:@"url"];
            [newUrlArray addObject:imageURL];
    }
    @synchronized(self.imageUrls) {
        [self.imageUrls addObjectsFromArray:[newUrlArray mutableCopy]];
    }
    if (!self.topCardView && !self.bottomCardView) {
        [self loadMainViews];
    }
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(IGRequest *)request didLoadRawResponse:(NSData *)data {
    
}

@end
