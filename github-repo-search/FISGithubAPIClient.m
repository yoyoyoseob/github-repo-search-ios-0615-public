//
//  FISGithubAPIClient.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISGithubAPIClient.h"
#import "FISConstants.h"
#import <AFNetworking.h>

@implementation FISGithubAPIClient
NSString *const GITHUB_API_URL=@"https://api.github.com";

+(void)getRepositoriesWithCompletion:(void (^)(NSArray *))completionBlock
{
    NSString *githubURL = [NSString stringWithFormat:@"%@/repositories?client_id=%@&client_secret=%@",GITHUB_API_URL,GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:githubURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        completionBlock(responseObject);
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"I love coffee, is this!! %@", error.localizedDescription);
     }];
}

// https://api.github.com/repos/yoyoyoseob/whack-a-doge

// https://api.github.com/users/yoyoyoseob/starred This will return a list of all repos starred by user

// https://api.github.com/user/starred/yoyoyoseob/whack-a-doge?access_token=d40baea60933b4e7058c6596cb7704a200ca3b95
// EXTRA PARAM IS ACCESS TOKEN

+(void)checkIfStarred:(NSString *)fullName withCompletion:(void (^)(BOOL starred))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/starred/%@", GITHUB_API_URL, fullName];
    NSDictionary *params = @{ @"access_token" : @"0dc45fb9f2484bf24809dab427843bb5a5f15eac" };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        204 --> starred repo (empty body)
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//        if (response.statusCode == 204)
//        {
            completionBlock(YES); // Don't need the response.statusCode because a success CAN ONLY BE 204
//        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        if (response.statusCode == 404)
        {
            completionBlock(NO);
        }
        else
        {
            //completionBlock(NO);
        }
    }];

//    NSURLSession *urlSession = [NSURLSession sharedSession];
//    NSURL *url = [FISGithubAPIClient urlForStarredRepo:fullName];
//    NSURLSessionDataTask *task = [urlSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSHTTPURLResponse *headerResponse = (NSHTTPURLResponse *)response;
//        NSLog(@"Status: %lu", headerResponse.statusCode);
//        if (headerResponse.statusCode == 204)
//        {
//            completionBlock(YES);
//        }
//        else if (headerResponse.statusCode == 404)
//        {
//            completionBlock(NO);
//        }
//    }];
//    [task resume];
}

+(void)starRepo:(NSString *)fullName withCompletion:(void (^)(BOOL starred))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/starred/%@", GITHUB_API_URL, fullName];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc]init];
    [manager.requestSerializer setValue:@"token 0dc45fb9f2484bf24809dab427843bb5a5f15eac" forHTTPHeaderField:@"Authorization"];
    
    [manager PUT:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

            completionBlock(YES);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 404)
        {
            completionBlock(NO);
        }
        else
        {
            
        }
    }];

//    NSURL *url = [FISGithubAPIClient urlForStarredRepo:fullName];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"PUT";
//    NSURLSession *urlSession = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSHTTPURLResponse *headerResponse = (NSHTTPURLResponse *)response;
//        if (headerResponse.statusCode == 204)
//        {
//            completionBlock(YES);
//        }
//        else
//        {
//            completionBlock(NO);
//        }
//    }];
//    [task resume];
}

+(void)unstarRepo:(NSString *)fullName withCompletion:(void (^)(BOOL unstarred))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/starred/%@", GITHUB_API_URL, fullName];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc]init];
    [manager.requestSerializer setValue:@"token 0dc45fb9f2484bf24809dab427843bb5a5f15eac" forHTTPHeaderField:@"Authorization"];
    
    [manager DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionBlock(YES);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 404)
        {
            completionBlock(NO);
        }
        else
        {
            
        }
    }];
    
//    NSURL *url = [FISGithubAPIClient urlForStarredRepo:fullName];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"DELETE";
//    NSURLSession *urlSession = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSHTTPURLResponse *headerResponse = (NSHTTPURLResponse *)response;
//        if (headerResponse.statusCode == 204)
//        {
//            completionBlock(YES);
//        }
//        else
//        {
//            completionBlock(NO);
//        }
//    }];
//    [task resume];
}

//+(NSURL *)urlForStarredRepo:(NSString *)fullName
//{
//    NSString *userStarredRepoURL = [NSString stringWithFormat:@"%@/user/starred/%@?client_id=%@&client_secret=%@&access_tokenoken=%@", GITHUB_API_URL, fullName, GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, GITHUB_ACCESS_TOKEN];
//    
//    return [NSURL URLWithString:userStarredRepoURL];
//}

// https://api.github.com/search/repositories?q=whack-a-doge
+(void)searchForRepo:(NSString *)fullName withCompletion:(void (^)(BOOL, NSArray *results))completionBlock
{
    
    NSDictionary *params = @{ @"access_token" : @"d40baea60933b4e7058c6596cb7704a200ca3b95",
                              @"q" : fullName };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"https://api.github.com/search/repositories" parameters:params success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSDictionary *dictionaryOfSearchResults = responseObject;
        NSLog(@"%@", dictionaryOfSearchResults);
        
        if (dictionaryOfSearchResults)
        {
            completionBlock(YES, dictionaryOfSearchResults[@"items"]);
        }
        else
        {
            completionBlock(NO, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"You got an error: %@", error.localizedDescription);
    }];
    
//    NSString *urlString = [NSString stringWithFormat:@"%@/search/repositories?access_token=%@&q=%@", GITHUB_API_URL, GITHUB_ACCESS_TOKEN, fullName];
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLSession *urlSession = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [urlSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSDictionary *dictionaryOfSearchResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        //NSLog(@"%@", dictionaryOfSearchResults[@"items"]);
//        if (dictionaryOfSearchResults)
//        {
//            completionBlock(YES, dictionaryOfSearchResults[@"items"]);
//        }
//        else
//        {
//            completionBlock(NO, nil);
//        }
//    }];
//    [task resume];
}

+(void)toggleStarForRepo:(NSString *)fullName withCompletion:(void (^)(BOOL starred))completionBlock
{
    // Check starred status
    [FISGithubAPIClient checkIfStarred:fullName withCompletion:^(BOOL isStarred) {
        if (isStarred)
        {
            // Currently starred - unstar it
            [FISGithubAPIClient unstarRepo:fullName withCompletion:^(BOOL unstarred) {
                completionBlock(NO); // This will only get called with UNSTARRING IS COMPLETE which is where we want it
            }];
        }
        else
        {
            // Currently unstarred - star it
            [FISGithubAPIClient starRepo:fullName withCompletion:^(BOOL starred) {
                completionBlock(YES);
            }];
        }
    }];
}



@end
