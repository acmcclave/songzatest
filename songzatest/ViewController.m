//
//  ViewController.m
//  songzatest
//
//  Created by Danny on 4/1/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property(strong, nonatomic)ACAccountStore *accountStore;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *email;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self facebookLoginWithCompletion:^(NSString *userID, NSString *email, NSString *fullName) {
        NSLog(@"%@",userID);
        // set user name and email
        dispatch_async(dispatch_get_main_queue(), ^{
            self.usernameLabel.text = fullName;
            self.email.text = email;
        });
        
        // set user profile image
        [self getFacebookProfileWithCompletion:^(NSData *profileImageData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.profileImage.image = [UIImage imageWithData:profileImageData];
            });
        }];
    }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//FB
- (void)facebookLoginWithCompletion:(void (^)(NSString *userID, NSString *email, NSString *fullName))completion
{
    self.accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{
                              ACFacebookAppIdKey:@"1470242956526706",
                              ACFacebookPermissionsKey: @[@"read_stream", @"basic_info"],
                              
                              ACFacebookAudienceKey:ACFacebookAudienceFriends
                              };
    
    [self.accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
        if (granted)
        {
            NSLog(@"Permission Granted");
            NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
            
            ACAccount *account = (ACAccount *)[accounts lastObject];
            
            NSString *userID = [[[account valueForKey:@"properties"] valueForKey:@"uid"] stringValue];
            NSString *email = [[account valueForKey:@"properties"] valueForKey:@"ACUIDisplayUsername"];
            NSString *fullName = [[account valueForKey:@"properties"] valueForKey:@"ACPropertyFullName"];
            
            completion(userID, email, fullName);
            
        }
        else
        {
            NSLog(@"Permission denied");
            NSLog(@"%@", error);
        }
    }];
}


////
- (void)getFacebookProfileWithCompletion:(void(^)(NSData *profileImageData))completion
{
    NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/picture"];
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
    
    NSDictionary *params = @{@"redirect":@0,
                             @"height": @200,
                             @"type": @"large",
                             @"width":@200,
                             };
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:feedURL parameters:params];
    [request setAccount:[accounts lastObject]];
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSData *profileImageData = responseData;
        completion(profileImageData);
    }];
}


@end
