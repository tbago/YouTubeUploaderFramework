//
//  YoutubeUploader.h
//  YouTubeUploaderFramework
//
//  Created by tbago on 16/4/12.
//  Copyright © 2016年 tbago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YouTubeUploader : NSObject

- (instancetype)initYoutubeUploaderWithClientID:(NSString *) clientID
                                   clientSecret:(NSString *) clientSecret;

- (BOOL)isAuthorized;

- (UIViewController *)createAuthViewController;

@end
