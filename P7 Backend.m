// =============================================================================
// P7.dylib — Game Menu Backend
// Target: Animal Company (Unity/IL2CPP, iOS arm64, jailbroken)
// Loader: Injected via /var/jb/ tweak injection
// =============================================================================

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>

// =============================================================================
#pragma mark - IL2CPP Runtime Types & Function Pointers
// =============================================================================

typedef void* Il2CppDomain;
typedef void* Il2CppAssembly;
typedef void* Il2CppImage;
typedef void* Il2CppClass;
typedef void* Il2CppMethodInfo;
typedef void* Il2CppObject;
typedef void* Il2CppString;
typedef void* Il2CppType;
typedef void* Il2CppFieldInfo;
typedef void* Il2CppReflectionType;
typedef void* Il2CppArray;

typedef Il2CppDomain      (*il2cpp_domain_get_t)(void);
typedef Il2CppAssembly**   (*il2cpp_domain_get_assemblies_t)(Il2CppDomain domain, size_t *count);
typedef Il2CppImage*       (*il2cpp_assembly_get_image_t)(Il2CppAssembly *assembly);
typedef const char*        (*il2cpp_image_get_name_t)(Il2CppImage *image);
typedef Il2CppClass*       (*il2cpp_class_from_name_t)(Il2CppImage *image, const char *ns, const char *name);
typedef Il2CppMethodInfo*  (*il2cpp_class_get_method_from_name_t)(Il2CppClass *klass, const char *name, int argc);
typedef Il2CppString*      (*il2cpp_string_new_t)(const char *str);
typedef Il2CppObject*      (*il2cpp_runtime_invoke_t)(Il2CppMethodInfo *method, void *obj, void **params, void **exc);
typedef void*              (*il2cpp_resolve_icall_t)(const char *name);
typedef Il2CppFieldInfo*   (*il2cpp_class_get_field_from_name_t)(Il2CppClass *klass, const char *name);
typedef void               (*il2cpp_field_get_value_t)(Il2CppObject *obj, Il2CppFieldInfo *field, void *value);
typedef void               (*il2cpp_field_set_value_t)(Il2CppObject *obj, Il2CppFieldInfo *field, void *value);
typedef Il2CppType*        (*il2cpp_class_get_type_t)(Il2CppClass *klass);
typedef Il2CppReflectionType* (*il2cpp_type_get_object_t)(Il2CppType *type);
typedef void (*get_position_injected_t)(void *transform, float *outPos);

// =============================================================================
#pragma mark - Global Runtime State
// =============================================================================

static il2cpp_domain_get_t                  g_il2cpp_domain_get;
static il2cpp_domain_get_assemblies_t       g_il2cpp_domain_get_assemblies;
static il2cpp_assembly_get_image_t          g_il2cpp_assembly_get_image;
static il2cpp_image_get_name_t              g_il2cpp_image_get_name;
static il2cpp_class_from_name_t             g_il2cpp_class_from_name;
static il2cpp_class_get_method_from_name_t  g_il2cpp_class_get_method_from_name;
static il2cpp_string_new_t                  g_il2cpp_string_new;
static il2cpp_runtime_invoke_t              g_il2cpp_runtime_invoke;
static il2cpp_resolve_icall_t               g_il2cpp_resolve_icall;
static il2cpp_class_get_field_from_name_t   g_il2cpp_class_get_field_from_name;
static il2cpp_field_get_value_t             g_il2cpp_field_get_value;
static il2cpp_field_set_value_t             g_il2cpp_field_set_value;
static il2cpp_class_get_type_t              g_il2cpp_class_get_type;
static il2cpp_type_get_object_t             g_il2cpp_type_get_object;

static void *g_unityFrameworkHandle;
static Il2CppImage *g_gameImage;
static Il2CppImage *g_engineImage;
static Il2CppClass *g_prefabGeneratorClass;
static Il2CppMethodInfo *g_spawnItem4, *g_spawnItem1, *g_spawnItemAny, *g_spawnItem6;
static Il2CppMethodInfo *g_getItemPrefab, *g_spawnMob5, *g_getMobPrefab, *g_generatePrefab4;
static Il2CppClass *g_objectClass, *g_gameObjectClass, *g_transformClass;
static Il2CppMethodInfo *g_findObjectOfType, *g_findObjectsOfType, *g_getTransform;
static get_position_injected_t g_getPositionInjected;
static Il2CppClass *g_netPlayerClass;
static Il2CppMethodInfo *g_getLocalPlayer, *g_getPlayerName, *g_getPlayers;
static Il2CppClass *g_itemClass;
static Il2CppFieldInfo *g_colorHueField, *g_colorSatField;

static float g_spawnPosition[3] = {0, 0, 0};
static BOOL  g_useCustomPosition = NO;
static BOOL  g_colorEnabled = NO;
static BOOL  g_randomColor = NO;
static int   g_colorHue = 0;
static int   g_colorSat = 100;
static BOOL  g_scaleEnabled = NO;
static float g_scaleValue = 0.0f;
static BOOL  g_ringActive = NO;
static NSTimer *g_ringTimer = nil;

// =============================================================================
#pragma mark - P7 Constants
// =============================================================================

// Tab indices (expanded)
typedef NS_ENUM(NSInteger, P7Tab) {
    P7TabItems = 0, P7TabMonsters = 1, P7TabShapes = 2,
    P7TabExperiments = 3, P7TabLocations = 4, P7TabAdmin = 5, P7TabSettings = 6,
};

typedef NS_ENUM(NSInteger, P7Category) {
    P7CategoryAll = 0, P7CategoryWeapons = 1, P7CategoryRare = 2,
    P7CategoryExplosives = 3, P7CategoryFood = 4, P7CategoryFish = 5,
    P7CategoryBackpacks = 6, P7CategoryQuest = 7,
};

// Extended preset locations
typedef struct { float x, y, z; const char *name; } P7PresetPos;
static const P7PresetPos kP7PresetPositions[] = {
    {  -2.000f,  2.500f,   0.000f,  "Center of Spawn" },
    {   0.000f,  2.500f,   0.000f,  "Origin of Spawn" },
    { -15.000f,  2.500f,  10.000f,  "Lake"             },
    {   0.000f,  0.000f,   0.000f,  "Local"            },
    {  -1.575f,  2.500f, -18.500f,  "Stage 5"          },
    {  95.000f,  2.500f,  50.000f,  "Mautions"         },
    {  -5.000f,  2.500f,  30.000f,  "Stash"            },
    { -40.000f,  2.500f,  60.000f,  "Sell"             },
    { -70.000f,  2.500f,  10.000f,  "Toilet"           },
    {  -1.946f,  2.143f,   0.000f,  "Dupe Machine"     },
    { -20.000f,  2.500f,  25.000f,  "P7 Spot A"        },
    {  10.000f,  2.500f, -10.000f,  "P7 Spot B"        },
    {  50.000f,  2.500f,  80.000f,  "P7 Spot C"        },
};
static const int kP7PresetCount = sizeof(kP7PresetPositions) / sizeof(kP7PresetPositions[0]);

static NSArray *P7_allItems;
static NSArray *P7_allMonsters;

// =============================================================================
#pragma mark - IL2CPP Resolution
// =============================================================================

static void *P7ResolveSymbol(void *handle, const char *name) {
    void *sym = dlsym(handle, name);
    if (!sym) NSLog(@"[P7] Missing: %s", name);
    return sym;
}

static void *P7FindUnityFramework(void) {
    void *handle = dlopen("UnityFramework.framework/UnityFramework", 0x11);
    if (handle) return handle;
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const char *name = _dyld_get_image_name(i);
        if (name && strstr(name, "UnityFramework.framework/UnityFramework")) {
            handle = dlopen(name, 0x11);
            if (handle) return handle;
        }
    }
    return dlopen(NULL, 1);
}

static Il2CppImage *P7FindImage(const char *dllName) {
    Il2CppDomain domain = g_il2cpp_domain_get();
    size_t asmCount = 0;
    Il2CppAssembly **assemblies = g_il2cpp_domain_get_assemblies(domain, &asmCount);
    for (size_t i = 0; i < asmCount; i++) {
        Il2CppImage *img = g_il2cpp_assembly_get_image(assemblies[i]);
        const char *name = g_il2cpp_image_get_name(img);
        if (name && strcmp(name, dllName) == 0) return img;
    }
    return NULL;
}

BOOL P7InitRuntime(void) {
    g_unityFrameworkHandle = P7FindUnityFramework();
    if (!g_unityFrameworkHandle) { NSLog(@"[P7] Unity not found"); return NO; }

    #define RESOLVE(name) g_##name = (name##_t)P7ResolveSymbol(g_unityFrameworkHandle, #name); if (!g_##name) return NO;
    RESOLVE(il2cpp_domain_get);
    RESOLVE(il2cpp_domain_get_assemblies);
    RESOLVE(il2cpp_assembly_get_image);
    RESOLVE(il2cpp_image_get_name);
    RESOLVE(il2cpp_class_from_name);
    RESOLVE(il2cpp_class_get_method_from_name);
    RESOLVE(il2cpp_string_new);
    RESOLVE(il2cpp_runtime_invoke);
    RESOLVE(il2cpp_resolve_icall);
    RESOLVE(il2cpp_class_get_field_from_name);
    RESOLVE(il2cpp_field_get_value);
    RESOLVE(il2cpp_field_set_value);
    RESOLVE(il2cpp_class_get_type);
    RESOLVE(il2cpp_type_get_object);
    #undef RESOLVE

    g_gameImage = P7FindImage("AnimalCompany.dll");
    if (!g_gameImage) g_gameImage = P7FindImage("Assembly-CSharp.dll");
    if (!g_gameImage) { NSLog(@"[P7] Game assembly not found"); return NO; }

    g_engineImage = P7FindImage("UnityEngine.CoreModule.dll");
    if (!g_engineImage) return NO;

    g_prefabGeneratorClass = g_il2cpp_class_from_name(g_gameImage, "", "PrefabGenerator");
    if (g_prefabGeneratorClass) {
        g_spawnItem4    = g_il2cpp_class_get_method_from_name(g_prefabGeneratorClass, "SpawnItem", 4);
        g_spawnItem1    = g_il2cpp_class_get_method_from_name(g_prefabGeneratorClass, "SpawnItem", 1);
        g_spawnItemAny  = g_il2cpp_class_get_method_from_name(g_prefabGeneratorClass, "SpawnItem", -1);
        g_spawnItem6    = g_il2cpp_class_get_method_from_name(g_prefabGeneratorClass, "SpawnItem", 6);
        g_getItemPrefab = g_il2cpp_class_get_method_from_name(g_prefabGeneratorClass, "GetItemPrefab", 1);
        g_spawnMob5     = g_il2cpp_class_get_method_from_name(g_prefabGeneratorClass, "SpawnMob", 5);
        g_getMobPrefab  = g_il2cpp_class_get_method_from_name(g_prefabGeneratorClass, "GetMobPrefab", 1);
        g_generatePrefab4 = g_il2cpp_class_get_method_from_name(g_prefabGeneratorClass, "GeneratePrefab", 4);
    }

    g_objectClass = g_il2cpp_class_from_name(g_engineImage, "UnityEngine", "Object");
    g_gameObjectClass = g_il2cpp_class_from_name(g_engineImage, "UnityEngine", "GameObject");
    g_transformClass  = g_il2cpp_class_from_name(g_engineImage, "UnityEngine", "Transform");
    if (g_objectClass) {
        g_findObjectOfType  = g_il2cpp_class_get_method_from_name(g_objectClass, "FindObjectOfType", 1);
        g_findObjectsOfType = g_il2cpp_class_get_method_from_name(g_objectClass, "FindObjectsOfType", 1);
    }
    if (g_gameObjectClass) g_getTransform = g_il2cpp_class_get_method_from_name(g_gameObjectClass, "get_transform", 0);
    g_getPositionInjected = (get_position_injected_t)g_il2cpp_resolve_icall("UnityEngine.Transform::get_position_Injected(UnityEngine.Vector3&)");

    g_netPlayerClass = g_il2cpp_class_from_name(g_gameImage, "", "NetPlayer");
    if (g_netPlayerClass) {
        g_getLocalPlayer = g_il2cpp_class_get_method_from_name(g_netPlayerClass, "get_localPlayer", 0);
        g_getPlayerName  = g_il2cpp_class_get_method_from_name(g_netPlayerClass, "get_name", 0);
        if (!g_getPlayerName) g_getPlayerName = g_il2cpp_class_get_method_from_name(g_netPlayerClass, "get_playerName", 0);
        g_getPlayers = g_il2cpp_class_get_method_from_name(g_netPlayerClass, "get_players", 0);
    }

    g_itemClass = g_il2cpp_class_from_name(g_gameImage, "", "Item");
    if (!g_itemClass) g_itemClass = g_il2cpp_class_from_name(g_gameImage, "", "ItemInstance");
    if (g_itemClass) {
        g_colorHueField = g_il2cpp_class_get_field_from_name(g_itemClass, "colorHue");
        g_colorSatField = g_il2cpp_class_get_field_from_name(g_itemClass, "colorSaturation");
    }
    return YES;
}

// =============================================================================
#pragma mark - PrefabGenerator & Player Position
// =============================================================================

static Il2CppObject *P7GetPrefabGenerator(void) {
    if (!g_prefabGeneratorClass || !g_findObjectOfType) return NULL;
    Il2CppType *type = g_il2cpp_class_get_type(g_prefabGeneratorClass);
    Il2CppReflectionType *typeObj = g_il2cpp_type_get_object(type);
    void *params[] = { typeObj };
    Il2CppObject *exc = NULL;
    return g_il2cpp_runtime_invoke(g_findObjectOfType, NULL, params, (void**)&exc);
}

BOOL P7GetLocalPlayerPosition(float outPos[3]) {
    if (!g_getLocalPlayer || !g_getTransform || !g_getPositionInjected) return NO;
    Il2CppObject *exc = NULL;
    Il2CppObject *localPlayer = g_il2cpp_runtime_invoke(g_getLocalPlayer, NULL, NULL, (void**)&exc);
    if (!localPlayer) return NO;
    Il2CppObject *transform = g_il2cpp_runtime_invoke(g_getTransform, localPlayer, NULL, (void**)&exc);
    if (!transform) return NO;
    g_getPositionInjected(transform, outPos);
    return YES;
}

void P7SetSpawnPosition(float x, float y, float z) {
    g_spawnPosition[0] = x; g_spawnPosition[1] = y; g_spawnPosition[2] = z;
    g_useCustomPosition = YES;
}
void P7GetSpawnPosition(float out[3]) {
    out[0] = g_spawnPosition[0]; out[1] = g_spawnPosition[1]; out[2] = g_spawnPosition[2];
}
void P7SetColorEnabled(BOOL on) { g_colorEnabled = on; }
void P7SetRandomColor(BOOL on) { g_randomColor = on; }
void P7SetColorHue(int h) { g_colorHue = h; }
void P7SetColorSat(int s) { g_colorSat = s; }

// =============================================================================
#pragma mark - Spawn Engine
// =============================================================================

BOOL P7SpawnItem(NSString *itemName, int quantity, float pos[3]) {
    Il2CppObject *prefabGen = P7GetPrefabGenerator();
    if (!prefabGen) return NO;
    Il2CppString *nameStr = g_il2cpp_string_new(itemName.UTF8String);
    Il2CppObject *exc = NULL;

    for (int q = 0; q < quantity; q++) {
        BOOL spawned = NO;
        if (g_spawnItem4) {
            float px = pos[0] + (arc4random_uniform(200) - 100) * 0.01f;
            float pz = pos[2] + (arc4random_uniform(200) - 100) * 0.01f;
            float p[3] = { px, pos[1], pz };
            void *params[] = { nameStr, &p[0], &p[1], &p[2] };
            g_il2cpp_runtime_invoke(g_spawnItem4, prefabGen, params, (void**)&exc);
            if (!exc) spawned = YES;
        }
        if (!spawned && g_spawnItem1) {
            void *params[] = { nameStr };
            g_il2cpp_runtime_invoke(g_spawnItem1, prefabGen, params, (void**)&exc);
            if (!exc) spawned = YES;
        }
        if (!spawned && g_spawnItem6 && g_colorEnabled) {
            int hue = g_randomColor ? (int)arc4random_uniform(360) : g_colorHue;
            int sat = g_colorSat;
            void *params[] = { nameStr, &pos[0], &pos[1], &pos[2], &hue, &sat };
            g_il2cpp_runtime_invoke(g_spawnItem6, prefabGen, params, (void**)&exc);
            if (!exc) spawned = YES;
        }
        if (!spawned && g_generatePrefab4 && g_getItemPrefab) {
            void *prefabParams[] = { nameStr };
            Il2CppObject *prefab = g_il2cpp_runtime_invoke(g_getItemPrefab, prefabGen, prefabParams, (void**)&exc);
            if (prefab && !exc) {
                void *genParams[] = { prefab, &pos[0], &pos[1], &pos[2] };
                g_il2cpp_runtime_invoke(g_generatePrefab4, prefabGen, genParams, (void**)&exc);
                if (!exc) spawned = YES;
            }
        }
    }
    return YES;
}

BOOL P7SpawnMonster(NSString *controllerName, int quantity, float pos[3]) {
    Il2CppObject *prefabGen = P7GetPrefabGenerator();
    if (!prefabGen) return NO;
    NSString *shortName = [controllerName hasSuffix:@"Controller"] ? [controllerName substringToIndex:controllerName.length - 10] : controllerName;
    Il2CppObject *exc = NULL;

    for (int q = 0; q < quantity; q++) {
        BOOL spawned = NO;
        if (g_spawnMob5) {
            Il2CppString *nameStr = g_il2cpp_string_new(controllerName.UTF8String);
            int mobId = 0;
            void *params[] = { nameStr, &pos[0], &pos[1], &pos[2], &mobId };
            g_il2cpp_runtime_invoke(g_spawnMob5, prefabGen, params, (void**)&exc);
            if (!exc) spawned = YES;
        }
        if (!spawned && g_spawnItem4) {
            Il2CppString *nameStr = g_il2cpp_string_new(controllerName.UTF8String);
            void *params[] = { nameStr, &pos[0], &pos[1], &pos[2] };
            g_il2cpp_runtime_invoke(g_spawnItem4, prefabGen, params, (void**)&exc);
            if (!exc) spawned = YES;
        }
        if (!spawned && g_spawnItem4 && ![shortName isEqualToString:controllerName]) {
            Il2CppString *nameStr = g_il2cpp_string_new(shortName.UTF8String);
            void *params[] = { nameStr, &pos[0], &pos[1], &pos[2] };
            g_il2cpp_runtime_invoke(g_spawnItem4, prefabGen, params, (void**)&exc);
            if (!exc) spawned = YES;
        }
    }
    return YES;
}

// =============================================================================
#pragma mark - Shape Generators
// =============================================================================

void P7SpawnHeart(NSString *itemName, float center[3], int numPoints) {
    for (int i = 0; i < numPoints; i++) {
        float t = (float)i / numPoints * 2.0f * (float)M_PI;
        float st = sinf(t);
        float x = 16.0f * st * st * st;
        float y = 13.0f * cosf(t) - 5.0f * cosf(2*t) - 2.0f * cosf(3*t) - cosf(4*t);
        float pos[3] = { center[0] + x * 0.15f, center[1] + y * 0.15f + 3.0f, center[2] };
        P7SpawnItem(itemName, 1, pos);
    }
}
void P7SpawnCircle(NSString *itemName, float center[3], int numPoints, float radius) {
    for (int i = 0; i < numPoints; i++) {
        float angle = (float)i / numPoints * 2.0f * (float)M_PI;
        float pos[3] = { center[0] + cosf(angle) * radius, center[1], center[2] + sinf(angle) * radius };
        P7SpawnItem(itemName, 1, pos);
    }
}
void P7SpawnTower(NSString *itemName, float base[3], int height) {
    for (int i = 0; i < height; i++) {
        float pos[3] = { base[0], base[1] + i * 0.5f, base[2] };
        P7SpawnItem(itemName, 1, pos);
    }
}
void P7SpawnWall(NSString *itemName, float base[3]) {
    for (int row = 0; row < 5; row++)
        for (int col = 0; col < 5; col++) {
            float pos[3] = { base[0] + col * 0.6f, base[1] + row * 0.6f, base[2] };
            P7SpawnItem(itemName, 1, pos);
        }
}
void P7SpawnSpiral(NSString *itemName, float center[3], int numPoints) {
    for (int i = 0; i < numPoints; i++) {
        float t = (float)i / numPoints * 6.0f * (float)M_PI;
        float r = 0.5f + (float)i / numPoints * 5.0f;
        float pos[3] = { center[0] + cosf(t) * r, center[1] + (float)i * 0.1f, center[2] + sinf(t) * r };
        P7SpawnItem(itemName, 1, pos);
    }
}
void P7SpawnStar(NSString *itemName, float center[3]) {
    for (int i = 0; i < 5; i++) {
        float angle = (float)i / 5.0f * 2.0f * (float)M_PI - (float)M_PI / 2;
        float pos[3] = { center[0] + cosf(angle) * 4.0f, center[1], center[2] + sinf(angle) * 4.0f };
        P7SpawnItem(itemName, 1, pos);
        float innerAngle = angle + (float)M_PI / 5;
        float ipos[3] = { center[0] + cosf(innerAngle) * 1.5f, center[1], center[2] + sinf(innerAngle) * 1.5f };
        P7SpawnItem(itemName, 1, ipos);
    }
}
void P7SpawnHexagon(NSString *itemName, float center[3], float radius) {
    for (int i = 0; i < 6; i++) {
        float angle = (float)i / 6.0f * 2.0f * (float)M_PI;
        float pos[3] = { center[0] + cosf(angle) * radius, center[1], center[2] + sinf(angle) * radius };
        P7SpawnItem(itemName, 1, pos);
    }
}
void P7SpawnBomb(float center[3]) {
    for (int i = 0; i < 50; i++) {
        NSUInteger idx = arc4random_uniform((uint32_t)P7_allItems.count);
        float pos[3] = {
            center[0] + (arc4random_uniform(2000) - 1000) * 0.01f,
            center[1] + arc4random_uniform(500) * 0.01f,
            center[2] + (arc4random_uniform(2000) - 1000) * 0.01f
        };
        P7SpawnItem(P7_allItems[idx], 1, pos);
    }
}
void P7SpawnMonsterWave(float pos[3]) {
    for (NSString *monster in P7_allMonsters) {
        float mpos[3] = {
            pos[0] + (arc4random_uniform(1000) - 500) * 0.01f,
            pos[1], pos[2] + (arc4random_uniform(1000) - 500) * 0.01f
        };
        P7SpawnMonster(monster, 1, mpos);
    }
}

// =============================================================================
#pragma mark - Admin Presets
// =============================================================================

void P7SpawnGodKit(float pos[3]) {
    NSArray *items = @[
        @"item_rpg", @"item_grenade_launcher", @"item_great_sword", @"item_hookshot_sword",
        @"item_shield_viking_4", @"item_teleport_gun", @"item_hoverpad", @"item_backpack_mega",
        @"item_jetpack", @"item_flamethrower_skull_ruby", @"item_demon_sword",
        @"item_shotgun", @"item_revolver_gold", @"item_alphablade", @"item_bloodlust_vial",
    ];
    for (NSString *item in items) P7SpawnItem(item, 1, pos);
}
void P7SpawnGiveawayBag(float pos[3]) {
    NSArray *items = @[
        @"item_goldbar", @"item_randombox_base", @"item_rare_card", @"item_ruby",
        @"item_goldcoin", @"item_diamond_jade_koi", @"item_stellarsword_gold",
        @"item_jetpack", @"item_flamethrower_skull_ruby", @"item_demon_sword",
    ];
    for (NSString *item in items) P7SpawnItem(item, 1, pos);
}
void P7SpawnMoneyPrinter(float pos[3]) {
    P7SpawnItem(@"item_goldbar", 10, pos);
    P7SpawnItem(@"item_goldcoin", 10, pos);
    P7SpawnItem(@"item_moneygun", 5, pos);
}
void P7SpawnNukeZone(float pos[3]) {
    NSArray *explosives = @[
        @"item_dynamite", @"item_grenade", @"item_cluster_grenade", @"item_pumpkin_bomb",
        @"item_landmine", @"item_sticky_dynamite", @"item_timebomb", @"item_flashbang",
    ];
    for (int i = 0; i < 40; i++) {
        NSString *item = explosives[arc4random_uniform((uint32_t)explosives.count)];
        float rainPos[3] = {
            pos[0] + (arc4random_uniform(2000) - 1000) * 0.01f,
            pos[1] + 8.0f + arc4random_uniform(400) * 0.01f,
            pos[2] + (arc4random_uniform(2000) - 1000) * 0.01f
        };
        P7SpawnItem(item, 1, rainPos);
    }
}
void P7SpawnInfiniteFlare(float pos[3]) {
    P7SpawnItem(@"item_flaregun", 3, pos);
    P7SpawnItem(@"item_rpg_ammo", 20, pos);
    P7SpawnItem(@"item_shotgun_ammo", 20, pos);
    P7SpawnItem(@"item_revolver_ammo", 20, pos);
}

// =============================================================================
#pragma mark - Item & Monster Database
// =============================================================================

void P7LoadItemDatabase(void) {
    P7_allItems = @[
        @"item_goldbar", @"item_randombox_base", @"item_rare_card", @"item_ruby",
        @"item_goldcoin", @"item_diamond_jade_koi", @"item_stellarsword_gold",
        @"item_jetpack", @"item_flamethrower_skull_ruby", @"item_demon_sword",
        @"item_flaregun", @"item_rpg_ammo", @"item_shotgun_ammo", @"item_revolver_ammo",
        @"item_rpg", @"item_grenade_launcher", @"item_great_sword", @"item_hookshot_sword",
        @"item_shield_viking_4", @"item_teleport_gun", @"item_hoverpad", @"item_backpack_mega",
        @"item_ogre_hands", @"item_shotgun", @"item_revolver_gold", @"item_alphablade",
        @"item_bloodlust_vial", @"item_dynamite", @"item_grenade", @"item_cluster_grenade",
        @"item_pumpkin_bomb", @"item_landmine", @"item_sticky_dynamite", @"item_timebomb",
        @"item_flashbang", @"item_plank", @"item_crossbow", @"item_snowball", @"item_revolver",
        @"item_flamethrower", @"item_pistol_dragon", @"item_ore_gold_l", @"item_metal_plate",
        @"item_football", @"item_d20", @"item_egg", @"item_apple", @"item_banana",
        @"item_pineapple", @"item_burrito", @"item_turkey_leg", @"item_shield",
        @"item_fish_dumb_fish", @"item_goopfish", @"item_basic_fishing_rod", @"item_trophy",
        @"item_balloon", @"item_glowstick", @"item_ukulele", @"item_robot_head",
        @"item_backpack", @"item_backpack_big", @"item_axe", @"item_baseball_bat",
        @"item_boomerang", @"item_crowbar", @"item_frying_pan", @"item_hookshot",
        @"item_moneygun", @"item_pickaxe", @"item_rope", @"item_scissors", @"item_zipline_gun",
        @"item_arrow", @"item_arrow_bomb", @"item_arrow_heart", @"item_stellarsword_blue",
        @"item_lance", @"item_boombox", @"item_boombox_neon", @"item_hot_cocoa", @"item_cola",
        @"item_quest_vhs", @"item_quest_vhs_lake", @"item_quest_vhs_graveyard",
        @"item_anti_gravity_grenade", @"item_arena_pistol", @"item_arena_shotgun",
    ];

    P7_allMonsters = @[
        @"AnglerController", @"AnglerMadController", @"ArmstrongController", @"ArmstrongMadController",
        @"BansheeController", @"BlobController", @"BombController", @"BomberController",
        @"BomberFlashbangController", @"BomberMadController", @"ChickenController", @"CutieController",
        @"CystController", @"EvilEyeController", @"EvilEyePinataController", @"EvilEyePinataLargeController",
        @"FakeGorillaController", @"FlyingSwarmController", @"GiantController", @"LankyController",
        @"NextBotController", @"NextBotStaticController", @"PhantomController",
        @"RedGreenController", @"RedGreenMadController", @"SegwayController",
        @"SpiderCaveController", @"SpiderController",
    ];
}

NSArray *P7GetAllItems(void) { return P7_allItems; }
NSArray *P7GetAllMonsters(void) { return P7_allMonsters; }
int P7GetPresetCount(void) { return kP7PresetCount; }
void P7GetPresetPosition(int index, float out[3], const char **outName) {
    if (index < 0 || index >= kP7PresetCount) return;
    out[0] = kP7PresetPositions[index].x;
    out[1] = kP7PresetPositions[index].y;
    out[2] = kP7PresetPositions[index].z;
    if (outName) *outName = kP7PresetPositions[index].name;
}
