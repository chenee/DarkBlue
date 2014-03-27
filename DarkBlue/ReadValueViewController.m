//
//  ReadValueViewController.m
//  DarkBlue
//
//  Created by chenee on 14-3-27.
//  Copyright (c) 2014年 chenee. All rights reserved.
//

#import "ReadValueViewController.h"
#import "BTServer.h"
#import "ProgressHUD.h"
#import "NSData+HexDump.h"

@interface ReadValueViewController ()<BTServerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbPeripheral;
@property (weak, nonatomic) IBOutlet UILabel *lbService;
@property (weak, nonatomic) IBOutlet UILabel *lbCharacteristic;
@property (weak, nonatomic) IBOutlet UILabel *lbDataType;
@property (weak, nonatomic) IBOutlet UILabel *lbASCII;
@property (weak, nonatomic) IBOutlet UILabel *lbHex;
@property (weak, nonatomic) IBOutlet UILabel *lbDecimal;

@property (strong,nonatomic) BTServer *defaultBTServer;

@end

@implementation ReadValueViewController{
    BOOL readState;
}

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
    self.defaultBTServer = [BTServer defaultBTServer];
    self.defaultBTServer.delegate = (id)self;
    self.lbPeripheral.text = self.defaultBTServer.selectPeripheral.name;
    self.lbService.text = [self.defaultBTServer.discoveredSevice.UUID UUIDString];
    self.lbCharacteristic.text = [self.defaultBTServer.selectCharacteristic.UUID UUIDString];
    self.lbDataType.text = @"XXXXXX";
    
    readState = false;
    [self readAction];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didDisconnect
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showSuccess:@"disconnect from peripheral"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}
-(void)didReadvalue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        readState = false;
        NSData *d = self.defaultBTServer.selectCharacteristic.value;
//        NSString *s = [NSString stringWithUTF8String:[d bytes]];
        NSString *s = [d hexval];
        
        NSLog(@"read (%@):\n%@",d,s);

        self.lbHex.text = s;
    });
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
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)readAction
{
    if (readState == true) {
        NSLog(@"read busy ...");
        return;
    }
    readState = true;
    [self.defaultBTServer readValue:nil];
}
- (IBAction)readData:(id)sender {
    [self readAction];
}
- (IBAction)notify:(id)sender {
}

@end
