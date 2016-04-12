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
#import "UploadController.h"

typedef void (^UploadVideoComplate)(BOOL success, NSString *message);

@interface YouTubeUploader()
@property (strong, nonatomic) NSString                  *clientID;
@property (strong, nonatomic) NSString                  *clientSecret;

@property (strong, nonatomic) GTLServiceYouTube         *youtubeService;

@property (copy, nonatomic) UploadVideoComplate         uploadVideoComplate;
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
                                                              clientID:self.clientID
                                                          clientSecret:self.clientSecret];
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
                   process:(void(^)(float percent)) porcess
                  complate:(void(^)(BOOL success, NSString *message)) complate {
    self.uploadVideoComplate = complate;
    self.youtubeService.uploadProgressBlock = ^(GTLServiceTicket *ticket,
                                                unsigned long long totalBytesUploaded,
                                                unsigned long long totalBytesExpectedToUpload) {
        porcess(totalBytesUploaded*1.0/totalBytesExpectedToUpload);
    };
    [self uploadYouTubeVideoWithService:self.youtubeService
                               fileData:fileData
                                  title:title
                            description:description];
}

#pragma mark - uploadYouTubeVideo

- (void)uploadYouTubeVideoWithService:(GTLServiceYouTube *)service
                             fileData:(NSData*)fileData
                                title:(NSString *)title
                          description:(NSString *)description {
    
    GTLYouTubeVideo *video = [GTLYouTubeVideo object];
    GTLYouTubeVideoSnippet *snippet = [GTLYouTubeVideoSnippet alloc];
    GTLYouTubeVideoStatus *status = [GTLYouTubeVideoStatus alloc];
    status.privacyStatus = @"public";
    snippet.title = title;
    snippet.descriptionProperty = description;
    snippet.tags = [NSArray arrayWithObjects:DEFAULT_KEYWORD, [UploadController generateKeywordFromPlaylistId:UPLOAD_PLAYLIST], nil];
    video.snippet = snippet;
    video.status = status;
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:fileData MIMEType:@"video/*"];
    GTLQueryYouTube *query = [GTLQueryYouTube queryForVideosInsertWithObject:video part:@"snippet,status" uploadParameters:uploadParameters];
    
    [service executeQuery:query
        completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeVideo *insertedVideo, NSError *error) {
            if (error == nil) {
                self.uploadVideoComplate(YES, insertedVideo.identifier);
            }
            else {
//                NSLog(@"An error occurred: %@", error);
                self.uploadVideoComplate(NO, @"An error occurred!");
            }
        }];
}

#pragma mark - private method
// Handle completion of the authorization process, and updates the YouTube service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
//        [Utils showAlert:@"Authentication Error" message:error.localizedDescription];
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
