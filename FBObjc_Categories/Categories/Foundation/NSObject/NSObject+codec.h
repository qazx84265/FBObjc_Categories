#import <Foundation/Foundation.h>

@interface NSObject (codec)

//- (NSArray *)ignoredNames;
- (void)encode:(NSCoder *)aCoder;
- (void)decode:(NSCoder *)aDecoder;

@end
