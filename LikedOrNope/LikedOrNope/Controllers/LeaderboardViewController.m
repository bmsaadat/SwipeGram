//
//  LeaderboardViewController.m
//  LikedOrNope
//
//  Created by Abhishek Sisodia on 2015-06-16.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import "LeaderboardViewController.h"

@implementation LeaderboardViewController {
    UITableView *highScoreTable;
    NSArray *highScores;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *globalLeaderBoard = [UIButton buttonWithType:UIButtonTypeCustom];
    [globalLeaderBoard setTitle:@"Global" forState:UIControlStateNormal];
    
    globalLeaderBoard.frame = CGRectMake(5.f, 20.f, 150.f, 32.f);
    globalLeaderBoard.backgroundColor = [UIColor colorWithRed:r_colour green:g_colour blue:b_colour alpha:1.0];
    
    UIButton *localLeaderBoard = [UIButton buttonWithType:UIButtonTypeCustom];
    [localLeaderBoard setTitle:@"Local" forState:UIControlStateNormal];
    
    localLeaderBoard.frame = CGRectMake(160.f, 20.f, 150.f, 32.f);
    localLeaderBoard.backgroundColor = [UIColor colorWithRed:11/255.0 green:179/255.0 blue:252/255.0 alpha:1.0];
    
    highScoreTable = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 70.f, 500.f, 500.f) style:UITableViewStylePlain];
    
    highScoreTable.delegate = self;
    highScoreTable.dataSource = self;
    
    highScores = @[@"1. You - 193,030", @"2. Guys - 156,849", @"3. Rock - 123,595", @"4. Vote - 110,292",
                   @"5. Us - 100,383", @"6. For - 99,202", @"7. Best - 84,393", @"8. Demo - 75,4400" ];
    // add to canvas
    [self.view addSubview:highScoreTable];
    [self.view addSubview:globalLeaderBoard];
    [self.view addSubview:localLeaderBoard];

}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [highScores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    [cell.textLabel setText:[highScores objectAtIndex:indexPath.row]];
    return cell;
}

@end
