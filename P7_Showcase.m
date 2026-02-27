// P7_Showcase.m — Full-looking UI, no real features. UIKit + QuartzCore only.
// Theme: dark, cyan/magenta/amber. All buttons show "Demo only" or similar.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define P7_BG    [UIColor colorWithRed:0.04f green:0.04f blue:0.07f alpha:1.0]
#define P7_PANEL [UIColor colorWithRed:0.06f green:0.06f blue:0.10f alpha:0.97]
#define P7_CYAN  [UIColor colorWithRed:0.0f green:0.90f blue:1.0f alpha:1.0]
#define P7_MAG   [UIColor colorWithRed:1.0f green:0.0f blue:0.78f alpha:1.0]
#define P7_AMB   [UIColor colorWithRed:1.0f green:0.67f blue:0.0f alpha:1.0]
#define P7_TEXT  [UIColor colorWithWhite:0.95f alpha:1.0]
#define P7_SUB   [UIColor colorWithWhite:0.55f alpha:1.0]
#define P7_CARD  [UIColor colorWithRed:0.09f green:0.09f blue:0.14f alpha:1.0]

static void P7ShowDemo(UIViewController *vc, NSString *msg) {
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"P7 Showcase" message:msg ?: @"Demo only — not connected." preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [vc presentViewController:a animated:YES completion:nil];
}

@interface P7ShowcasePanel : UIViewController
@property (nonatomic) NSInteger activeTab;
@property (nonatomic, strong) UIScrollView *tabScroll;
@property (nonatomic, strong) NSArray<UIButton *> *tabButtons;
@property (nonatomic, strong) UIScrollView *contentScroll;
@property (nonatomic, strong) UIView *contentInner;
@end

@implementation P7ShowcasePanel

- (instancetype)init {
    if (self = [super init]) { _activeTab = 0; }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = P7_BG;
    CGFloat w = self.view.bounds.size.width;
    CGFloat y = 0;
    CGFloat pad = 12.0f;

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, y, w, 52)];
    header.backgroundColor = P7_PANEL;
    [self.view addSubview:header];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(pad, 10, 80, 32)];
    title.text = @"P7";
    title.font = [UIFont boldSystemFontOfSize:26];
    title.textColor = P7_CYAN;
    [header addSubview:title];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(w - 70, 10, 56, 32);
    [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    [closeBtn setTitleColor:P7_CYAN forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:closeBtn];
    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(w - 140, 14, 60, 24)];
    sub.text = @"Showcase";
    sub.font = [UIFont systemFontOfSize:12];
    sub.textColor = P7_SUB;
    sub.textAlignment = NSTextAlignmentRight;
    [header addSubview:sub];
    y += 52;

    NSArray *tabTitles = @[ @"Items", @"Monsters", @"Shapes", @"Experiments", @"Locations", @"Admin", @"Settings" ];
    NSMutableArray *btns = [NSMutableArray array];
    self.tabScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, w, 44)];
    self.tabScroll.showsHorizontalScrollIndicator = NO;
    self.tabScroll.backgroundColor = P7_PANEL;
    CGFloat tx = pad;
    for (NSInteger i = 0; i < tabTitles.count; i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.tag = i;
        [b setTitle:tabTitles[i] forState:UIControlStateNormal];
        [b setTitleColor:(i == 0 ? P7_CYAN : P7_SUB) forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [b sizeToFit];
        b.frame = CGRectMake(tx, 8, b.bounds.size.width + 16, 28);
        b.layer.cornerRadius = 6;
        [b addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabScroll addSubview:b];
        [btns addObject:b];
        tx += b.bounds.size.width + 8;
    }
    self.tabButtons = [btns copy];
    self.tabScroll.contentSize = CGSizeMake(tx + pad, 44);
    [self.view addSubview:self.tabScroll];
    y += 44;

    UITextField *search = [[UITextField alloc] initWithFrame:CGRectMake(pad, y + 8, w - pad*2, 36)];
    search.placeholder = @" Search items... (demo)";
    search.backgroundColor = P7_CARD;
    search.textColor = P7_TEXT;
    search.layer.cornerRadius = 8;
    search.leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,12,1)];
    search.leftViewMode = UITextFieldViewModeAlways;
    search.enabled = NO;
    [self.view addSubview:search];
    y += 52;

    self.contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, w, self.view.bounds.size.height - y - 20)];
    self.contentScroll.backgroundColor = [UIColor clearColor];
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentInner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 0)];
    [self.contentScroll addSubview:self.contentInner];
    [self.view addSubview:self.contentScroll];
    [self fillContent];
}

- (void)tabTapped:(UIButton *)sender {
    for (UIButton *b in self.tabButtons)
        [b setTitleColor:(b == sender ? P7_CYAN : P7_SUB) forState:UIControlStateNormal];
    self.activeTab = sender.tag;
    [self fillContent];
}

- (UIButton *)btnWithTitle:(NSString *)title color:(UIColor *)color frame:(CGRect)f {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.frame = f;
    b.backgroundColor = P7_CARD;
    b.layer.cornerRadius = 8;
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:color forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:14];
    b.titleLabel.numberOfLines = 2;
    b.titleLabel.textAlignment = NSTextAlignmentCenter;
    return b;
}

- (void)fillContent {
    [[self.contentInner subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat w = self.contentScroll.bounds.size.width;
    CGFloat pad = 12.0f;
    CGFloat y = pad;
    CGFloat btnH = 44.0f;

    if (self.activeTab == 0) {
        UILabel *sec = [[UILabel alloc] initWithFrame:CGRectMake(pad, y, w - pad*2, 22)];
        sec.text = @"Categories";
        sec.font = [UIFont boldSystemFontOfSize:12];
        sec.textColor = P7_MAG;
        [self.contentInner addSubview:sec];
        y += 26;
        NSArray *cats = @[ @"All", @"Weapons", @"Rare", @"Explosives", @"Food", @"Fish", @"Backpacks", @"Quest" ];
        for (NSString *c in cats) {
            UIButton *b = [self btnWithTitle:c color:P7_TEXT frame:CGRectMake(pad, y, w - pad*2, btnH)];
            [b addTarget:self action:@selector(demoTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.contentInner addSubview:b];
            y += btnH + 6;
        }
        y += 10;
        sec = [[UILabel alloc] initWithFrame:CGRectMake(pad, y, w - pad*2, 22)];
        sec.text = @"Quick slots";
        sec.font = [UIFont boldSystemFontOfSize:12];
        sec.textColor = P7_AMB;
        [self.contentInner addSubview:sec];
        y += 26;
        for (int i = 0; i < 5; i++) {
            UIButton *b = [self btnWithTitle:[NSString stringWithFormat:@"Slot %d (tap to set)", i+1] color:P7_SUB frame:CGRectMake(pad, y, w - pad*2, btnH)];
            [b addTarget:self action:@selector(demoTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.contentInner addSubview:b];
            y += btnH + 6;
        }
        y += 10;
        sec = [[UILabel alloc] initWithFrame:CGRectMake(pad, y, w - pad*2, 22)];
        sec.text = @"Sample items (demo)";
        sec.font = [UIFont boldSystemFontOfSize:12];
        sec.textColor = P7_CYAN;
        [self.contentInner addSubview:sec];
        y += 26;
        NSArray *items = @[ @"item_rpg", @"item_shotgun", @"item_gold", @"item_jetpack", @"item_dynamite", @"item_apple", @"item_backpack" ];
        for (NSString *item in items) {
            UIButton *b = [self btnWithTitle:item color:P7_TEXT frame:CGRectMake(pad, y, w - pad*2, btnH)];
            [b addTarget:self action:@selector(demoTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.contentInner addSubview:b];
            y += btnH + 6;
        }
    } else if (self.activeTab == 1) {
        UILabel *sec = [[UILabel alloc] initWithFrame:CGRectMake(pad, y, w - pad*2, 22)];
        sec.text = @"Monsters (demo)";
        sec.font = [UIFont boldSystemFontOfSize:12];
        sec.textColor = P7_MAG;
        [self.contentInner addSubview:sec];
        y += 26;
        NSArray *monsters = @[ @"Bear", @"Wolf", @"Boss", @"Wave spawn", @"God kit" ];
        for (NSString *m in monsters) {
            UIButton *b = [self btnWithTitle:m color:P7_TEXT frame:CGRectMake(pad, y, w - pad*2, btnH)];
            [b addTarget:self action:@selector(demoTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.contentInner addSubview:b];
            y += btnH + 6;
        }
    } else if (self.activeTab == 2) {
        NSArray *shapes = @[ @"Heart", @"Circle", @"Tower", @"Wall", @"Spiral", @"Star", @"Hexagon", @"Bomb" ];
        for (NSString *s in shapes) {
            UIButton *b = [self btnWithTitle:s color:P7_AMB frame:CGRectMake(pad, y, w - pad*2, btnH)];
            [b addTarget:self action:@selector(demoTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.contentInner addSubview:b];
            y += btnH + 6;
        }
    } else if (self.activeTab == 3) {
        NSArray *exps = @[ @"Nuke zone", @"Infinite flare", @"Money printer", @"Giveaway bag" ];
        for (NSString *e in exps) {
            UIButton *b = [self btnWithTitle:e color:P7_CYAN frame:CGRectMake(pad, y, w - pad*2, btnH)];
            [b addTarget:self action:@selector(demoTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.contentInner addSubview:b];
            y += btnH + 6;
        }
    } else if (self.activeTab == 4) {
        NSArray *locs = @[ @"Center of Spawn", @"Origin", @"Custom position", @"Preset 1–10" ];
        for (NSString *loc in locs) {
            UIButton *b = [self btnWithTitle:loc color:P7_TEXT frame:CGRectMake(pad, y, w - pad*2, btnH)];
            [b addTarget:self action:@selector(demoTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.contentInner addSubview:b];
            y += btnH + 6;
        }
    } else if (self.activeTab == 5) {
        NSArray *adm = @[ @"Admin preset 1", @"Admin preset 2", @"Spawn at player", @"Log panel" ];
        for (NSString *a in adm) {
            UIButton *b = [self btnWithTitle:a color:P7_MAG frame:CGRectMake(pad, y, w - pad*2, btnH)];
            [b addTarget:self action:@selector(demoTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.contentInner addSubview:b];
            y += btnH + 6;
        }
    } else {
        UILabel *sec = [[UILabel alloc] initWithFrame:CGRectMake(pad, y, w - pad*2, 22)];
        sec.text = @"Settings (demo)";
        sec.font = [UIFont boldSystemFontOfSize:12];
        sec.textColor = P7_SUB;
        [self.contentInner addSubview:sec];
        y += 26;
        NSArray *set = @[ @"Color / hue", @"Random color", @"Scale", @"Voice (demo)", @"About P7 Showcase" ];
        for (NSString *s in set) {
            UIButton *b = [self btnWithTitle:s color:P7_TEXT frame:CGRectMake(pad, y, w - pad*2, btnH)];
            [b addTarget:self action:@selector(demoTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.contentInner addSubview:b];
            y += btnH + 6;
        }
    }
    y += pad;
    self.contentInner.frame = CGRectMake(0, 0, w, y);
    self.contentScroll.contentSize = CGSizeMake(w, y);
}

- (void)demoTapped {
    P7ShowDemo(self, @"Showcase build — features not connected.\nInstall full P7 for real menu.");
}

- (void)closeTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

__attribute__((constructor))
static void P7ShowcaseLoad(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindowScene *scene = (UIWindowScene *)UIApplication.sharedApplication.connectedScenes.anyObject;
        if (!scene) return;
        UIWindow *window = nil;
        for (UIWindow *w in scene.windows) { if (w.isKeyWindow) { window = w; break; } }
        if (!window) return;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20, 100, 56, 56);
        btn.backgroundColor = P7_CYAN;
        btn.layer.cornerRadius = 28;
        btn.layer.shadowColor = [UIColor blackColor].CGColor;
        btn.layer.shadowOffset = CGSizeMake(0, 2);
        btn.layer.shadowOpacity = 0.5;
        btn.layer.shadowRadius = 4;
        [btn setTitle:@"P7" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn addTarget:btn action:@selector(p7_showcase_open) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:btn];
    });
}

@interface UIButton (P7Showcase)
- (void)p7_showcase_open;
@end
@implementation UIButton (P7Showcase)
- (void)p7_showcase_open {
    UIWindowScene *scene = (UIWindowScene *)UIApplication.sharedApplication.connectedScenes.anyObject;
    UIWindow *window = nil;
    for (UIWindow *w in scene.windows) { if (w.isKeyWindow) { window = w; break; } }
    if (!window || !window.rootViewController) return;
    UIViewController *root = window.rootViewController;
    while (root.presentedViewController) root = root.presentedViewController;
    P7ShowcasePanel *panel = [[P7ShowcasePanel alloc] init];
    panel.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [root presentViewController:panel animated:YES completion:nil];
}
@end
