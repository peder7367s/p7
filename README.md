# P7 — Game Menu

Remake of the Animal Company game menu with a new name, **P7**, a cyber/neon theme, and more features.

## What’s included

- **P7 Backend.m** — IL2CPP/Unity bridge: spawn items & monsters, shapes, admin presets, preset locations. Same target (Animal Company, iOS jailbreak).
- **P7 Frontend.m** — Full UI: tabs, quick slots, favorites, categories, shapes, experiments, locations, admin, settings.

## Theme

- **Dark base** with **cyan** (#00e5ff), **magenta** (#ff00c8), and **amber** (#ffaa00) accents.
- Glass-style panel, gradient header, glowing “P7” title.
- Card-style buttons and borders.

## Features (vs original)

| Feature | Original | P7 |
|--------|----------|-----|
| Name | AC / Orbit | **P7** |
| Tabs | 4–5 | **7** (Items, Monsters, Shapes, Experiments, Locations, Admin, Settings) |
| Categories | 4 | **8** (All, Weapons, Rare, Explosives, Food, Fish, Backpacks, Quest) |
| Quick spawn | — | **5 slots** (tap to assign, tap again to spawn) |
| Favorites | — | **Favorites list** + tap to select |
| Shapes | 6 | **9** (Heart, Circle, Tower, Wall, Spiral, Star, **Hexagon**, Bomb, Monster Wave) |
| Preset locations | 10 | **13** (includes P7 Spot A/B/C) |
| Experiment presets | ~28 | **16** quick buttons |
| Admin | 8 | **7** (God Kit, Giveaway, Money, Nuke, Flare, Spawn 100, Spawn All) |
| Settings | Voice, JSON | Voice, **Load JSON** |

## Build

- Target: **iOS**, **jailbroken** device.
- Compile both `P7 Backend.m` and `P7 Frontend.m` into a single **.dylib** and inject via your tweak loader (e.g. substitute/substrate, `/var/jb/`).
- Link: **UIKit**, **QuartzCore**, **Speech**, **AVFoundation**, **UniformTypeIdentifiers**, **Foundation**, **dlfcn**, **mach-o/dyld**.

## Usage

1. Inject the dylib into the Animal Company process.
2. A floating **P7** button appears; drag to move, tap to open the menu.
3. Use **Items** or **Monsters** to pick and spawn; set **Quick slots** and **Favorites** for fast access.
4. Use **Shapes** and **Experiments** for pattern spawns; **Locations** for preset coords; **Admin** for power actions; **Settings** for voice and JSON.
