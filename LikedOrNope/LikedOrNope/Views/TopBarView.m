//
//  TopBarView.m
//  LikedOrNope
//
//  Created by Behroz Saadat on 2015-06-17.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import "TopBarView.h"

@implementation TopBarView

@synthesize delegate;
@synthesize score;

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (NSClassFromString(@"UIVisualEffectView")) {
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]] ;
            effectView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            [self addSubview:effectView];
        } else {
            self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
        }
        
        UIButton *hamburger = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [hamburger setTintColor:[UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0]];
        [hamburger setImage:[UIImage imageNamed:@"hamburger.png"] forState:UIControlStateNormal];
        hamburger.frame = CGRectMake(5, 0, 42, 42);
        [hamburger addTarget:self action:@selector(hamburgerPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hamburger];
        
        
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width*0.5,self.frame.size.height)];
        scoreLabel.font = [UIFont systemFontOfSize:16];
        scoreLabel.textColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];
        scoreLabel.text = @"My Score:";
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:scoreLabel];
        
        
        // Load score
        NSNumber *savedScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedScore"];
        
        score = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * 0.5 + 10, 0, frame.size.width * 0.5,self.frame.size.height)];
        score.font = [UIFont systemFontOfSize:16];
        score.textColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];
        score.text = [savedScore description];
        score.backgroundColor = [UIColor clearColor];
        score.textAlignment = NSTextAlignmentLeft;
        [self addSubview:score];
    }
    return self;
}

- (void)incrementScoreBy:(NSInteger)amount {
    NSInteger currentScore = [score.text intValue];
    currentScore += amount;
    score.text = [NSString stringWithFormat:@"%ld", (long)currentScore];
    [[NSUserDefaults standardUserDefaults] setInteger:currentScore forKey:@"savedScore"];
}

- (void)hamburgerPressed: (UIButton *)button {    
    [self.delegate hamburgerButtonPressed];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
