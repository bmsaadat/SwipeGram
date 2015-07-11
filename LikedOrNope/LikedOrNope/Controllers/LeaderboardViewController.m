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
    PFObject *userScore = [PFObject objectWithClassName:@"UserScore"];
    userScore[@"score"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedScore"];
    userScore[@"playerName"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    userScore[@"cheatMode"] = @NO;
    [userScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Success");
        } else {
            NSLog(@"Error");
        }
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
    PFObject *tempObject = [highScores objectAtIndex:indexPath.row];
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [[NSString stringWithFormat:@"%li. ", indexPath.row+1] stringByAppendingString:[tempObject objectForKey:@"playerName"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Score: %@",
                                 [tempObject objectForKey:@"score"]];
    
    return cell;
}

@end
