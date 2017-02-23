//
//  DataManager.h
//  Second_Task
//
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject <NSURLConnectionDelegate>

+(DataManager *)sharedInstance;

-(void)loadData:(NSURL *)url withCompletion:(void (^)(NSArray *itemListArray, NSError *error))completionBlock;

@end
