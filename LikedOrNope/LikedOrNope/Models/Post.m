//
//  Post.m
//  LikedOrNope
//
//  Created by Behroz Saadat on 2015-07-14.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import "Post.h"

@implementation Post
@synthesize url;
@synthesize postID;
@synthesize user;

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    return [self.postID isEqualToString:((Post*)object).postID];
}

- (NSUInteger)hash {
    
    return [self.postID hash];
    
}
@end
