//
//  LeaderboardViewController.m
//  LikedOrNope
//
//  Created by Abhishek Sisodia on 2015-06-16.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import "LeaderboardViewController.h"
#import <Parse/Parse.h>

@implementation LeaderboardViewController {
    UITableView *highScoreTable;
    NSMutableArray *highScores;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *globalLeaderBoard = [UIButton buttonWithType:UIButtonTypeCustom];
    [globalLeaderBoard setTitle:@"Leaderboard" forState:UIControlStateNormal];
    
    globalLeaderBoard.frame = CGRectMake(80.f, 10.f, 150.f, 32.f);
    globalLeaderBoard.backgroundColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];

    highScoreTable = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 55.f, 500.f, 500.f) style:UITableViewStylePlain];
    
    highScoreTable.delegate = self;
    highScoreTable.dataSource = self;
    
    // add to canvas
    [self.view addSubview:highScoreTable];
    [self.view addSubview:globalLeaderBoard];
    [self performSelector:@selector(retrieveFromParse)];
}

- (void) retrieveFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"UserScore"];
    [query orderByDescending:@"score"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            highScores = [[NSMutableArray alloc] initWithArray:objects];
        }
        [highScoreTable reloadData];
    }];
}

- (void) viewDidAppear:(BOOL)animated{
    [self performSelector:@selector(retrieveFromParse)];

    PFQuery *query = [PFQuery queryWithClassName:@"UserScore"];
    [query whereKey:@"accessToken" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            int score = 0;
            NSString *objectID;
            for (PFObject *object in objects) {
                score = [[object objectForKey:@"score"] intValue];
                objectID = object.objectId;
            }
            [[NSUserDefaults standardUserDefaults] setObject:objectID forKey:@"objectID"];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    PFQuery *updateQuery = [PFQuery queryWithClassName:@"UserScore"];
    // Retrieve the object by id
    [updateQuery getObjectInBackgroundWithId:[[NSUserDefaults standardUserDefaults] objectForKey:@"objectID"]
                                       block:^(PFObject *gameScore, NSError *error) {
                                           // Now let's update it with some new data. In this case, only cheatMode and score
                                           // will get sent to the cloud. playerName hasn't changed.
                                           NSInteger score = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScore"] integerValue];
                                           gameScore[@"score"] = [NSNumber numberWithInteger:score];
                                           gameScore[@"playerName"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
                                           [gameScore saveInBackground];
                                       }];
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [highScores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    UIButton *followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    followButton.frame = CGRectMake(230.0f, 7.0f, 80.0f, 30.0f);
    followButton.backgroundColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];
    followButton.titleLabel.textColor = [UIColor whiteColor];
    followButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [followButton setTitle:@"Follow" forState:UIControlStateNormal];
    [followButton setTitle:@"Following" forState:UIControlStateSelected];
    [followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    PFObject *tempObject = [highScores objectAtIndex:indexPath.row];
    NSString *userName = [tempObject objectForKey:@"playerName"];
    if ([userName isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]]) {
        cell.textLabel.text = [[NSString stringWithFormat:@"%li. ", indexPath.row+1] stringByAppendingString:@"You"];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.detailTextLabel.textColor = [UIColor orangeColor];
        [followButton removeFromSuperview];
    } else {
    // Configure the cell to show todo item with a priority at the bottom
        cell.textLabel.text = [[NSString stringWithFormat:@"%li. ", indexPath.row+1] stringByAppendingString:[tempObject objectForKey:@"playerName"]];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:followButton];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Score: %@",
                                 [tempObject objectForKey:@"score"]];
    
    return cell;
}

-(void)followButtonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = YES;
}
@end
