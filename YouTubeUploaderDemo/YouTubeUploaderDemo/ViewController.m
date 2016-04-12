//
//  ViewController.m
//  YouTubeUploaderDemo
//
//  Created by tbago on 16/4/12.
//  Copyright © 2016年 tbago. All rights reserved.
//

#import "ViewController.h"
#import <YouTubeUploaderFramework/YouTubeUploader.h>

static NSString *const kClientID        = @"304715988357-8vuq0b89imqh0474ri4ceigpn7m145h6.apps.googleusercontent.com";
static NSString *const kClientSecret    = @"rCcqhEdkZsOkQ4bEEqfM6i47";

@interface ViewController ()

@property (strong ,nonatomic) YouTubeUploader *youtubeUploader;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self.youtubeUploader isAuthorized]) {
        UIViewController *authViewController = [self.youtubeUploader createAuthViewController];
        [self.navigationController pushViewController:authViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - get & set

- (YouTubeUploader *)youtubeUploader {
    if (_youtubeUploader == nil) {
        _youtubeUploader = [[YouTubeUploader alloc] initYoutubeUploaderWithClientID:kClientID
                                                                      clientSecret:kClientSecret];
    }
    return _youtubeUploader;
}

@end
