# PCGestureUnlock
===================
### 目前最全面最高仿支付宝的手势解锁，而且提供方法进行参数修改，能解决项目开发中所有手势解锁的开发
------------------
宣言：不仅仅是支付宝手势解锁，它很好很强大~

框架基础：全面实现支付宝手势解锁，包括各种细节！！！（具体见gif图片）

框架目标：打造主流手势解锁终结者，简单易用，高度解耦！

框架特点：面向实际项目开发，修改参数(PCCircleViewConst.h文件中)即可实现实际需求

### 设置密码：

![ABC](https://github.com/iosdeveloperpanc/PCGestureUnlock/blob/master/PCGestureUnlock/settingGesture.gif) 

### 细节处理之全方向箭头

![ABC](https://github.com/iosdeveloperpanc/PCGestureUnlock/blob/master/PCGestureUnlock/arrowDirctions.gif) 

### 细节处理之错误绘制

![ABC](https://github.com/iosdeveloperpanc/PCGestureUnlock/blob/master/PCGestureUnlock/ErrorDisplay.gif) 

### 细节处理之跳跃连线

![ABC](https://github.com/iosdeveloperpanc/PCGestureUnlock/blob/master/PCGestureUnlock/JumpConnect.gif) 

### 框架使用说明：
使用前说明：
解锁界面（PCCircleView）可以实例化出特定使用的类型界面，实现以下方法即可
// 初始化方法（设置view的相关类型、参数）
    - (instancetype)initWithType:(CircleViewType)type clip:(BOOL)clip arrow:(BOOL)arrow;
clip代表圆内是否剪切 arrow代表是否有三角箭头

### 1.包含框架文件：（FrameWork）
### 2.在使用到的控制器中实现以下方法：
      - (void)viewDidLoad {
      [super viewDidLoad];
      // Do any additional setup after loading the view.
 
     // 解锁界面  默认clip:YES, arrow:YES
     PCCircleView *lockView = [[PCCircleView alloc] init];  
      lockView.delegate = self;
      self.lockView = lockView;
      [self.view addSubview:lockView];
     }

      #pragma - mark - circleView - delegate
      #pragma mark - circleView - delegate - setting
      - (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
    {
     NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];

      // 看是否存在第一个密码
     if ([gestureOne length]) {
         NSLog(@"提示再次绘制之前绘制的第一个手势密码");
     } else {
         NSLog(@"密码长度不合法%@", gesture);
     }
     }

      - (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
    {
       NSLog(@"获得第一个手势密码%@", gesture);
       // infoView展示对应选中的圆
    }

    - (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
    {
     NSLog(@"获得第二个手势密码%@",gesture)；
     if (equal) {
         NSLog(@"两次手势匹配！可以进行本地化保存了");
      
     } else {
         NSLog(@"两次手势不匹配！");
     }
      }

    #pragma mark - circleView - delegate - login or verify gesture
      - (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
    {
        // 此时的type有两种情况 Login or verify
        if (type == CircleViewTypeLogin) {
           if (equal) {
             NSLog(@"登陆成功！");
           } else {
            NSLog(@"密码错误！");
           }
     } else if (type == CircleViewTypeVerify) {
         
           if (equal) {
               NSLog(@"验证成功，跳转到设置手势界面");
               
           } else {
             NSLog(@"原手势密码输入错误！");
               
        }
        }
    }


# PCGestureUnlock 手势解锁终结者
------------

