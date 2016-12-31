/****************************************************************************
 * Copyright 2016, Optimizely, Inc. and contributors                        *
 *                                                                          *
 * Licensed under the Apache License, Version 2.0 (the "License");          *
 * you may not use this file except in compliance with the License.         *
 * You may obtain a copy of the License at                                  *
 *                                                                          *
 *    http://www.apache.org/licenses/LICENSE-2.0                            *
 *                                                                          *
 * Unless required by applicable law or agreed to in writing, software      *
 * distributed under the License is distributed on an "AS IS" BASIS,        *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. *
 * See the License for the specific language governing permissions and      *
 * limitations under the License.                                           *
 ***************************************************************************/

#import "OPTLYNetworkService.h"
#import "OPTLYProjectConfig.h"

// ---- Datafile Download URLs ----
NSString * const OPTLYNetworkServiceCDNServerURL    = @"https://cdn.optimizely.com/public/";
NSString * const OPTLYNetworkServiceS3ServerURL     = @"https://optimizely.s3.amazonaws.com/";

@implementation OPTLYNetworkService

- (void)downloadProjectConfig:(nonnull NSString *)projectId
                 lastModified:(nonnull NSString *)lastModifiedDate
            completionHandler:(nullable OPTLYHTTPRequestManagerResponse)completion
{
    NSURL *cdnConfigFilePathURL = [OPTLYNetworkService projectConfigURLPath:projectId];
    OPTLYHTTPRequestManager *requestManager = [[OPTLYHTTPRequestManager alloc] initWithURL:cdnConfigFilePathURL];
    [requestManager GETIfModifiedSince:lastModifiedDate backoffRetry:YES completionHandler:completion];
}

- (void)downloadProjectConfig:(NSString *)projectId completionHandler:(OPTLYHTTPRequestManagerResponse)completion
{
    NSURL *cdnConfigFilePathURL = [OPTLYNetworkService projectConfigURLPath:projectId];
    OPTLYHTTPRequestManager *requestManager = [[OPTLYHTTPRequestManager alloc] initWithURL:cdnConfigFilePathURL];
    [requestManager GETWithBackoffRetry:YES completionHandler:completion];
}

- (void)dispatchEvent:(nonnull NSDictionary *)params
                toURL:(nonnull NSURL *)url
    completionHandler:(nullable OPTLYHTTPRequestManagerResponse)completion
{
    OPTLYHTTPRequestManager *requestManager = [[OPTLYHTTPRequestManager alloc] initWithURL:url];
    [requestManager POSTWithParameters:params backoffRetry:YES completionHandler:completion];
}

# pragma mark - Helper Methods

+ (NSURL *)projectConfigURLPath:(NSString *)projectId
{
    NSURL *cdnURL = [NSURL URLWithString:OPTLYNetworkServiceCDNServerURL];
    NSString *filePath = [NSString stringWithFormat:@"%@%@/datafile_v%@.json", cdnURL.absoluteString, projectId, kExpectedDatafileVersion];
    return [NSURL URLWithString:filePath];
}


@end
