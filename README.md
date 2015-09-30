仿照LightBlue的central模式实现全部功能，升级logger机制，可以在线查看BT log状态(直接使用NSLog())。
并且可以随时mail当前log给需要的人。希望这个框架可以方便您的蓝牙的开发和调试。

LightBlue(https://itunes.apple.com/cn/app/lightblue-bluetooth-low-energy/id557428110?mt=8
) like Bluetooth LE demo ,with full function of central mode.

improve the debug logger ,you can lookup the log at run time without connect to Xcode
you even could send the logger direct to other developer with email(e.g tester send log to developer),
by your iphone.it's pretty cool.  wish it could help you for your BT LE development.

BTW:
logger howto ,please refer to :http://code4app.com/ios/524b9f5b6803faf178000000
or refer the "F**King Source Code :)"

the last and most important thing is : I'm still working on it ,so feel free to touch me
chenee543216@gmail.com



----- 2015.9.30
sorry,I'm so busy for now days... have no time to release the new version Bluetooth framework. this doc below FYI.

//
//  NewBlueDoc.m
//  MiBand
//
//  Created by 陈宜义 on 15/1/16.
//  Copyright (c) 2015年 chenee. All rights reserved.
//

#import "NewBlueDoc.h"

#include "helper.h"

@interface NewBlueDoc()
@property(nonatomic) NSString *占位符;
@end

@implementation NewBlueDoc
@synthesize 占位符=_;

/* 这是一个爆逗逼的文档，从写法上就TMD(这里是文明用语)能够看出来了。 @_@ */
/*  理论上这里应该放一个看上去很高大上的ASCII 涂鸦，懒得搞，请自行脑补一个 */
/*  New Blue
 _______                __________.__
 \      \   ______  _  _\______   \  |  __ __   ____
 /   |   \_/ __ \ \/ \/ /|    |  _/  | |  |  \_/ __ \
 /    |    \  ___/\     / |    |   \  |_|  |  /\  ___/
 \____|__  /\___  >\/\_/  |______  /____/____/  \___  >
 \/     \/               \/                 \/
 
 
 _   _               ____  _
 | \ | |             |  _ \| |
 |  \| | _____      _| |_) | |_   _  ___
 | . ` |/ _ \ \ /\ / /  _ <| | | | |/ _ \
 | |\  |  __/\ V  V /| |_) | | |_| |  __/
 |_| \_|\___| \_/\_/ |____/|_|\__,_|\___|


 
 */

/* 妈蛋，Xcode弱爆了，写个文档，死了100多次。。。。 */
+(void)打印NB涂鸦
{
    NSString *涂鸦=@"\n\
\t\t  _   _               ____  _ \n \
\t\t | \\ | |             |  _ \\| | \n\
\t\t |  \\| | _____      _| |_) | |_   _  ___ \n\
\t\t | . ` |/ _ \\ \\ /\\ / /  _ <| | | | |/ _ \\ \n\
\t\t | |\\  |  __/\\ V  V /| |_) | | |_| |  __/ \n\
\t\t |_| \\_|\\___| \\_/\\_/ |____/|_|\\__,_|\\___| \n";

    NSLog(@"%@",涂鸦);

}
-(void)NewBlue说明
{
_= @"\
\
    NB系统包括:\
    NewBlue.h  --   导出头文件\
    NewBlueDoc --   就是你看到的这个文档\
    NBTemp ---      临时变量，先放着，后面优化掉\
    NBLogSystem --- 准备实现但是没有实现，但是实现完成以后会很NB的日志系统\
    NBStatus ---    目前放enum类型的 \
    NBHospital --   NewBlue的总控Handler，包含各个OperatingRoom\
    NBWaitingRoom -- 等候室。启动并等待各个Task结束。包含阻塞和回调2种方式。\
    NBBandOper --   task的逻辑组合。\
    OperatingRoom: -- 各种蓝牙具体实现 + 蓝牙操作结果，去Task的sendData里面相关数据进行蓝牙操作，\
                    并将结果回写到task的receiveData结构里面。\
        NBORCenter -- 手机端的OperatingRoom实现\
        NBORBand --- 手环的OperatingRoom相关实现\
        NBORScale --- 秤的OperatingRoom实现,NBORBand 和NBORScale还可以简化合并，后面再说  \
    ProfileCenter -- 蓝牙Profile的具体实现：那个task，使用那个characteristic，\
                    填充什么类型、多少位的数据。基本就是相关Profile和约定的代码翻译。\
                    ProfileCenter是Task被 注册到OperatingRoom时候自动调用的。\
                    如果有其他类型硬件需要适配，就再增加相关Profile\
        NBProfileCenter -- 手机系统Profile\
        NBBProfileCenter -- 手环\
        NBSProfileCenter -- 秤\
    NBTask -- 任务描述类，这个类只负责描述任务，包括定义任务类型（读写操作、等待操作、观测操作。。。）\
                ，传递任务数据（开关数据、数值、），承载返回数据;\
        Params -- task的相关数据结构；\
        NBManifest -- task的类型描述结构、设备类型、任务类型、操作类型。。。\
        NBOrderList -- 任务串联结构：下一个要执行的任务，本次是否清空标志，为下一次等待做准备，是否忽略本次错误直接执行\
                  每个相关蓝牙操作，都是可以看出一系列Task。用这个结构可以把一系列task串联起来。\
        NBReceiveData --  保存任务结果的结构，包括本次总的结果status，读写notify等子步骤的wstatus\rstatus\nstatus\
                        目前包括3个signal，resultSignal，watchSignal,progressSignal;分别用来对外\
                        （任意订阅这些signal的地方）发布消息。对应结果消息、观测消息、进度消息。\
                        结果目前保存有对应的array和data个类型。array用于scan后的外设列表，data为read和notify回来的值\
        NBSendData  -- 发送数据结构：包括发送到那个Peripheral 的那个 service对应那个characteristic; 传递那些数据给\
                    对应的OperatingRoom操作，基本包括了各种primary类型。\
\
\
    NBTask，的初始化请使用 getTaskbyActionType: 会自动填充一次数据（lastTime,deviceType,actionType), 剩下的数据会在注册到OperatingRoom的时候由 ProfileCenter 再填充一次。\
    所以！！！ 之间的设置会被ProfileCenter覆盖。 \
    并且！！ 任何操作ProfileCenter都必须明确返回true才代表这个task准备完成，可以送给OperatingRoom处理了。\
\
\
\
    Task 的actionType定义在对应的OperatingRoom头文件中，有几个类型：\
    write.xxx -- 表示写蓝牙操作\
    read.xxx -- 表示读蓝牙操作\
    notify.xxx -- 表示设置notify操作\
    watch.xxxx -- 表示设置watcher，观测点，这个task如果成功会监视notify变化并且通过本task.receiveData.watchSignal发送回来\
    wait.xxxxx -- 等待操作，等待包括等待用于手环的某个消息号到达，比如电量notify，绑定认证notify，这类notify都是Array形，来一个notify\
                就放到Array中，不会丢，所有来的都保存，直到下一次明确clean。也可以等待Data形态的notify，这类notify是一个Data型的，\
                来一个就把前一个冲掉。用于秤里面syncData，upgrade firmware的时候，和秤的交互动作。\
\
    ";

    NSLog(@"%@",_);
}
-(void)举一个Task的栗子{

 _= @"执行一个task";

    NBBandTask * task = [NBBandTask getTaskbyActionType:BDISCOVERSERVICE];

    /*_=@"beWait 会自动初始化一个waittingRoom，来阻塞等待该task完成";*/
    if([task beWait]){
        NSLog(@"task 执行完成，并且成功");
    } else{
        NSLog(@"task 执行完成，并且成功");
    }

    /*_=@"上面的写法等于";*/
    NBWaitingRoom * wr = [[NBWaitingRoom alloc]init];
    if([wr waitTask:task]){ }else{ }


    _=@"虽然上面的2种都是对的，但是waitingRoom的阻塞模式要求在非 MainThread 里面运行所以，\
    必须开个队列出来；waitingRoom可以自动分配队列，只需传递Room的name即可。如下";

    dispatch_async([NBWaitingRoom getWaitingQueue:@"band"], ^{
        if([task beWait]){ }else{};
    });


    _=@"如果需要我们也可以使用回调方式来使用WaitingRoom,这个回调方式可以在任意队列，包括MainThread：如下";

    [wr notifyTask:task withResult:^(bool status, NSError *error, id x) {
        if(status){}else{}
    }];

}

-(void)一个叫做骚庙scan的栗子{
_=@"扫描；扫描Task要填充bool和string值，分别表示：1）是否扫描到就short出来，2）扫描什么类型设备";
    NBCentralTask *scan = [NBCentralTask getTaskbyActionType:CSCAN];
    [[scan setSDBoolValue:true]setSDStringValue:@"all"];
    [[scan setSDBoolValue:true]setSDStringValue:@"band"];
    [[scan setSDBoolValue:true]setSDStringValue:@"scale"];

_=@"扫描中所有发现的peripheral会通过watchSignal发送出来，如果需要可以订阅这个signal";
    __weak __typeof(self) weakSelf = self;
    [scan.receivedata.watchSignal subscribeNext:^(id x) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"%@",x);
        });

    }];



    /* use waiting room callback*/
    NBWaitingRoom *w = [[NBWaitingRoom alloc]init];
    [w notifyTask:scan withResult:^(bool status, NSError *error, id x) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"scan over: this is peripheral array:%@",x);
        });
    }];

    /* OR */

    [scan beNotify:^(bool status, NSError *error, id x) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"scan over: this is peripheral array:%@",x);
        });
    }];
}
-(BOOL)连接和服务发现·当然还有characteristic的发现//····这还用单独说?
{
_=@"connect,discover service/characteristic";

    PeripheralInfo *pi;_=@"这里的pi是前面扫描到的Array中的某个PeripheralInfo结构，需要提前赋值好！！";

    /* connect */
    NBCentralTask *连接 = [[NBCentralTask getTaskbyActionType:CCONNECT]setSDPeripheralInfo:pi];

    /* 标记到Hospital里面 */
    [NBHospital defaultInstance].orBand.pinfo = pi;

    /* 发现service */
    NBBandTask*服务发现 = [连接 addNext:[NBBandTask getTaskbyActionType:BDISCOVERSERVICE]];

    /* 发现 characteristic */
    NBBandTask* 特征发现 = [服务发现 addNext:[NBBandTask getTaskbyActionType:BDISCOVERCHARACTERISTIC]];

    /* 设置notify*/_=@"boolValue 表示开关，默认是array模式的notify，手环都是这种，比如返回8代表某个功能success，返回7代表该功能fail\
    系统所有的该characteristic的notify都会依次add到该characteristic对应的notify array里面去。";
    NBBandTask* 设置notify = [特征发现 addNext:[[NBBandTask getTaskbyActionType:BENABLENOTIFY]setSDBoolValue:true]];

    /* 读取 device info*/
    NBBandTask* 读取DeviceInfo = [设置notify addNext:[NBBandTask getTaskbyActionType:BREADDEVICEINFO]];


    if ([连接 beWait]) {
        _=@"如果连接成功，纪录读取的设备信息，包括版本号等都在这个devInfo结构里面";
        DeviceInfo *dinfo = [[DeviceInfo alloc]init];
        [dinfo setTheDeviceInfo:读取DeviceInfo.receivedata.data];
        [NBHospital defaultInstance].devInfo = dinfo;
        return true;

    }else{
        NSLog(@" order list error: from service to devInfo");
        return false;
    }
}
-(BOOL)比较手环固件版本·因为老版本固件敲击会重启·我擦// ...... 再擦一下
{
    /* compare fw version judge whether need to set params */
    NSInteger ios_fw_v = 1677993;
    BOOL setFlag = false;

    _=@"拿上面保存的设备信息来用";
    DeviceInfo *devInfo = [NBHospital defaultInstance].devInfo;
    if (devInfo == nil) {
        return false;
    }

    if(devInfo.firmwareVersion > ios_fw_v) {
        setFlag  = true;

        _=@"读手环param设置";
        NBBandTask* rparam= [NBBandTask getTaskbyActionType:BREADPARAMETER];

        _=@"串联，set Param和wait设置";
        [[[[rparam
            addNext:[NBBandTask getTaskbyActionType:BWRITEPARAMETER]]setClean]
          addNext:[NBBandTask getTaskbyActionType:BWAITNOTIFY]]setNotifyType:BNT_PARAM];

        if (! [rparam beWait]) {
            setFlag = false;
        }
    }

    return setFlag;
}
-(BOOL)这个荔枝老牛逼了·完整的手环连接过程说明·累死哥{
    BOOL ret;
    //1
    ret = [self 连接和服务发现·当然还有characteristic的发现];
    if (! ret) {
        NSLog(@"do common Band cmd error!");
        return false;
    }

    //2
    /* compare fw version judge whether need to set params */
    BOOL 不用等待手环重启 = [self 比较手环固件版本·因为老版本固件敲击会重启·我擦];

    //3
    NBBandTask*写用户信息·并清空notifyArray = [[NBBandTask getTaskbyActionType:BUSERINFO] setClean];
    if(! [写用户信息·并清空notifyArray beWait]){
        NSLog(@"set user info fail!");
        return false;
    }

    //4
    _=@"等待Task，等待类型这里填充的是BNT_AUTH,ProfileCenter会根据这个类型，来自动填充等待成功和失败的信息号。";
    NBBandTask*等待Auth的Notify = [[NBBandTask getTaskbyActionType:BWAITNOTIFY] setNotifyType:BNT_AUTH];
    if ([等待Auth的Notify beWait]) {
        _=@"这里，说明UID是一致的，保存一些信息，完成";
        return true;
    }

    _=@"走到的这里，说明UID是不一样的，要等待用户敲击";
    //5
    /*  uid not same! waiting user knock */

    if (不用等待手环重启) {

        /* we set param/Latency ok. so, we could count on the 'waitNotify' */
        NBBandTask*等用户敲击 = [[[NBBandTask getTaskbyActionType:BWAITNOTIFY] setNotifyType:BNT_PAIR]setWaitTime:30];
        if ([等用户敲击 beWait]) {
            _=@"判断用户敲击了，保存一些信息，完成";
            return true;
        }else{
            NSLog(@"user not knock error!!");
            return false;
        }
    } else{

        /* if not set the param, we wait re-connect */
        _=@"如果人品不好，走到这里，说明手环版本比较低，设置Param会失败。导致的结果就是，不论用户敲击不敲击，都TMD会断开。\
        我们判断的方式，就是坐等手环断开连接，然后再次连接手环，判断UID是否一致，如果一致说明前面用户敲击了，是因为固件版本低了，\
        所以重启。否则就是用户没有敲击。是不是有些操蛋？";
        return [self 等待手环重启判断UID];
        
    }

}
-(BOOL)等待手环重启判断UID{

    int totoalTimes = 1;
    int retryTimes = totoalTimes;
    BOOL ret = false;

    while (retryTimes > 0) {
        retryTimes -= 1;
        ret = [self 连接和服务发现·当然还有characteristic的发现];

        if (ret) {
            /* we only judge notifyAuth ok,otherwise fail */
            NBBandTask *写用户信息 = [[NBBandTask getTaskbyActionType:BUSERINFO]setClean];

            _=@"这里只等待用户UID是否一致，不做其它操作了";
            [[写用户信息 addNext:[NBBandTask getTaskbyActionType:BWAITNOTIFY]] setNotifyType:BNT_AUTH];

            if ([写用户信息 beWait]) {
                NSLog(@"connect ok,retry %d times",(totoalTimes - retryTimes));
                return true;
            }else{
                // dis-connect ???
                // h.roomband.dis-connect
            }
        }
    }

    if (ret != true) {
        NSLog(@"connect fail,retry %d times",(totoalTimes - retryTimes));
    }
    
    return ret;
}

-(void)秤同步数据过程说明
{
    _=@"同步数据的Profile如下";
    /*
     (1). set notify


     (2). send : 01+ byte[4]: uuid little median  ---- >>>>   mi_scale


     . <<<<    [01][x0][x1] + byte[4]uuid  ( total size = x0 | (x1 << 8) )


     (3). send "02" ---- >>>>   mi_scale
     ..
     .. <<<< N * (   10 or 20 字节 measureemnt data.)
     ..
     .  <<<<   [03] to stop.//

     (4). if something wrong :
     send "03" ---- >>>>   mi_scale
     else,syncData ok:
     write: 04+ uuid

     
     (5). unset notify
     
     
     
     */

    _=@"这个Notify Task的stringValue = data，说明是data类型的notify，会在当前的OperatingRoom的notify Dict里面注册一个Data类型的slot，用来保存后面手环发回的Data形数据，每次notify返回一个data，覆盖前面的data。OPeratingRoom同一时间只保存一个data;\
        我们后面wait和watch 返回的也都是data类型。\
        boolValue :表示开关notify，关notify也会自动删除这个slot";
    NBScaleTask * 设置同步Notify = [[[NBScaleTask getTaskbyActionType:S_SYNC_DATA_NOTIFY]setSDStringValue:@"data"]setSDBoolValue:true];
    if (! [设置同步Notify beWait]) {
        NSLog(@"设置错误");
    }

    /*data */
    _=@"添加观察者; boolValue 表示开关;  strValue = SUUIDCharacter_Scale_Sync_CTL;表示要观察那个Characteristic的Notify。";
    NBScaleTask* 观察者 = [[NBScaleTask getTaskbyActionType:S_SYNC_DATA_WATCH]setSDBoolValue:true];
    if (! [观察者 beWait]) {
        NSLog(@"添加观察者 error");
    }

    _=@"观察者的watchSignal 会返回该characteristic的Notify value";
    [观察者.receivedata.watchSignal subscribeNext:^(NSData* x) {
        /* now we are on BT thread */


        if (x.length == 1) { //judge whether syncData over
            uint8_t bytes[1];
            [x getBytes:&bytes];

            if (bytes[0] == 3) { _=@"3 代表同步完成";
                dispatch_async([NBWaitingRoom getWaitingQueue:@"scale"], ^{
                    NBScaleTask* 同步完成命令 = [[NBScaleTask getTaskbyActionType:S_SYNC_WRITE_CMD]setSDIntValue:4];
                    if (! [同步完成命令 beWait]) {
                        NSLog(@"task  error");
                    } else{
                        NSLog(@"sync over ,,,,,,");
                    }
                });
            }
        } else{
            _=@"这里都是sync data，保存并处理即可";
            NSLog(@"++++++++++     %@",x);
        }


    } error:^(NSError *error) {
    } completed:^{

    }];

    NBScaleTask* 取同步数据信息命令 = [[NBScaleTask getTaskbyActionType:S_SYNC_WRITE_CMD]setSDIntValue:1];
    if (! [取同步数据信息命令 beWait]) {
        NSLog(@"task error");
    }

    NBScaleTask* 等待数据信息 = [NBScaleTask getTaskbyActionType:S_SYNC_DATA_WAIT];
    if (! [等待数据信息 beWait]) {
        NSLog(@"task error");
        return;
    } else{
        NSLog(@"get 01 cmd return: %@",取同步数据信息命令.receivedata.data);
    }


    NBScaleTask* 清空Notify并开始同步 = [[[NBScaleTask getTaskbyActionType:S_SYNC_WRITE_CMD]setSDIntValue:2]setClean];
    if (! [清空Notify并开始同步 beWait]) {
        NSLog(@"task error");
    }


    return;

}

-(void)秤升级固件过程说明
{
    /*
     (1). set notify

     (2). send length (uint16_t)  [01][xx][xx][xx] （第一位 01 是 操作码,后3位，little edian 是 data size）    .byte4[]： size<<8 | 01

     .   <<<<  [10][01][01]     (第一位是 回复操作码标识，第二位是 每一次发送的操作码，第三位是 成功值)

     (3). send start transfer.  [03]

     (4). send chunk data. 每20个字节发送小字节流，并且每20 * 20个字节清除GKI buffer.
     。。。清除GKI buffer ==> send [00].
     ..

     ..  <<<< [10][03][01]

     (5). send crc 校验码. (uint16_t)  [04][xx][xx] ---- >>>> mi_scale

     .
     .  <<<<  [10][04][01]
     (6). send restart (必须等称crc校验成功).  [05]


     */
    NSData *fw;_=@"这个fw保存固件的Data";
    NSInteger len = fw.length;

    /* 开 data 类型 notify */
    NBScaleTask* task = [[[NBScaleTask getTaskbyActionType:S_UPDATE_FW_NOTIFY]setSDStringValue:@"data"]setSDBoolValue:true];
    if (! [task beWait]) {
        NSLog(@"task error");
    }

    _=@" /* 开 watcher, sd.strValue = SUUIDCharacter_FW_DFU_CTL_Point; strValue 在ProfileCenter里面填充*/";
    NBScaleTask* next = [[NBScaleTask getTaskbyActionType:S_UPDATE_FW_WATCH]setSDBoolValue:true];
    if (! [next beWait]) {
        NSLog(@"task error");
    }
    [next.receivedata.watchSignal subscribeNext:^(NSData* x) {
        /* now we are on BT thread */
        NSLog(@"++++++++++     %@",x);
    } error:^(NSError *error) {

    } completed:^{

    }];

    //length
    _=@"clean notify， 写01 命令";
    task = [[NBScaleTask getTaskbyActionType:S_UPDATE_FW_CMD]setClean]; //must clean

    uint8_t bData[4];
    bData[0] = 1;
    bData[1] = len & 0xFF;
    bData[2] = (len >> 8) & 0xFF;
    bData[3] = (len >> 16)& 0xFF;

    NSData * data = [NSData dataWithBytes:&bData length:4];
    task.senddata.data = data;

    if (! [task beWait]) {
        NSLog(@"task error");
    }

    //wait
    _=@"等01命令返回，这次如果是wait task，那么上一个触发notify的task需要 setClean ！！";
    next = [NBScaleTask getTaskbyActionType:S_UPDATE_FW_WAIT];
    if (! [next beWait]) {
        NSLog(@"task error");
        return;
    } else{
        NSLog(@"get 01 cmd return: %@",next.receivedata.data);
    }

    //start
    _=@"我们下面用统一的一个CMD命令，来写蓝牙，具体cmd意义，根据我们填充的data而定";
    task = [NBScaleTask getTaskbyActionType:S_UPDATE_FW_CMD];
    uint8_t bData2[1];
    bData2[0] = 3;
    data = [NSData dataWithBytes:&bData2 length:1];
    task.senddata.data = data;
    if (! [task beWait]) {
        NSLog(@"task error");
    }

    _=@"写固件，这个task是个longTask，在OperatingRoom里面做单独处理了";
    task = [[NBScaleTask getTaskbyActionType:S_UPDATE_FW_WRITE_DATA] setClean]; //must clean
    task.senddata.data = fw;
    if (! [task beWait]) {
        NSLog(@"task error");
    }

    _=@"下面基本都差不多了，写的我累死了，不清楚直接问我chenee543216@gmail.com; 保质期1个月，过期我自己可能都不记得了";
    //wait
    next = [NBScaleTask getTaskbyActionType:S_UPDATE_FW_WAIT];
    if (! [next beWait]) {
        NSLog(@"task error");
        return;
    } else{
        NSLog(@"get 02 cmd return: %@",next.receivedata.data);
    }

    //send crc
    task = [[NBScaleTask getTaskbyActionType:S_UPDATE_FW_CMD] setClean]; //must clean
    uint16_t crc = crc16_compute([fw bytes], len);

    uint8_t bData3[3];
    bData3[0] = 4;
    bData3[1] = crc & 0xff;
    bData3[2] = (crc >> 8) & 0xff;
    data = [NSData dataWithBytes:&bData3 length:3];
    task.senddata.data = data;
    if (! [task beWait]) {
        NSLog(@"task error");
    }

    //wait crc
    next = [NBScaleTask getTaskbyActionType:S_UPDATE_FW_WAIT];
    if (! [next beWait]) {
        NSLog(@"task error");
        return;
    } else{
        NSLog(@"get 04 cmd return: %@",next.receivedata.data);
        //if ok restart

        task = [NBScaleTask getTaskbyActionType:S_UPDATE_FW_CMD];
        uint8_t bData2[1];
        bData2[0] = 5;
        data = [NSData dataWithBytes:&bData2 length:1];
        task.senddata.data = data;
        if (! [task beWait]) {
            NSLog(@"task error");
        } else{
            NSLog(@"upgrade ok , now reboot .....");
        }

    }

}
@end
