#import <Foundation/Foundation.h>
#import "Episode.h"

#define BASE_URL @"http://itrakt.matsimitsu.com"
#define TRAKT_BASE_URL @"http://api.trakt.tv"

@interface Trakt : NSObject {
  NSString *baseURL;
  NSString *traktBaseURL;
  NSString *apiKey;
  NSString *apiUser;
  NSString *apiPasswordHash;
  NSArray *broadcastDates;
  NSArray *library;
  NSArray *recommendations;
}

@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSString *traktBaseURL;

@property (nonatomic, retain) NSString *apiUser;
@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, readonly) NSString *apiPasswordHash;

@property (nonatomic, retain) NSArray *broadcastDates;
@property (nonatomic, retain) NSArray *library;
@property (nonatomic, retain) NSArray *recommendations;

+ (Trakt *)sharedInstance;

- (void)setApiPassword:(NSString *)password;

- (void)retrieveRootControllerDataStartingWith:(NSString *)dataDownloadSelector block:(void (^)(NSArray *data))block;

- (NSURL *)verifyCredentialsURL;
- (void)verifyCredentials:(void (^)(BOOL valid))block;

- (NSURL *)calendarURL;
- (void)calendar:(void (^)(NSArray *broadcastDates))block;

- (NSURL *)libraryURL;
- (void)library:(void (^)(NSArray *shows))block;

- (NSURL *)recommendationsURL;
- (void)recommendations:(void (^)(NSArray *shows))block;

- (NSURL *)seasonsURL:(NSString *)tvdb_id;
- (void)seasons:(Show *)show block:(void (^)(NSArray *seasons))block;

- (NSURL *)episodeSeenURL;
- (NSURL *)episodeNotSeenURL;
- (void)toggleSeenForEpisode:(Episode *)episode block:(void (^)())block;

- (UIImage *)cachedShowPosterForURL:(NSURL *)posterURL;
- (void)showPosterForURL:(NSURL *)posterURL block:(void (^)(UIImage *poster, BOOL cached))block;

- (void)showThumbForURL:(NSURL *)thumbURL block:(void (^)(UIImage *thumb, BOOL cached))block;

- (NSURL *)URLForImageURL:(NSURL *)URL scaledTo:(CGSize)scaledTo;

- (UIImage *)cachedImageForURL:(NSURL *)URL;
- (UIImage *)cachedImageForURL:(NSURL *)URL scaledTo:(CGSize)scaledTo;

- (void)removeCachedImageForURL:(NSURL *)URL;
- (void)removeCachedImageForURL:(NSURL *)URL scaledTo:(CGSize)scaledTo;

- (void)loadImageFromURL:(NSURL *)URL block:(void (^)(UIImage *image, BOOL cached))block;
- (void)loadImageFromURL:(NSURL *)URL scaledTo:(CGSize)scaledTo block:(void (^)(UIImage *image, BOOL cached))block;

@end
