//
//  YoutubeUploader.m
//  YouTubeUploaderFramework
//
//  Created by tbago on 16/4/12.
//  Copyright © 2016年 tbago. All rights reserved.
//

#import "YouTubeUploader.h"
#import "GTLYouTube.h"
#import "GTMOAuth2ViewControllerTouch.h"

#import "Utils.h"
#import "YouTubeUploadVideo.h"

@interface YouTubeUploader()
@property (strong, nonatomic) NSString                  *clientID;
@property (strong, nonatomic) NSString                  *clientSecret;

@property (strong, nonatomic) GTLServiceYouTube         *youtubeService;
@property(nonatomic, strong) YouTubeUploadVideo         *uploadVideo;
@end

@implementation YouTubeUploader

#pragma mark -init

- (instancetype)initYoutubeUploaderWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret {
    self = [super init];
    if (self) {
        self.clientID = clientID;
        self.clientSecret = clientSecret;
        self.youtubeService.authorizer =
        [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                              clientID:kClientID
                                                          clientSecret:kClientSecret];
    }
    return self;
}

#pragma mark - public method

- (BOOL)isAuthorized {
    return [((GTMOAuth2Authentication *)self.youtubeService.authorizer) canAuthorize];
}

- (UIViewController *)createAuthViewController {
    GTMOAuth2ViewControllerTouch *authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeYouTube
                                                                                              clientID:self.clientID
                                                                                          clientSecret:self.clientSecret
                                                                                      keychainItemName:kKeychainItemName
                                                                                              delegate:self
                                                                                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

- (void)uploadYoutubeVideo:(NSData *) fileData
                     title:(NSString *) title
               description:(NSString *) description
                  complate:(void(^)(BOOL success, NSString *message)) complate {
    
    [self.uploadVideo uploadYouTubeVideoWithService:self.youtubeService
                                           fileData:fileData
                                              title:title
                                        description:description];
}

#pragma mark - uploadYouTubeVideo

- (void)uploadYouTubeVideo:(YouTubeUploadVideo *)uploadVideo
      didFinishWithResults:(GTLYouTubeVideo *)video {
    [Utils showAlert:@"Video Uploaded" message:video.identifier];
}

#pragma mark - private method
// Handle completion of the authorization process, and updates the YouTube service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        [Utils showAlert:@"Authentication Error" message:error.localizedDescription];
        self.youtubeService.authorizer = nil;
    } else {
        self.youtubeService.authorizer = authResult;
    }
}

#pragma mark - get & set

- (GTLServiceYouTube *)youtubeService {
    if (_youtubeService == nil) {
        _youtubeService = [[GTLServiceYouTube alloc] init];
    }
    return _youtubeService;
}

- (YouTubeUploadVideo *)uploadVideo {
    if (_uploadVideo == nil) {
        _uploadVideo = [[YouTubeUploadVideo alloc] init];
    }
    return _uploadVideo;
}
@end
