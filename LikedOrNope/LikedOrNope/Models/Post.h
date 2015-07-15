//
//  Post.h
//  LikedOrNope
//
//  Created by Behroz Saadat on 2015-07-14.
//  Copyright (c) 2015 modocache. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * postID;
@property (nonatomic, strong) NSString * user;
- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;
@end
