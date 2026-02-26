// =============================================================================
// P7 — Frontend UI
// Target: Animal Company (Unity/IL2CPP, iOS)
// Theme: Cyber / Neon — dark base, cyan, magenta, amber accents
// =============================================================================

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

// ─── P7 Backend API (implemented in P7 Backend.m) ───────────────────────────
BOOL P7InitRuntime(void);
void P7LoadItemDatabase(void);
NSArray *P7GetAllItems(void);
NSArray *P7GetAllMonsters(void);
int P7GetPresetCount(void);
void P7GetPresetPosition(int index, float out[3], const char **outName);
BOOL P7GetLocalPlayerPosition(float outPos[3]);
void P7SetSpawnPosition(float x, float y, float z);
void P7GetSpawnPosition(float out[3]);
void P7SetColorEnabled(BOOL on);
void P7SetRandomColor(BOOL on);
void P7SetColorHue(int h);
void P7SetColorSat(int s);
BOOL P7SpawnItem(NSString *itemName, int quantity, float pos[3]);
BOOL P7SpawnMonster(NSString *controllerName, int quantity, float pos[3]);
void P7SpawnHeart(NSString *itemName, float center[3], int numPoints);
void P7SpawnCircle(NSString *itemName, float center[3], int numPoints, float radius);
void P7SpawnTower(NSString *itemName, float base[3], int height);
void P7SpawnWall(NSString *itemName, float base[3]);
void P7SpawnSpiral(NSString *itemName, float center[3], int numPoints);
void P7SpawnStar(NSString *itemName, float center[3]);
void P7SpawnHexagon(NSString *itemName, float center[3], float radius);
void P7SpawnBomb(float center[3]);
void P7SpawnMonsterWave(float pos[3]);
void P7SpawnGodKit(float pos[3]);
void P7SpawnGiveawayBag(float pos[3]);
void P7SpawnMoneyPrinter(float pos[3]);
void P7SpawnNukeZone(float pos[3]);
void P7SpawnInfiniteFlare(float pos[3]);

// =============================================================================
#pragma mark - P7 Theme Colors
// =============================================================================

#define P7_BG       [UIColor colorWithRed:0.04f green:0.04f blue:0.07f alpha:1.0]
#define P7_PANEL    [UIColor colorWithRed:0.06f green:0.06f blue:0.10f alpha:0.97]
#define P7_CYAN     [UIColor colorWithRed:0.0f green:0.90f blue:1.0f alpha:1.0]
#define P7_MAGENTA  [UIColor colorWithRed:1.0f green:0.0f blue:0.78f alpha:1.0]
#define P7_AMBER    [UIColor colorWithRed:1.0f green:0.67f blue:0.0f alpha:1.0]
#define P7_TEXT     [UIColor colorWithWhite:0.95f alpha:1.0]
#define P7_SUBTEXT  [UIColor colorWithWhite:0.55f alpha:1.0]
#define P7_CARD     [UIColor colorWithRed:0.09f green:0.09f blue:0.14f alpha:1.0]
#define P7_ACCENT   P7_CYAN

// Tab indices
typedef NS_ENUM(NSInteger, P7Tab) {
    P7TabItems = 0, P7TabMonsters = 1, P7TabShapes = 2,
    P7TabExperiments = 3, P7TabLocations = 4, P7TabAdmin = 5, P7TabSettings = 6,
};

typedef NS_ENUM(NSInteger, P7Category) {
    P7CategoryAll = 0, P7CategoryWeapons = 1, P7CategoryRare = 2,
    P7CategoryExplosives = 3, P7CategoryFood = 4, P7CategoryFish = 5,
    P7CategoryBackpacks = 6, P7CategoryQuest = 7,
};

static NSArray *P7_weaponPrefixes;
static NSArray *P7_rarePrefixes;
static NSArray *P7_explosivePrefixes;
static NSArray *P7_foodPrefixes;
static NSArray *P7_fishPrefixes;
static NSArray *P7_backpackPrefixes;
static NSArray *P7_questPrefixes;

static void P7LoadCategoryPrefixes(void) {
    P7_weaponPrefixes   = @[@"item_rpg", @"item_shotgun", @"item_revolver", @"item_sword", @"item_crossbow", @"item_grenade", @"item_flare", @"item_arrow", @"item_shield", @"item_axe", @"item_bat", @"item_lance"];
    P7_rarePrefixes     = @[@"item_gold", @"item_ruby", @"item_diamond", @"item_jetpack", @"item_demon", @"item_stellar", @"item_rare"];
    P7_explosivePrefixes= @[@"item_dynamite", @"item_grenade", @"item_bomb", @"item_landmine", @"item_flashbang", @"item_cluster", @"item_tripwire"];
    P7_foodPrefixes     = @[@"item_apple", @"item_banana", @"item_burrito", @"item_turkey", @"item_pumpkin_pie", @"item_popcorn", @"item_beans", @"item_cola", @"item_cocoa"];
    P7_fishPrefixes     = @[@"item_fish", @"item_goopfish", @"item_rod"];
    P7_backpackPrefixes = @[@"item_backpack"];
    P7_questPrefixes    = @[@"item_quest"];
}

// =============================================================================
#pragma mark - P7PanelController
// =============================================================================

@interface P7PanelController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIDocumentPickerDelegate>

@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) UIView *mainInner;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *titleLabel;      // "P7"
@property (nonatomic, strong) UIScrollView *tabScroll;
@property (nonatomic, strong) NSArray<UIButton *> *tabButtons;

@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *quantityLabel;
@property (nonatomic, strong) UILabel *itemCountLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UISwitch *colorSwitch;
@property (nonatomic, strong) UISwitch *randomColorSwitch;
@property (nonatomic, strong) UISlider *hueSlider;
@property (nonatomic, strong) UISlider *satSlider;
@property (nonatomic, strong) UIView *colorPreview;

@property (nonatomic, strong) UIView *quickSlotsView;
@property (nonatomic, strong) NSArray<UIButton *> *quickSlotButtons;
@property (nonatomic, strong) NSMutableArray<NSString *> *quickSlotItems;

@property (nonatomic, strong) UIView *favoritesSection;
@property (nonatomic, strong) NSMutableArray<NSString *> *favorites;
@property (nonatomic, strong) UITableView *favoritesTable;

@property (nonatomic, strong) UIScrollView *shapesScroll;
@property (nonatomic, strong) UIScrollView *experimentsScroll;
@property (nonatomic, strong) UIScrollView *locationsScroll;
@property (nonatomic, strong) UIScrollView *adminScroll;
@property (nonatomic, strong) UIScrollView *settingsScroll;

@property (nonatomic, strong) UITextView *logView;

@property (nonatomic) NSInteger activeTab;
@property (nonatomic) NSInteger activeCategory;
@property (nonatomic) NSInteger spawnQuantity;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray<NSString *> *recentSpawns;
@end

@implementation P7PanelController

- (instancetype)init {
    if (self = [super init]) {
        _spawnQuantity = 1;
        _selectedIndex = 0;
        _activeCategory = P7CategoryAll;
        _quickSlotItems = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", nil];
        _favorites = [NSMutableArray array];
        _recentSpawns = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];

    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    CGFloat panelW = w - 24;
    CGFloat panelH = h - 80;

    // Dismiss tap
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissBtn.frame = self.view.bounds;
    dismissBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [dismissBtn addTarget:self action:@selector(p7_dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissBtn];

    // Main panel — glass style
    self.panelView = [[UIView alloc] initWithFrame:CGRectMake(12, 50, panelW, panelH)];
    self.panelView.backgroundColor = P7_PANEL;
    self.panelView.layer.cornerRadius = 20;
    self.panelView.layer.masksToBounds = YES;
    self.panelView.layer.borderWidth = 1;
    self.panelView.layer.borderColor = [P7_CYAN colorWithAlphaComponent:0.4].CGColor;
    self.panelView.layer.shadowColor = P7_CYAN.CGColor;
    self.panelView.layer.shadowOffset = CGSizeZero;
    self.panelView.layer.shadowRadius = 20;
    self.panelView.layer.shadowOpacity = 0.3;
    [self.view addSubview:self.panelView];

    // Header gradient
    CAGradientLayer *headerGrad = [CAGradientLayer layer];
    headerGrad.frame = CGRectMake(0, 0, panelW, 56);
    headerGrad.colors = @[
        (id)[P7_CYAN colorWithAlphaComponent:0.25].CGColor,
        (id)[P7_MAGENTA colorWithAlphaComponent:0.15].CGColor,
    ];
    headerGrad.startPoint = CGPointMake(0, 0);
    headerGrad.endPoint = CGPointMake(1, 1);
    [self.panelView.layer addSublayer:headerGrad];

    // P7 title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, 120, 36)];
    self.titleLabel.text = @"P7";
    self.titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightHeavy];
    self.titleLabel.textColor = P7_CYAN;
    self.titleLabel.layer.shadowColor = P7_CYAN.CGColor;
    self.titleLabel.layer.shadowRadius = 8;
    self.titleLabel.layer.shadowOpacity = 0.9;
    [self.panelView addSubview:self.titleLabel];

    // Close
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(panelW - 44, 12, 32, 32);
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    [closeBtn setTitleColor:P7_TEXT forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [closeBtn addTarget:self action:@selector(p7_dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.panelView addSubview:closeBtn];

    // Tab bar
    NSArray *tabTitles = @[@"Items", @"Monsters", @"Shapes", @"Experiments", @"Locations", @"Admin", @"Settings"];
    self.tabScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 52, panelW, 40)];
    self.tabScroll.showsHorizontalScrollIndicator = NO;
    self.tabScroll.backgroundColor = [UIColor clearColor];
    CGFloat tabW = 88;
    NSMutableArray *tabs = [NSMutableArray array];
    for (NSUInteger i = 0; i < tabTitles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(8 + i * (tabW + 4), 4, tabW, 32);
        [btn setTitle:tabTitles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        btn.layer.cornerRadius = 10;
        btn.tag = i;
        [btn addTarget:self action:@selector(p7_switchTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabScroll addSubview:btn];
        [tabs addObject:btn];
    }
    self.tabButtons = [tabs copy];
    self.tabScroll.contentSize = CGSizeMake(8 + tabTitles.count * (tabW + 4), 40);
    [self.panelView addSubview:self.tabScroll];

    CGFloat contentY = 96;
    CGFloat contentH = panelH - contentY;

    // Main content scroll
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, contentY, panelW, contentH)];
    self.mainScroll.showsVerticalScrollIndicator = YES;
    self.mainScroll.backgroundColor = [UIColor clearColor];
    [self.panelView addSubview:self.mainScroll];

    self.mainInner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, panelW, 1600)];
    [self.mainScroll addSubview:self.mainInner];

    [self p7_buildItemsContent];
    [self p7_buildShapesContent];
    [self p7_buildExperimentsContent];
    [self p7_buildLocationsContent];
    [self p7_buildAdminContent];
    [self p7_buildSettingsContent];

    self.activeTab = P7TabItems;
    [self p7_updateTabAppearance];
    [self p7_showTabContent];

    // Log at bottom
    self.logView = [[UITextView alloc] initWithFrame:CGRectMake(12, panelH - 70, panelW - 24, 54)];
    self.logView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.logView.textColor = P7_CYAN;
    self.logView.font = [UIFont fontWithName:@"Menlo" size:10];
    self.logView.editable = NO;
    self.logView.text = @"P7 ready.";
    self.logView.layer.cornerRadius = 8;
    [self.panelView addSubview:self.logView];

    // Animate in
    self.panelView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    self.panelView.alpha = 0;
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.5 options:0 animations:^{
        self.panelView.transform = CGAffineTransformIdentity;
        self.panelView.alpha = 1;
    } completion:nil];
}

- (void)p7_buildItemsContent {
    CGFloat y = 8;
    CGFloat w = self.mainInner.bounds.size.width;

    // Quick slots
    UILabel *slotLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 200, 22)];
    slotLabel.text = @"Quick spawn (tap to save, tap again to spawn)";
    slotLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    slotLabel.textColor = P7_SUBTEXT;
    [self.mainInner addSubview:slotLabel];
    y += 24;

    NSMutableArray *slots = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(12 + i * 62, y, 58, 32);
        [btn setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
        btn.backgroundColor = P7_CARD;
        btn.layer.cornerRadius = 8;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [P7_CYAN colorWithAlphaComponent:0.5].CGColor;
        btn.tag = i;
        [btn addTarget:self action:@selector(p7_quickSlotTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainInner addSubview:btn];
        [slots addObject:btn];
    }
    self.quickSlotButtons = [slots copy];
    y += 40;

    // Category chips
    NSArray *catTitles = @[@"All", @"Weapons", @"Rare", @"Explosives", @"Food", @"Fish", @"Backpacks", @"Quest"];
    for (NSUInteger i = 0; i < catTitles.count; i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(12 + (i % 4) * 82, y + (i / 4) * 34, 78, 28);
        [b setTitle:catTitles[i] forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:11];
        b.layer.cornerRadius = 8;
        b.tag = i;
        [b addTarget:self action:@selector(p7_categoryTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainInner addSubview:b];
    }
    y += 72;

    self.itemCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, y, w - 24, 18)];
    self.itemCountLabel.font = [UIFont systemFontOfSize:11];
    self.itemCountLabel.textColor = P7_SUBTEXT;
    [self.mainInner addSubview:self.itemCountLabel];
    y += 22;

    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(12, y, w - 24, 36)];
    self.searchField.placeholder = @" Search items...";
    self.searchField.font = [UIFont systemFontOfSize:14];
    self.searchField.textColor = P7_TEXT;
    self.searchField.backgroundColor = P7_CARD;
    self.searchField.layer.cornerRadius = 10;
    self.searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 36)];
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    self.searchField.delegate = self;
    [self.searchField addTarget:self action:@selector(p7_searchChanged) forControlEvents:UIControlEventEditingChanged];
    [self.mainInner addSubview:self.searchField];
    y += 44;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, y, w - 24, 200) style:UITableViewStylePlain];
    self.tableView.backgroundColor = P7_CARD;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.layer.cornerRadius = 12;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.mainInner addSubview:self.tableView];
    y += 208;

    // Quantity row
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    minusBtn.frame = CGRectMake(12, y, 36, 36);
    [minusBtn setTitle:@"−" forState:UIControlStateNormal];
    [minusBtn setTitleColor:P7_CYAN forState:UIControlStateNormal];
    minusBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [minusBtn addTarget:self action:@selector(p7_decreaseQty) forControlEvents:UIControlEventTouchUpInside];
    [self.mainInner addSubview:minusBtn];

    self.quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, y, 50, 36)];
    self.quantityLabel.text = @"1";
    self.quantityLabel.font = [UIFont monospacedDigitSystemFontOfSize:18 weight:UIFontWeightBold];
    self.quantityLabel.textColor = P7_TEXT;
    self.quantityLabel.textAlignment = NSTextAlignmentCenter;
    [self.mainInner addSubview:self.quantityLabel];

    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    plusBtn.frame = CGRectMake(106, y, 36, 36);
    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
    [plusBtn setTitleColor:P7_CYAN forState:UIControlStateNormal];
    plusBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [plusBtn addTarget:self action:@selector(p7_increaseQty) forControlEvents:UIControlEventTouchUpInside];
    [self.mainInner addSubview:plusBtn];

    // Add to favorites
    UIButton *favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favBtn.frame = CGRectMake(150, y, 100, 36);
    [favBtn setTitle:@"★ Favorite" forState:UIControlStateNormal];
    favBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    [favBtn setTitleColor:P7_AMBER forState:UIControlStateNormal];
    favBtn.backgroundColor = P7_CARD;
    favBtn.layer.cornerRadius = 10;
    [favBtn addTarget:self action:@selector(p7_addFavorite) forControlEvents:UIControlEventTouchUpInside];
    [self.mainInner addSubview:favBtn];

    y += 42;

    // Color
    self.colorSwitch = [[UISwitch alloc] init];
    self.colorSwitch.frame = CGRectMake(12, y, 0, 0);
    self.colorSwitch.onTintColor = P7_CYAN;
    [self.colorSwitch addTarget:self action:@selector(p7_colorToggled) forControlEvents:UIControlEventValueChanged];
    [self.mainInner addSubview:self.colorSwitch];
    UILabel *colorLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, y, 80, 32)];
    colorLbl.text = @"Color";
    colorLbl.font = [UIFont systemFontOfSize:13];
    colorLbl.textColor = P7_TEXT;
    [self.mainInner addSubview:colorLbl];
    self.randomColorSwitch = [[UISwitch alloc] init];
    self.randomColorSwitch.frame = CGRectMake(140, y, 0, 0);
    self.randomColorSwitch.onTintColor = P7_MAGENTA;
    [self.mainInner addSubview:self.randomColorSwitch];
    UILabel *randLbl = [[UILabel alloc] initWithFrame:CGRectMake(188, y, 70, 32)];
    randLbl.text = @"Random";
    randLbl.font = [UIFont systemFontOfSize:13];
    randLbl.textColor = P7_TEXT;
    [self.mainInner addSubview:randLbl];
    y += 36;

    self.colorPreview = [[UIView alloc] initWithFrame:CGRectMake(12, y, 28, 28)];
    self.colorPreview.backgroundColor = [UIColor redColor];
    self.colorPreview.layer.cornerRadius = 6;
    [self.mainInner addSubview:self.colorPreview];
    self.hueSlider = [[UISlider alloc] initWithFrame:CGRectMake(48, y, w - 120, 28)];
    self.hueSlider.minimumValue = 0;
    self.hueSlider.maximumValue = 360;
    self.hueSlider.value = 0;
    self.hueSlider.minimumTrackTintColor = P7_CYAN;
    [self.hueSlider addTarget:self action:@selector(p7_colorChanged) forControlEvents:UIControlEventValueChanged];
    [self.mainInner addSubview:self.hueSlider];
    y += 32;

    self.satSlider = [[UISlider alloc] initWithFrame:CGRectMake(48, y, w - 120, 28)];
    self.satSlider.minimumValue = 0;
    self.satSlider.maximumValue = 100;
    self.satSlider.value = 100;
    self.satSlider.minimumTrackTintColor = P7_MAGENTA;
    [self.satSlider addTarget:self action:@selector(p7_colorChanged) forControlEvents:UIControlEventValueChanged];
    [self.mainInner addSubview:self.satSlider];
    y += 38;

    // Spawn button — big and prominent
    UIButton *spawnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    spawnBtn.frame = CGRectMake(12, y, w - 24, 48);
    [spawnBtn setTitle:@"SPAWN" forState:UIControlStateNormal];
    spawnBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
    spawnBtn.backgroundColor = P7_CYAN;
    [spawnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    spawnBtn.layer.cornerRadius = 14;
    [spawnBtn addTarget:self action:@selector(p7_spawnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.mainInner addSubview:spawnBtn];
    y += 56;

    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, y, w - 24, 18)];
    self.locationLabel.text = @"Location: Center of Spawn";
    self.locationLabel.font = [UIFont fontWithName:@"Menlo" size:10];
    self.locationLabel.textColor = P7_SUBTEXT;
    [self.mainInner addSubview:self.locationLabel];
    y += 24;

    // Favorites section
    UILabel *favSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 200, 22)];
    favSectionLabel.text = @"Favorites";
    favSectionLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    favSectionLabel.textColor = P7_AMBER;
    [self.mainInner addSubview:favSectionLabel];
    y += 26;

    self.favoritesTable = [[UITableView alloc] initWithFrame:CGRectMake(12, y, w - 24, 100) style:UITableViewStylePlain];
    self.favoritesTable.backgroundColor = P7_CARD;
    self.favoritesTable.layer.cornerRadius = 10;
    self.favoritesTable.dataSource = self;
    self.favoritesTable.delegate = self;
    self.favoritesTable.tag = 999;
    [self.mainInner addSubview:self.favoritesTable];
    y += 110;

    self.mainScroll.contentSize = CGSizeMake(w, 2800);
}

- (void)p7_buildShapesContent {
    CGFloat w = self.mainInner.bounds.size.width;
    CGFloat y = 820;  // below Items content
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(12, y, w - 24, 24)];
    header.text = @"Spawn shapes";
    header.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    header.textColor = P7_CYAN;
    [self.mainInner addSubview:header];
    y += 32;

    NSArray *shapes = @[@"❤️ Heart", @"⭕ Circle", @"🗼 Tower", @"🧱 Wall", @"🌀 Spiral", @"⭐ Star", @"⬡ Hexagon", @"💥 Bomb", @"👾 Monster Wave"];
    SEL actions[] = {
        @selector(p7_shapeHeart), @selector(p7_shapeCircle), @selector(p7_shapeTower), @selector(p7_shapeWall),
        @selector(p7_shapeSpiral), @selector(p7_shapeStar), @selector(p7_shapeHexagon), @selector(p7_shapeBomb),
        @selector(p7_shapeMonsterWave),
    };
    for (NSUInteger i = 0; i < shapes.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(12, y + i * 42, w - 24, 38);
        [btn setTitle:shapes[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        btn.backgroundColor = P7_CARD;
        btn.layer.cornerRadius = 12;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [P7_MAGENTA colorWithAlphaComponent:0.4].CGColor;
        [btn setTitleColor:P7_TEXT forState:UIControlStateNormal];
        [btn addTarget:self action:actions[i] forControlEvents:UIControlEventTouchUpInside];
        [self.mainInner addSubview:btn];
    }
}

- (void)p7_buildExperimentsContent {
    CGFloat w = self.mainInner.bounds.size.width;
    CGFloat y = 1240;  // below Shapes
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(12, y, w - 24, 24)];
    header.text = @"Experiment presets";
    header.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    header.textColor = P7_MAGENTA;
    [self.mainInner addSubview:header];
    y += 32;

    NSArray *exps = @[@"Crossbow Rain", @"Snowball Fight", @"Weapon Cache", @"Loot Explosion", @"Diamond Shower", @"Money Rain", @"Food Feast", @"Shield Wall", @"Fishing Frenzy", @"Trophy Shower", @"Mine Field", @"Jetpack Rain", @"Ball Pit", @"Boombox Party", @"Arrow Rain", @"Sword Circle"];
    for (NSUInteger i = 0; i < exps.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(12 + (i % 2) * ((w - 28) / 2 + 4), y + (i / 2) * 40, (w - 28) / 2, 36);
        [btn setTitle:exps[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.backgroundColor = P7_CARD;
        btn.layer.cornerRadius = 10;
        [btn setTitleColor:P7_TEXT forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(p7_experimentTapped:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.mainInner addSubview:btn];
    }
}

- (void)p7_buildLocationsContent {
    CGFloat w = self.mainInner.bounds.size.width;
    CGFloat y = 1660;  // below Experiments

    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(12, y, w - 24, 24)];
    header.text = @"Spawn location";
    header.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    header.textColor = P7_AMBER;
    [self.mainInner addSubview:header];
    y += 32;

    UIButton *playerPosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playerPosBtn.frame = CGRectMake(12, y, w - 24, 44);
    [playerPosBtn setTitle:@"Use my current position" forState:UIControlStateNormal];
    playerPosBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    playerPosBtn.backgroundColor = P7_CARD;
    playerPosBtn.layer.cornerRadius = 12;
    [playerPosBtn setTitleColor:P7_CYAN forState:UIControlStateNormal];
    [playerPosBtn addTarget:self action:@selector(p7_usePlayerPosition) forControlEvents:UIControlEventTouchUpInside];
    [self.mainInner addSubview:playerPosBtn];
    y += 52;

    int presetCount = P7GetPresetCount();
    for (int i = 0; i < presetCount; i++) {
        const char *name = NULL;
        float pos[3];
        P7GetPresetPosition(i, pos, &name);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(12, y, w - 24, 38);
        [btn setTitle:[NSString stringWithUTF8String:name ? name : "Unknown"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.backgroundColor = P7_CARD;
        btn.layer.cornerRadius = 10;
        [btn setTitleColor:P7_TEXT forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(p7_presetTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainInner addSubview:btn];
        y += 42;
    }
}

- (void)p7_buildAdminContent {
    CGFloat w = self.mainInner.bounds.size.width;
    CGFloat y = 2100;  // below Locations

    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(12, y, w - 24, 24)];
    header.text = @"Admin (power actions)";
    header.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    header.textColor = [UIColor colorWithRed:1 green:0.3 blue:0.3 alpha:1];
    [self.mainInner addSubview:header];
    y += 32;

    NSArray *adminTitles = @[@"God Kit", @"Giveaway Bag", @"Money Printer", @"NUKE ZONE", @"Infinite Flare", @"Spawn 100 selected", @"Spawn ALL items (1 each)"];
    SEL adminActions[] = {
        @selector(p7_adminGodKit), @selector(p7_adminGiveaway), @selector(p7_adminMoney), @selector(p7_adminNuke),
        @selector(p7_adminFlare), @selector(p7_adminSpawn100), @selector(p7_adminSpawnAll),
    };
    for (NSUInteger i = 0; i < adminTitles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(12, y, w - 24, 44);
        [btn setTitle:adminTitles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        btn.backgroundColor = (i >= 3) ? [UIColor colorWithRed:0.2 green:0.05 blue:0.05 alpha:1] : P7_CARD;
        btn.layer.cornerRadius = 12;
        [btn setTitleColor:P7_TEXT forState:UIControlStateNormal];
        [btn addTarget:self action:adminActions[i] forControlEvents:UIControlEventTouchUpInside];
        [self.mainInner addSubview:btn];
        y += 48;
    }
}

- (void)p7_buildSettingsContent {
    CGFloat w = self.mainInner.bounds.size.width;
    CGFloat y = 2580;  // below Admin

    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(12, y, w - 24, 24)];
    header.text = @"Settings";
    header.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    header.textColor = P7_SUBTEXT;
    [self.mainInner addSubview:header];
    y += 32;

    UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceBtn.frame = CGRectMake(12, y, w - 24, 44);
    [voiceBtn setTitle:@"🎤 Voice command" forState:UIControlStateNormal];
    voiceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    voiceBtn.backgroundColor = P7_CARD;
    voiceBtn.layer.cornerRadius = 12;
    [voiceBtn setTitleColor:P7_TEXT forState:UIControlStateNormal];
    [voiceBtn addTarget:self action:@selector(p7_voiceTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.mainInner addSubview:voiceBtn];
    y += 52;

    UIButton *jsonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jsonBtn.frame = CGRectMake(12, y, w - 24, 44);
    [jsonBtn setTitle:@"📂 Load JSON spawn list" forState:UIControlStateNormal];
    jsonBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    jsonBtn.backgroundColor = P7_CARD;
    jsonBtn.layer.cornerRadius = 12;
    [jsonBtn setTitleColor:P7_TEXT forState:UIControlStateNormal];
    [jsonBtn addTarget:self action:@selector(p7_loadJSON) forControlEvents:UIControlEventTouchUpInside];
    [self.mainInner addSubview:jsonBtn];
}

- (NSArray *)p7_currentList {
    NSArray *source = (self.activeTab == P7TabMonsters) ? P7GetAllMonsters() : P7GetAllItems();
    if (self.activeTab != P7TabMonsters && self.activeCategory != P7CategoryAll) {
        // Simple category filter by prefix
        NSString *search = self.searchField.text.lowercaseString;
        if (search.length > 0) {
            NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", search];
            source = [source filteredArrayUsingPredicate:p];
        }
        return source;
    }
    NSString *search = self.searchField.text.lowercaseString;
    if (search.length > 0) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", search];
        source = [source filteredArrayUsingPredicate:p];
    }
    return source;
}

- (NSString *)p7_selectedName {
    NSArray *list = [self p7_currentList];
    if (self.selectedIndex < (NSInteger)list.count) return list[self.selectedIndex];
    return list.firstObject;
}

- (void)p7_log:(NSString *)msg {
    self.logView.text = [self.logView.text stringByAppendingFormat:@"\n%@", msg];
    [self.logView scrollRangeToVisible:NSMakeRange(self.logView.text.length - 1, 1)];
}

- (void)p7_updateTabAppearance {
    for (NSUInteger i = 0; i < self.tabButtons.count; i++) {
        UIButton *b = self.tabButtons[i];
        if ((NSInteger)i == self.activeTab) {
            b.backgroundColor = P7_CYAN;
            [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else {
            b.backgroundColor = P7_CARD;
            [b setTitleColor:P7_TEXT forState:UIControlStateNormal];
        }
    }
}

- (void)p7_showTabContent {
    CGFloat sectionY[] = { 0, 0, 820, 1240, 1660, 2100, 2580 };
    CGFloat y = sectionY[self.activeTab];
    [self.mainScroll setContentOffset:CGPointMake(0, y) animated:YES];
}

- (void)p7_switchTab:(UIButton *)sender {
    self.activeTab = sender.tag;
    [self p7_updateTabAppearance];
    [self p7_showTabContent];
    if (self.activeTab == P7TabItems || self.activeTab == P7TabMonsters) {
        [self p7_searchChanged];
    }
}

- (void)p7_categoryTapped:(UIButton *)sender {
    self.activeCategory = sender.tag;
    [self p7_searchChanged];
}

- (void)p7_searchChanged {
    self.selectedIndex = 0;
    [self.tableView reloadData];
    NSArray *list = [self p7_currentList];
    self.itemCountLabel.text = [NSString stringWithFormat:@"%lu items", (unsigned long)list.count];
}

- (void)p7_increaseQty { self.spawnQuantity++; self.quantityLabel.text = [NSString stringWithFormat:@"%ld", (long)self.spawnQuantity]; }
- (void)p7_decreaseQty { if (self.spawnQuantity > 1) { self.spawnQuantity--; self.quantityLabel.text = [NSString stringWithFormat:@"%ld", (long)self.spawnQuantity]; } }

- (void)p7_colorToggled {
    P7SetColorEnabled(self.colorSwitch.isOn);
    [self p7_log:self.colorSwitch.isOn ? @"Color spawn ON" : @"Color spawn OFF"];
}
- (void)p7_colorChanged {
    int h = (int)self.hueSlider.value;
    int s = (int)self.satSlider.value;
    P7SetColorHue(h);
    P7SetColorSat(s);
    self.colorPreview.backgroundColor = [UIColor colorWithHue:h/360.0f saturation:s/100.0f brightness:1.0f alpha:1.0f];
}

- (void)p7_addFavorite {
    NSString *name = [self p7_selectedName];
    if (!name.length) return;
    if (![self.favorites containsObject:name]) {
        [self.favorites addObject:name];
        [self.favoritesTable reloadData];
        [self p7_log:[NSString stringWithFormat:@"Added to favorites: %@", name]];
    }
}

- (void)p7_quickSlotTapped:(UIButton *)sender {
    NSInteger idx = sender.tag;
    NSString *current = [self p7_selectedName];
    if (!current.length) return;
    if ([self.quickSlotItems[idx] isEqualToString:current]) {
        // Spawn
        float pos[3];
        P7GetSpawnPosition(pos);
        if (self.activeTab == P7TabMonsters)
            P7SpawnMonster(current, 1, pos);
        else
            P7SpawnItem(current, 1, pos);
        [self p7_log:[NSString stringWithFormat:@"Quick spawn: %@", current]];
    } else {
        self.quickSlotItems[idx] = current ?: @"";
        [sender setTitle:current.length > 10 ? [[current substringToIndex:10] stringByAppendingString:@"…"] : current forState:UIControlStateNormal];
        [self p7_log:[NSString stringWithFormat:@"Slot %ld set to %@", (long)(idx+1), current]];
    }
}

- (void)p7_spawnTapped {
    NSString *name = [self p7_selectedName];
    if (!name.length) return;
    float pos[3];
    P7GetSpawnPosition(pos);
    P7SetColorEnabled(self.colorSwitch.isOn);
    P7SetRandomColor(self.randomColorSwitch.isOn);
    P7SetColorHue((int)self.hueSlider.value);
    P7SetColorSat((int)self.satSlider.value);

    if (self.activeTab == P7TabMonsters) {
        P7SpawnMonster(name, (int)self.spawnQuantity, pos);
        [self p7_log:[NSString stringWithFormat:@"Spawned %@ x%d", name, (int)self.spawnQuantity]];
    } else {
        P7SpawnItem(name, (int)self.spawnQuantity, pos);
        [self p7_log:[NSString stringWithFormat:@"Spawned %@ x%d", name, (int)self.spawnQuantity]];
    }
    if (![self.recentSpawns containsObject:name]) {
        [self.recentSpawns insertObject:name atIndex:0];
        if (self.recentSpawns.count > 20) [self.recentSpawns removeLastObject];
    }
}

- (void)p7_usePlayerPosition {
    float pos[3];
    if (P7GetLocalPlayerPosition(pos)) {
        P7SetSpawnPosition(pos[0], pos[1], pos[2]);
        self.locationLabel.text = [NSString stringWithFormat:@"Location: Player (%.1f, %.1f, %.1f)", pos[0], pos[1], pos[2]];
        [self p7_log:@"Using player position"];
    } else {
        [self p7_log:@"Could not get player position"];
    }
}

- (void)p7_presetTapped:(UIButton *)sender {
    int idx = (int)sender.tag;
    const char *name = NULL;
    float pos[3];
    P7GetPresetPosition(idx, pos, &name);
    if (name && strcmp(name, "Local") == 0) {
        [self p7_usePlayerPosition];
        return;
    }
    P7SetSpawnPosition(pos[0], pos[1], pos[2]);
    self.locationLabel.text = [NSString stringWithFormat:@"Location: %s", name ? name : "?"];
    [self p7_log:[NSString stringWithUTF8String:name ? name : "Preset"]];
}

- (void)p7_shapeHeart  { float p[3]; P7GetSpawnPosition(p); P7SpawnHeart([self p7_selectedName], p, 30); [self p7_log:@"Heart done"]; }
- (void)p7_shapeCircle { float p[3]; P7GetSpawnPosition(p); P7SpawnCircle([self p7_selectedName], p, 24, 5.0f); [self p7_log:@"Circle done"]; }
- (void)p7_shapeTower  { float p[3]; P7GetSpawnPosition(p); P7SpawnTower([self p7_selectedName], p, 20); [self p7_log:@"Tower done"]; }
- (void)p7_shapeWall   { float p[3]; P7GetSpawnPosition(p); P7SpawnWall([self p7_selectedName], p); [self p7_log:@"Wall done"]; }
- (void)p7_shapeSpiral { float p[3]; P7GetSpawnPosition(p); P7SpawnSpiral([self p7_selectedName], p, 50); [self p7_log:@"Spiral done"]; }
- (void)p7_shapeStar   { float p[3]; P7GetSpawnPosition(p); P7SpawnStar([self p7_selectedName], p); [self p7_log:@"Star done"]; }
- (void)p7_shapeHexagon{ float p[3]; P7GetSpawnPosition(p); P7SpawnHexagon([self p7_selectedName], p, 4.0f); [self p7_log:@"Hexagon done"]; }
- (void)p7_shapeBomb   { float p[3]; P7GetSpawnPosition(p); P7SpawnBomb(p); [self p7_log:@"Bomb done"]; }
- (void)p7_shapeMonsterWave { float p[3]; P7GetSpawnPosition(p); P7SpawnMonsterWave(p); [self p7_log:@"Monster wave done"]; }

- (void)p7_experimentTapped:(UIButton *)sender {
    float p[3];
    P7GetSpawnPosition(p);
    // Map to similar admin/experiment actions
    if (sender.tag == 4) P7SpawnGiveawayBag(p);
    else if (sender.tag == 5) P7SpawnMoneyPrinter(p);
    else P7SpawnBomb(p);
    [self p7_log:@"Experiment fired"];
}

- (void)p7_adminGodKit    { float p[3]; P7GetSpawnPosition(p); P7SpawnGodKit(p); [self p7_log:@"God Kit"]; }
- (void)p7_adminGiveaway  { float p[3]; P7GetSpawnPosition(p); P7SpawnGiveawayBag(p); [self p7_log:@"Giveaway Bag"]; }
- (void)p7_adminMoney     { float p[3]; P7GetSpawnPosition(p); P7SpawnMoneyPrinter(p); [self p7_log:@"Money Printer"]; }
- (void)p7_adminNuke      { float p[3]; P7GetSpawnPosition(p); P7SpawnNukeZone(p); [self p7_log:@"NUKE ZONE"]; }
- (void)p7_adminFlare     { float p[3]; P7GetSpawnPosition(p); P7SpawnInfiniteFlare(p); [self p7_log:@"Infinite Flare"]; }
- (void)p7_adminSpawn100  {
    NSString *n = [self p7_selectedName];
    if (!n.length) return;
    float p[3]; P7GetSpawnPosition(p);
    P7SpawnItem(n, 100, p);
    [self p7_log:[NSString stringWithFormat:@"Spawned %@ x100", n]];
}
- (void)p7_adminSpawnAll  {
    float p[3]; P7GetSpawnPosition(p);
    for (NSString *item in P7GetAllItems()) P7SpawnItem(item, 1, p);
    [self p7_log:@"Spawned ALL items"];
}

- (void)p7_voiceTapped { [self p7_log:@"Voice: Hold for speech (implement SFSpeechRecognizer)"]; }
- (void)p7_loadJSON {
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:@[[UTType typeWithIdentifier:@"public.json"]] asCopy:YES];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *url = urls.firstObject;
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data) { [self p7_log:@"Failed to read JSON"]; return; }
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    if (!arr.count) { [self p7_log:@"No items in JSON"]; return; }
    float pos[3]; P7GetSpawnPosition(pos);
    for (NSDictionary *d in arr) {
        NSString *id_ = d[@"itemID"] ?: d[@"id"] ?: d[@"name"];
        if ([id_ isKindOfClass:[NSString class]]) P7SpawnItem(id_, 1, pos);
    }
    [self p7_log:[NSString stringWithFormat:@"Loaded %lu from JSON", (unsigned long)arr.count]];
}

- (void)p7_dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.panelView.alpha = 0;
        self.panelView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL f) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

// Table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 999) return (NSInteger)self.favorites.count;
    return [self p7_currentList].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"P7Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"P7Cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = P7_TEXT;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    if (tableView.tag == 999) {
        cell.textLabel.text = self.favorites[indexPath.row];
    } else {
        NSArray *list = [self p7_currentList];
        cell.textLabel.text = list[indexPath.row];
        cell.contentView.backgroundColor = (indexPath.row == self.selectedIndex) ? [P7_CYAN colorWithAlphaComponent:0.2] : [UIColor clearColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 999) {
        NSString *fav = self.favorites[indexPath.row];
        NSUInteger idx = [[self p7_currentList] indexOfObject:fav];
        if (idx != NSNotFound) { self.selectedIndex = (NSInteger)idx; [self.tableView reloadData]; }
        return;
    }
    self.selectedIndex = indexPath.row;
    [tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 36; }

- (BOOL)textFieldShouldReturn:(UITextField *)textField { [textField resignFirstResponder]; return YES; }
- (BOOL)prefersStatusBarHidden { return YES; }
- (UIInterfaceOrientationMask)supportedInterfaceOrientations { return UIInterfaceOrientationMaskAll; }

@end

// =============================================================================
#pragma mark - P7 Entry & Menu Button
// =============================================================================

__attribute__((constructor))
static void P7Init(void) {
    P7LoadItemDatabase();
    P7LoadCategoryPrefixes();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!P7InitRuntime()) {
            NSLog(@"[P7] Runtime init failed");
            return;
        }
        float pos[3] = {-2.0f, 2.5f, 0.0f};
        P7SetSpawnPosition(pos[0], pos[1], pos[2]);

        UIWindowScene *scene = (UIWindowScene *)UIApplication.sharedApplication.connectedScenes.anyObject;
        UIWindow *window = nil;
        for (UIWindow *w in scene.windows) { if (w.isKeyWindow) { window = w; break; } }
        if (!window) return;

        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.frame = CGRectMake(20, 100, 56, 56);
        menuBtn.backgroundColor = [P7_CYAN colorWithAlphaComponent:0.9];
        menuBtn.layer.cornerRadius = 28;
        menuBtn.layer.borderWidth = 2;
        menuBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        menuBtn.layer.shadowColor = P7_CYAN.CGColor;
        menuBtn.layer.shadowRadius = 12;
        menuBtn.layer.shadowOpacity = 0.8;
        [menuBtn setTitle:@"P7" forState:UIControlStateNormal];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
        [menuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuBtn addTarget:menuBtn action:@selector(p7_openMenu) forControlEvents:UIControlEventTouchUpInside];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:menuBtn action:@selector(p7_handlePan:)];
        [menuBtn addGestureRecognizer:pan];
        [window addSubview:menuBtn];
    });
}

// Need to expose openMenu - use a class that can hold the action
@interface P7MenuLauncher : NSObject
+ (void)openMenu;
@end
@implementation P7MenuLauncher
+ (void)openMenu {
    UIWindowScene *scene = (UIWindowScene *)UIApplication.sharedApplication.connectedScenes.anyObject;
    UIWindow *window = nil;
    for (UIWindow *w in scene.windows) { if (w.isKeyWindow) { window = w; break; } }
    if (!window) return;
    UIViewController *root = window.rootViewController;
    while (root.presentedViewController) root = root.presentedViewController;
    P7PanelController *panel = [[P7PanelController alloc] init];
    panel.modalPresentationStyle = UIModalPresentationOverFullScreen;
    panel.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [root presentViewController:panel animated:YES completion:nil];
}
@end

// Add category to UIButton so we can attach openMenu
@implementation UIButton (P7)
- (void)p7_openMenu { [P7MenuLauncher openMenu]; }
- (void)p7_handlePan:(UIPanGestureRecognizer *)gesture {
    UIView *v = gesture.view;
    CGPoint tr = [gesture translationInView:v.superview];
    v.center = CGPointMake(v.center.x + tr.x, v.center.y + tr.y);
    [gesture setTranslation:CGPointZero inView:v.superview];
}
@end
