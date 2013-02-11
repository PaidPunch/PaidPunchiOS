//
//  UrlImage.m
//  traderpog
//
//  Created by Shu Chiun Cheah on 9/6/12.
//  Copyright (c) 2012 GeoloPigs. All rights reserved.
//

#import "UrlImage.h"

@implementation UrlImage
@synthesize image = _image;

- (id) initWithUrl:(NSString*)urlString forImageView:(UIImageView*)imageView;
{
    self = [super init];
    if(self)
    {
        _imageviewArray = [[NSMutableArray alloc] init];
        [_imageviewArray addObject:imageView];
        _dataBuffer = [[NSMutableData alloc] init];
        _image = nil;
        
        NSURL* url = [NSURL URLWithString:urlString];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    return self;
}

- (void) addImageView:(UIImageView*)imageView
{
    [_imageviewArray addObject:imageView];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_dataBuffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _image = [UIImage imageWithData:_dataBuffer];
    if (_imageviewArray)
    {
        for (UIImageView* imageView in _imageviewArray)
        {
            [imageView setImage:_image];
        }
    }
    // We've set the imageview. Clear the imageView array so we don't leave
    // the imageViews hanging around in memory.
    _imageviewArray = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"download of url picture failed");
}


@end
