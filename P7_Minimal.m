// P7_Minimal.m — Single-file minimal build. Uses ONLY UIKit + Foundation.
// Build with: clang -arch arm64 -isysroot $SDK -dynamiclib -fobjc-arc
//   -framework UIKit -framework Foundation -mios-version-min=14.0
//   P7_Minimal.m -o P7.dylib

#import <UIKit/UIKit.h>

@interface P7MinimalPanel : UIViewController
@end
@implementation P7MinimalPanel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 200, 40)];
    title.text = @"P7 Menu";
    title.textColor = [UIColor cyanColor];
    title.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:title];
    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 60)];
    sub.text = @"Minimal build. Full menu needs Mac build.";
    sub.textColor = [UIColor whiteColor];
    sub.numberOfLines = 2;
    [self.view addSubview:sub];
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(20, 180, 100, 44);
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
}
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

__attribute__((constructor))
static void P7Load(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindowScene *scene = (UIWindowScene *)UIApplication.sharedApplication.connectedScenes.anyObject;
        if (!scene) return;
        UIWindow *window = nil;
        for (UIWindow *w in scene.windows) { if (w.isKeyWindow) { window = w; break; } }
        if (!window) return;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20, 100, 56, 56);
        btn.backgroundColor = [UIColor colorWithRed:0 green:0.9 blue:1 alpha:0.9];
        btn.layer.cornerRadius = 28;
        [btn setTitle:@"P7" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn addTarget:btn action:@selector(p7_open) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:btn];
    });
}

@interface UIButton (P7Minimal)
- (void)p7_open;
@end
@implementation UIButton (P7Minimal)
- (void)p7_open {
    UIWindowScene *scene = (UIWindowScene *)UIApplication.sharedApplication.connectedScenes.anyObject;
    UIWindow *window = nil;
    for (UIWindow *w in scene.windows) { if (w.isKeyWindow) { window = w; break; } }
    if (!window || !window.rootViewController) return;
    UIViewController *root = window.rootViewController;
    while (root.presentedViewController) root = root.presentedViewController;
    P7MinimalPanel *panel = [[P7MinimalPanel alloc] init];
    panel.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [root presentViewController:panel animated:YES completion:nil];
}
@end
