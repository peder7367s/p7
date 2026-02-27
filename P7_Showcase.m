// P7_Showcase.m — Full-looking UI with tons of fake features. UIKit + QuartzCore only.
// Theme: Cyber neon — dark, cyan/magenta/amber with glow. All buttons show "Demo only".

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define P7_BG    [UIColor colorWithRed:0.02f green:0.02f blue:0.06f alpha:1.0]
#define P7_PANEL [UIColor colorWithRed:0.05f green:0.04f blue:0.12f alpha:0.98]
#define P7_CARD  [UIColor colorWithRed:0.08f green:0.06f blue:0.16f alpha:1.0]
#define P7_CYAN  [UIColor colorWithRed:0.0f green:0.95f blue:1.0f alpha:1.0]
#define P7_MAG   [UIColor colorWithRed:1.0f green:0.0f blue:0.85f alpha:1.0]
#define P7_AMB   [UIColor colorWithRed:1.0f green:0.6f blue:0.0f alpha:1.0]
#define P7_GRN   [UIColor colorWithRed:0.0f green:1.0f blue:0.5f alpha:1.0]
#define P7_RED   [UIColor colorWithRed:1.0f green:0.25f blue:0.35f alpha:1.0]
#define P7_TEXT  [UIColor colorWithWhite:0.95f alpha:1.0]
#define P7_SUB   [UIColor colorWithWhite:0.5f alpha:1.0]

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

- (instancetype)init { if (self = [super init]) { _activeTab = 0; } return self; }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = P7_BG;
    CGFloat w = self.view.bounds.size.width;
    CGFloat y = 0;
    CGFloat pad = 12.0f;

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, y, w, 56)];
    header.backgroundColor = P7_PANEL;
    header.layer.borderWidth = 0.5;
    header.layer.borderColor = [P7_CYAN colorWithAlphaComponent:0.3].CGColor;
    [self.view addSubview:header];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(pad, 12, 90, 32)];
    title.text = @"P7";
    title.font = [UIFont boldSystemFontOfSize:28];
    title.textColor = P7_CYAN;
    title.layer.shadowColor = P7_CYAN.CGColor;
    title.layer.shadowRadius = 6;
    title.layer.shadowOpacity = 0.7;
    [header addSubview:title];
    UILabel *badge = [[UILabel alloc] initWithFrame:CGRectMake(pad + 50, 18, 70, 20)];
    badge.text = @"SHOWCASE";
    badge.font = [UIFont boldSystemFontOfSize:9];
    badge.textColor = P7_MAG;
    badge.backgroundColor = [P7_MAG colorWithAlphaComponent:0.2];
    badge.layer.cornerRadius = 4;
    badge.textAlignment = NSTextAlignmentCenter;
    badge.clipsToBounds = YES;
    [header addSubview:badge];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(w - 70, 12, 56, 32);
    [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    [closeBtn setTitleColor:P7_CYAN forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:closeBtn];
    y += 56;

    NSArray *tabTitles = @[ @"Items", @"Monsters", @"Shapes", @"Cheats", @"Admin", @"Locations", @"Settings" ];
    NSMutableArray *btns = [NSMutableArray array];
    self.tabScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, w, 48)];
    self.tabScroll.showsHorizontalScrollIndicator = NO;
    self.tabScroll.backgroundColor = P7_PANEL;
    CGFloat tx = pad;
    for (NSInteger i = 0; i < tabTitles.count; i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.tag = i;
        [b setTitle:tabTitles[i] forState:UIControlStateNormal];
        [b setTitleColor:(i == 0 ? P7_CYAN : P7_SUB) forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        [b sizeToFit];
        b.frame = CGRectMake(tx, 10, b.bounds.size.width + 18, 28);
        b.backgroundColor = (i == 0 ? [P7_CYAN colorWithAlphaComponent:0.15] : [UIColor clearColor]);
        b.layer.cornerRadius = 6;
        [b addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabScroll addSubview:b];
        [btns addObject:b];
        tx += b.bounds.size.width + 8;
    }
    self.tabButtons = [btns copy];
    self.tabScroll.contentSize = CGSizeMake(tx + pad, 48);
    [self.view addSubview:self.tabScroll];
    y += 48;

    UITextField *search = [[UITextField alloc] initWithFrame:CGRectMake(pad, y + 8, w - pad*2, 40)];
    search.placeholder = @"  Search items, cheats, admin...";
    search.backgroundColor = P7_CARD;
    search.textColor = P7_TEXT;
    search.layer.cornerRadius = 10;
    search.layer.borderWidth = 0.5;
    search.layer.borderColor = [P7_CYAN colorWithAlphaComponent:0.2].CGColor;
    search.leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,14,1)];
    search.leftViewMode = UITextFieldViewModeAlways;
    search.enabled = NO;
    [self.view addSubview:search];
    y += 56;

    self.contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, w, self.view.bounds.size.height - y - 20)];
    self.contentScroll.backgroundColor = [UIColor clearColor];
    self.contentInner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 0)];
    [self.contentScroll addSubview:self.contentInner];
    [self.view addSubview:self.contentScroll];
    [self fillContent];
}

- (void)tabTapped:(UIButton *)sender {
    for (UIButton *b in self.tabButtons) {
        [b setTitleColor:(b == sender ? P7_CYAN : P7_SUB) forState:UIControlStateNormal];
        b.backgroundColor = (b == sender ? [P7_CYAN colorWithAlphaComponent:0.15] : [UIColor clearColor]);
    }
    self.activeTab = sender.tag;
    [self fillContent];
}

- (UIButton *)btnWithTitle:(NSString *)title color:(UIColor *)color frame:(CGRect)f {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.frame = f;
    b.backgroundColor = P7_CARD;
    b.layer.cornerRadius = 10;
    b.layer.borderWidth = 0.5;
    b.layer.borderColor = [color colorWithAlphaComponent:0.25].CGColor;
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:color forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    b.titleLabel.numberOfLines = 2;
    b.titleLabel.textAlignment = NSTextAlignmentCenter;
    return b;
}

- (void)addSection:(NSString *)text color:(UIColor *)color pad:(CGFloat)pad w:(CGFloat)w y:(CGFloat *)py {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(pad, *py, w - pad*2, 20)];
    l.text = text;
    l.font = [UIFont boldSystemFontOfSize:11];
    l.textColor = color;
    [self.contentInner addSubview:l];
    *py += 24;
}

- (void)addButtons:(NSArray<NSString *> *)titles color:(UIColor *)color pad:(CGFloat)pad w:(CGFloat)w y:(CGFloat *)py btnH:(CGFloat)btnH {
    for (NSString *t in titles) {
        UIButton *b = [self btnWithTitle:t color:color frame:CGRectMake(pad, *py, w - pad*2, btnH)];
        [b addTarget:self action:@selector(demoTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.contentInner addSubview:b];
        *py += btnH + 6;
    }
}

- (void)fillContent {
    [[self.contentInner subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat w = self.contentScroll.bounds.size.width;
    CGFloat pad = 12.0f;
    CGFloat y = pad;
    CGFloat btnH = 46.0f;

    if (self.activeTab == 0) {
        [self addSection:@"CATEGORIES" color:P7_MAG pad:pad w:w y:&y];
        [self addButtons:@[ @"All", @"Weapons", @"Rare", @"Explosives", @"Food", @"Fish", @"Backpacks", @"Quest" ] color:P7_TEXT pad:pad w:w y:&y btnH:btnH];
        y += 6;
        [self addSection:@"GIVE ALL / SPAWN" color:P7_AMB pad:pad w:w y:&y];
        [self addButtons:@[ @"Give All Items", @"Spawn Max Stack", @"Infinite Ammo", @"Give All Weapons", @"Give All Rare" ] color:P7_AMB pad:pad w:w y:&y btnH:btnH];
        y += 6;
        [self addSection:@"QUICK SLOTS" color:P7_CYAN pad:pad w:w y:&y];
        for (int i = 0; i < 5; i++) {
            UIButton *b = [self btnWithTitle:[NSString stringWithFormat:@"Slot %d — tap to assign", i+1] color:P7_SUB frame:CGRectMake(pad, y, w - pad*2, btnH)];
            [b addTarget:self action:@selector(demoTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.contentInner addSubview:b];
            y += btnH + 6;
        }
        y += 6;
        [self addSection:@"SAMPLE ITEMS" color:P7_CYAN pad:pad w:w y:&y];
        [self addButtons:@[ @"item_rpg", @"item_shotgun", @"item_gold", @"item_jetpack", @"item_dynamite", @"item_apple", @"item_backpack", @"item_quest" ] color:P7_TEXT pad:pad w:w y:&y btnH:btnH];
    } else if (self.activeTab == 1) {
        [self addSection:@"MONSTERS" color:P7_MAG pad:pad w:w y:&y];
        [self addButtons:@[ @"Bear", @"Wolf", @"Boss", @"Wave Spawn", @"God Kit", @"Spawn 10x", @"Spawn 100x" ] color:P7_TEXT pad:pad w:w y:&y btnH:btnH];
    } else if (self.activeTab == 2) {
        [self addSection:@"SHAPES" color:P7_AMB pad:pad w:w y:&y];
        [self addButtons:@[ @"Heart", @"Circle", @"Tower", @"Wall", @"Spiral", @"Star", @"Hexagon", @"Bomb", @"Rainbow Ring" ] color:P7_AMB pad:pad w:w y:&y btnH:btnH];
    } else if (self.activeTab == 3) {
        [self addSection:@"💰 MONEY & RESOURCES" color:P7_GRN pad:pad w:w y:&y];
        [self addButtons:@[ @"Infinite Money", @"Max Money", @"No Work (instant)", @"Free Everything", @"Infinite Resources" ] color:P7_GRN pad:pad w:w y:&y btnH:btnH];
        y += 6;
        [self addSection:@"⚡ GOD MODE" color:P7_CYAN pad:pad w:w y:&y];
        [self addButtons:@[ @"God Mode", @"One Hit Kill", @"No Clip", @"Fly Mode", @"Speed Hack", @"Teleport" ] color:P7_CYAN pad:pad w:w y:&y btnH:btnH];
        y += 6;
        [self addSection:@"🧪 EXPERIMENTS" color:P7_AMB pad:pad w:w y:&y];
        [self addButtons:@[ @"Nuke Zone", @"Infinite Flare", @"Money Printer", @"Giveaway Bag", @"Infinite Health", @"Invisible" ] color:P7_AMB pad:pad w:w y:&y btnH:btnH];
    } else if (self.activeTab == 4) {
        [self addSection:@"🚫 BAN & KICK" color:P7_RED pad:pad w:w y:&y];
        [self addButtons:@[ @"Ban All", @"Kick All", @"Mute All", @"Unban All", @"Kick Selected" ] color:P7_RED pad:pad w:w y:&y btnH:btnH];
        y += 6;
        [self addSection:@"🎁 GIVE / SPAWN" color:P7_GRN pad:pad w:w y:&y];
        [self addButtons:@[ @"Give All (server)", @"Spawn at All Players", @"Admin Preset 1", @"Admin Preset 2", @"God Kit (all)" ] color:P7_GRN pad:pad w:w y:&y btnH:btnH];
        y += 6;
        [self addSection:@"🔧 ADMIN" color:P7_MAG pad:pad w:w y:&y];
        [self addButtons:@[ @"Log Panel", @"Server Stats", @"Player List", @"Force Respawn", @"Reset World" ] color:P7_MAG pad:pad w:w y:&y btnH:btnH];
    } else if (self.activeTab == 5) {
        [self addSection:@"LOCATIONS" color:P7_CYAN pad:pad w:w y:&y];
        [self addButtons:@[ @"Center of Spawn", @"Origin", @"Custom Position", @"Preset 1–10", @"Teleport to Player" ] color:P7_TEXT pad:pad w:w y:&y btnH:btnH];
    } else {
        [self addSection:@"SETTINGS" color:P7_SUB pad:pad w:w y:&y];
        [self addButtons:@[ @"Color / Hue", @"Random Color", @"Scale", @"Voice (demo)", @"Theme: Neon", @"About P7 Showcase" ] color:P7_TEXT pad:pad w:w y:&y btnH:btnH];
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
        btn.frame = CGRectMake(20, 100, 58, 58);
        btn.backgroundColor = P7_CYAN;
        btn.layer.cornerRadius = 29;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
        btn.layer.shadowColor = P7_CYAN.CGColor;
        btn.layer.shadowOffset = CGSizeMake(0, 0);
        btn.layer.shadowRadius = 12;
        btn.layer.shadowOpacity = 0.8;
        [btn setTitle:@"P7" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
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
