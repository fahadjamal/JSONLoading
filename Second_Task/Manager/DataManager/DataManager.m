//
//  DataManager.m
//  Second_Task
//
//

#import "DataManager.h"

@implementation DataManager

+(DataManager *)sharedInstance {
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

#pragma mark NSURLConnection Delegate Methods

-(void)loadData:(NSURL *)url withCompletion:(void (^)(NSArray *itemListArray, NSError *error))completionBlock {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *data = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *erro = nil;
        if (data != nil) {
            NSArray *jsonResponseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&erro];
            NSLog(@"jsonResponse is %@", jsonResponseArray);
            
            NSArray *itemListArray = [NSArray arrayWithArray:jsonResponseArray];
            completionBlock(itemListArray , nil);
        }
        else {
            completionBlock(nil , error);
        }
    }];
    [data resume];
}

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    // A response has been received, this is where we initialize the instance var you created
//    // so that we can append data to it in the didReceiveData method
//    // Furthermore, this method is called each time there is a redirect so reinitializing it
//    // also serves to clear it
//    _responseData = [[NSMutableData alloc] init];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    // Append the new data to the instance variable you declared
//    [_responseData appendData:data];
//}
//
//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
//                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
//    // Return nil to indicate not necessary to store a cached response for this connection
//    return nil;
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    // The request is complete and data has been received
//    // You can parse the stuff in your instance variable now
//    
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    // The request has failed for some reason!
//    // Check the error var
//}

@end
