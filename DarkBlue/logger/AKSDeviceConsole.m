//
// AKSDeviceConsole.m
//
// Copyright (c) 2013 Konstant Info Private Limited
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AKSDeviceConsole.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define AKS_LOG_FILE_PATH [[AKSDeviceConsole documentsDirectory] stringByAppendingPathComponent:@"ns.log"]
#define APPDELEGATE                                     ((AppDelegate *)[[UIApplication sharedApplication] delegate])


@interface AKSDeviceConsole () {
	UITextView *textView;
}
@end

@implementation AKSDeviceConsole

+ (id)sharedInstance {
	static id __sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    __sharedInstance = [[AKSDeviceConsole alloc]init];
	});
	return __sharedInstance;
}

+ (NSMutableString *)documentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}
-(NSString*)getLogPath
{
    return AKS_LOG_FILE_PATH;
}
- (id)init {
	if (self = [super init]) {
		[self initialSetup];
	}
	return self;
}

- (void)initialSetup {
	[self resetLogData];
	[self addGestureRecogniser];
}

+ (void)startService {
	double delayInSeconds = 0.1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
	    [AKSDeviceConsole sharedInstance];
	});
}

- (void)resetLogData {
//	[NSFileManager.defaultManager removeItemAtPath:AKS_LOG_FILE_PATH error:nil];
	freopen([AKS_LOG_FILE_PATH fileSystemRepresentation], "a", stderr);
}
-(void)deleteLog
{
	[NSFileManager.defaultManager removeItemAtPath:AKS_LOG_FILE_PATH error:nil];
	freopen([AKS_LOG_FILE_PATH fileSystemRepresentation], "a", stderr);
}
- (void)addGestureRecogniser {
	UISwipeGestureRecognizer *recogniser = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showConsole)];
	[recogniser setDirection:UISwipeGestureRecognizerDirectionRight];
	[APPDELEGATE.window addGestureRecognizer:recogniser];
}

- (void)showConsole {
	if (textView == nil) {
		CGRect bounds = [[UIScreen mainScreen] bounds];
		CGRect viewRectTextView = CGRectMake(30, bounds.size.height - bounds.size.height / 3 - 60, bounds.size.width - 30, bounds.size.height / 3);

		textView = [[UITextView alloc]initWithFrame:viewRectTextView];
		[textView setBackgroundColor:[UIColor blackColor]];
		[textView setFont:[UIFont systemFontOfSize:10]];
		[textView setEditable:NO];
		[textView setTextColor:[UIColor whiteColor]];
		[[textView layer]setOpacity:0.6];

		[APPDELEGATE.window addSubview:textView];
		[APPDELEGATE.window bringSubviewToFront:textView];

		UISwipeGestureRecognizer *recogniser = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideWithAnimation)];
		[recogniser setDirection:UISwipeGestureRecognizerDirectionLeft];
		[textView addGestureRecognizer:recogniser];

		[self moveThisViewTowardsLeftToRight:textView duration:0.30];
		[self setUpToGetLogData];
		[self scrollToLast];
	}
}
- (void)hideWithAnimation {
	[self moveThisViewTowardsLeft:textView duration:0.30];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
	    [self hideConsole];
	});
}
- (void)hideConsole {
	[textView removeFromSuperview];
	[NSNotificationCenter.defaultCenter removeObserver:self];
	textView  = nil;
}
- (void)scrollToLast {
	NSRange txtOutputRange;
	txtOutputRange.location = textView.text.length;
	txtOutputRange.length = 0;
	textView.editable = YES;
	[textView scrollRangeToVisible:txtOutputRange];
	[textView setSelectedRange:txtOutputRange];
	textView.editable = NO;
}
- (void)setUpToGetLogData { 
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:AKS_LOG_FILE_PATH];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getData:) name:@"NSFileHandleReadCompletionNotification" object:fileHandle];
	[fileHandle readInBackgroundAndNotify];
}
- (void)getData:(NSNotification *)notification {
	NSData *data = notification.userInfo[NSFileHandleNotificationDataItem];
	if (data.length) {
		NSString *string = [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding];
		textView.editable = YES;
		textView.text = [textView.text stringByAppendingString:string];
		textView.editable = NO;
		double delayInSeconds = 1.0;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
		    [self scrollToLast];
		});
		[notification.object readInBackgroundAndNotify];
	}
	else {
		[self performSelector:@selector(refreshLog:) withObject:notification afterDelay:1.0];
	}
}
- (void)refreshLog:(NSNotification *)notification {
	[notification.object readInBackgroundAndNotify];
}
- (void)moveThisViewTowardsLeft:(UIView *)view duration:(float)dur; {
	[UIView animateWithDuration:dur animations: ^{
	    [view setFrame:CGRectMake(view.frame.origin.x - [[UIScreen mainScreen]bounds].size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
	} completion: ^(BOOL finished) {}];
}
- (void)moveThisViewTowardsLeftToRight:(UIView *)view duration:(float)dur; {
	CGRect original = [view frame];
	[view setFrame:CGRectMake(view.frame.origin.x - [[UIScreen mainScreen]bounds].size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
	[UIView animateWithDuration:dur animations: ^{
	    [view setFrame:original];
	} completion: ^(BOOL finished) {}];
}

@end
