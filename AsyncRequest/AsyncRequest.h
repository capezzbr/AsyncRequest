//
//  AsynchronousRequest.h
//  CallCenterMobile
//
//  Created by Bruno Capezzali on 06/05/13.
//
//

#import <Foundation/Foundation.h>

extern NSString *urlEncode(id object);
    
@interface AsyncRequest : NSObject {
    NSString *_requestURL;
    NSURLConnection *_request;
    NSTimeInterval _timeoutInterval;
    BOOL _completed;
    
    NSMutableData *_receivedData;
    
    void (^_successBlock)(NSData *data);
    void (^_errorBlock)(NSError *error);
}

@property (nonatomic, readwrite) NSTimeInterval timeoutInterval;
@property (nonatomic, readonly) BOOL completed;

+(NSString *)encodedURL:(NSString *)page withParams:(NSDictionary *)params;

-(id)initRequestWithURL:(NSString *)page params:(NSDictionary *)params
              onSuccess:(void (^)(NSData *data))success onErrror:(void (^)(NSError *error))error;

+(id)requestWithURL:(NSString *)page params:(NSDictionary *)params
          onSuccess:(void (^)(NSData *data))success onErrror:(void (^)(NSError *error))error;

-(void)start;
-(void)cancel;

@end