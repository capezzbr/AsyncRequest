//
//  AsynchronousRequest.h
//
//  Created by Bruno Capezzali on 06/05/13.
//

#import <Foundation/Foundation.h>

extern NSString *urlEncode(id object);
    
@interface AsyncRequest : NSObject {
    NSString *_requestURL;
    NSURLConnection *_request;
    NSMutableData *_receivedData;
    
    // callbacks
    void (^_successBlock)(NSData *data);
    void (^_errorBlock)(NSError *error);
}

@property (nonatomic, readwrite) NSTimeInterval timeoutInterval;
@property (nonatomic, readonly) BOOL completed;

// Useful method for creating an encoding URL with GET parameters
+ (NSString *)encodedURL:(NSString *)page withParams:(NSDictionary *)params;

+ (id)requestWithURL:(NSString *)page
              params:(NSDictionary *)params
           onSuccess:(void (^)(NSData *data))success
            onErrror:(void (^)(NSError *error))error;

- (id)initRequestWithURL:(NSString *)page
                  params:(NSDictionary *)params
              onSuccess:(void (^)(NSData *data))success
                onErrror:(void (^)(NSError *error))error;

// Start & stop the request
- (void)start;
- (void)cancel;

@end