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

/**
 *  Upload video to youtube
 *
 *  @param fileData
 *  @param title
 *  @param description
 *  @param porcess     
 *  @param complate    when success,message will be video identifier
 */
- (void)uploadYoutubeVideo:(NSData *) fileData
                     title:(NSString *) title
               description:(NSString *) description
                   process:(void(^)(float percent)) porcess
                  complate:(void(^)(BOOL success, NSString *message)) complate;
@end
