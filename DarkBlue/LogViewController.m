//
//  LogViewController.m
//  DarkBlue
//
//  Created by chenee on 14-3-26.
//  Copyright (c) 2014年 chenee. All rights reserved.
//

#import "LogViewController.h"
#import "AKSDeviceConsole.h"
#import "ProgressHUD.h"

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

#define MAIL_ADDRESS_USER_STRING @"MailAddress"
#define MAIL_CC_ADDRESS_STRING @"chenee543216@gmail.com"

@interface LogViewController ()<MFMailComposeViewControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtMail;

@end

@implementation LogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *s = [[NSUserDefaults standardUserDefaults]objectForKey:MAIL_ADDRESS_USER_STRING];
    if (s) {
        self.txtMail.text = s;
    }else{
        self.txtMail.text = MAIL_CC_ADDRESS_STRING;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setDefaultLog:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:@"autoLogger"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    BOOL b = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogger"];
    NSLog(@"current log state:%d",b);
}
- (IBAction)startLog:(id)sender {
    [AKSDeviceConsole startService];

    [self setDefaultLog:TRUE];
    
    [ProgressHUD showSuccess:@"start Log ok"];
}
- (IBAction)deleteLog:(id)sender {
    [[AKSDeviceConsole sharedInstance] deleteLog];
    
    [ProgressHUD showSuccess:@"delete Log ok"];
}

- (IBAction)stopLog:(id)sender {
    [self setDefaultLog:FALSE];
    
    [ProgressHUD showSuccess:@"stop Log ok"];
}
- (IBAction)sendMail:(id)sender {
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    if(mailCompose){
        [mailCompose setMailComposeDelegate:self];
        
        NSString *sAddress = self.txtMail.text;
        NSArray *toAddress = [NSArray arrayWithObject:sAddress];
        
        [[NSUserDefaults standardUserDefaults] setObject:sAddress forKey:MAIL_ADDRESS_USER_STRING];
        
        NSArray *ccAddress = [NSArray arrayWithObject:MAIL_CC_ADDRESS_STRING];;
        
        [mailCompose setToRecipients:toAddress];
        [mailCompose setCcRecipients:ccAddress];
        
        NSString *emailBody = @"<H1>attachment is the log info</H1>";
        [mailCompose setMessageBody:emailBody isHTML:YES];
        
        
        [mailCompose setSubject:[NSString stringWithFormat:@"BT Log (%@)",[NSDate date]]];
        
        
        NSData* pData = [[NSData alloc]initWithContentsOfFile:[[AKSDeviceConsole sharedInstance]getLogPath]];
        [mailCompose addAttachmentData:pData mimeType:@"txt" fileName:@"log.txt"];

        [self presentViewController:mailCompose animated:YES completion:nil];
    }
    
    [self KeyboardDisappear:FALSE];

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            break;
        default:
            break;
    }
    [ProgressHUD showSuccess:msg];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)KeyboardDisappear:(BOOL)isUP
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect;
    if(isUP){
        rect = CGRectMake(0.0f, -116,width,height);
    }else{
        rect = CGRectMake(0.0f, 0,width,height);
        
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}
- (IBAction)beginEdit:(id)sender {
    [self KeyboardDisappear:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [self KeyboardDisappear:FALSE];
    return YES;
}
- (IBAction)taped:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self KeyboardDisappear:FALSE];
}
@end
