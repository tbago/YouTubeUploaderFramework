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

@interface YouTubeUploader()
@property (strong, nonatomic) NSString          *clientID;
@property (strong, nonatomic) NSString          *clientSecret;

@property (strong, nonatomic) GTLServiceYouTube *youtubeService;
@end

@implementation YouTubeUploader

#pragma mark -init

- (instancetype)initYoutubeUploaderWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret {
    self = [super init];
    if (self) {
        self.clientID = clientID;
        self.clientSecret = clientSecret;
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
@end
