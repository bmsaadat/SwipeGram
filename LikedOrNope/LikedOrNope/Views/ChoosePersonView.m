//
// ChoosePersonView.m
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

#import "ChoosePersonView.h"
#import "ImageLabelView.h"
#import "Post.h"
static const CGFloat ChoosePersonViewImageLabelWidth = 42.f;

@interface ChoosePersonView ()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ImageLabelView *cameraImageLabelView;
@property (nonatomic, strong) ImageLabelView *interestsImageLabelView;
@property (nonatomic, strong) ImageLabelView *friendsImageLabelView;
@end

@implementation ChoosePersonView
@synthesize isTop;
@synthesize pop;
@synthesize post;
#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       post:(Post *)p
                      options:(MDCSwipeToChooseViewOptions *)options{
    self = [super initWithFrame:frame options:options];
    if (self) {
        
        self.post = p;
        
        //self.imageView.image = _person.image;
        NSString *url = post.url;
        self.imageView.layer.cornerRadius = 5.f;
        [self downloadImageWithURL:[NSURL URLWithString:url] completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                UIImage *image = [UIImage imageWithData:data];
                self.imageView.image = image;
            }
        }];
        
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
                                UIViewAutoresizingFlexibleWidth |
                                UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        
        // Tapping gesture
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired=1;
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)handleTapGesture:(UIGestureRecognizer *) gesture {
    UIViewController *popover = [UIViewController new];
    UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, popover.view.frame.size.width - 20,50)];
    menuLabel.font = [UIFont systemFontOfSize:20];
    menuLabel.textColor = [UIColor colorWithRed:text_colour green:text_colour blue:text_colour alpha:1.0];
    menuLabel.text = [NSString stringWithFormat:@"Posted by: %@", self.post.user];
    menuLabel.backgroundColor = [UIColor clearColor];
    menuLabel.textAlignment = NSTextAlignmentCenter;
    [menuLabel sizeToFit];
    [self addSubview:menuLabel];
    
    [popover.view addSubview:menuLabel];
    pop = [[WYPopoverController alloc]initWithContentViewController:popover];
    [pop setDelegate:self];
    [pop presentPopoverFromRect:self.bounds inView:self permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
    [pop setPopoverContentSize:CGSizeMake(menuLabel.frame.size.width + 20, 50)];
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    pop.delegate = nil;
    pop = nil;
}


- (ImageLabelView *)buildImageLabelViewLeftOf:(CGFloat)x image:(UIImage *)image text:(NSString *)text {
    CGRect frame = CGRectMake(x - ChoosePersonViewImageLabelWidth,
                              0,
                              ChoosePersonViewImageLabelWidth,
                              CGRectGetHeight(_informationView.bounds));
    ImageLabelView *view = [[ImageLabelView alloc] initWithFrame:frame
                                                           image:image
                                                            text:text];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    return view;
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            completionBlock(YES, data);
        } else {
            completionBlock(NO, nil);
        }
    }];
}

@end
