# How to build P7 into a .deb and inject into Animal Company

You need to (1) **build the dylib** on a Mac with Xcode, (2) **package it as a .deb**, then (3) **install the .deb** on your jailbroken device so it injects into the Animal Company app.

---

## 1. Build the .dylib (on macOS with Xcode)

Building an iOS dylib is done with the **iOS SDK** on **macOS**. Windows cannot build it directly unless you set up a cross-compiler (e.g. osxcross).

**On a Mac:**

1. Install **Xcode** from the App Store (and open it once to accept the license).
2. Put the whole **P7** folder on the Mac (e.g. copy from Windows).
3. Open **Terminal**, go to the P7 folder:
   ```bash
   cd /path/to/P7
   ```
4. Make the script executable and run it:
   ```bash
   chmod +x build_mac.sh
   ./build_mac.sh
   ```
5. You should get:
   - **P7.dylib** (the tweak)
   - **P7_1.0_iphoneos-arm.deb** (if `dpkg-deb` is available)

If you don’t have `dpkg-deb` on the Mac (needed to build the .deb), install it:

```bash
brew install dpkg
```

Then run `./build_mac.sh` again.

**Manual build (if you prefer not to use the script):**

```bash
SDK=$(xcrun -sdk iphoneos -show-sdk-path)
clang -arch arm64 -isysroot "$SDK" -dynamiclib -fobjc-arc \
  -framework UIKit -framework QuartzCore -framework Speech \
  -framework AVFoundation -framework Foundation -framework UniformTypeIdentifiers \
  -install_name /Library/MobileSubstrate/DynamicLibraries/P7.dylib \
  "P7 Backend.m" "P7 Frontend.m" -o P7.dylib
```

---

## 2. Create the .deb (if the script didn’t)

If you only have **P7.dylib** and no .deb yet:

**On the Mac** (with `dpkg` installed):

```bash
# From the P7 folder
mkdir -p P7_1.0_iphoneos-arm/DEBIAN
mkdir -p P7_1.0_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries

cp deb/DEBIAN/control P7_1.0_iphoneos-arm/DEBIAN/
cp deb/Library/MobileSubstrate/DynamicLibraries/P7.plist P7_1.0_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries/
cp P7.dylib P7_1.0_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries/

dpkg-deb -b P7_1.0_iphoneos-arm P7_1.0_iphoneos-arm.deb
```

You can also **build the .deb on the iPhone** (jailbroken) if you have the dylib and plist there: install **Debian Packager** or **dpkg** via Cydia/Sileo, put the same folder layout on the device, and run `dpkg-deb -b P7_1.0_iphoneos-arm` there.

---

## 3. Install on the device (inject into Animal Company)

1. Copy **P7_1.0_iphoneos-arm.deb** to your jailbroken iPhone (e.g. via AirDrop, Filza, or a file manager that can open the device).
2. **Rootless jailbreaks** (e.g. Dopamine, palera1n rootless):  
   The package uses **`/Library/MobileSubstrate/DynamicLibraries/`**. On rootless, that is often **`/var/jb/Library/MobileSubstrate/DynamicLibraries/`**. If your package manager installs to `/var/jb`, it will put the files there; if not, you may need to repackage the deb so paths inside the deb are `var/jb/Library/...` (see below).
3. Install the .deb:
   - **Filza:** tap the .deb → Install → respring or restart the app.
   - **Terminal (SSH):**  
     `sudo dpkg -i /path/to/P7_1.0_iphoneos-arm.deb` then respring.
   - **Sileo / Zebra:** add the .deb as a local package and install, then respring.
4. Open **Animal Company**; the floating **P7** button should appear. Tap it to open the menu.

---

## 4. If your jailbreak is rootless (/var/jb)

Some jailbreaks (e.g. Dopamine) use a rootless prefix: real paths are under **/var/jb/**.

- If the package manager **automatically maps** `/Library` to `/var/jb/Library`, the current deb is fine.
- If it does **not**, you need the dylib and plist to end up in **/var/jb/Library/MobileSubstrate/DynamicLibraries/**.

To do that, create a second layout and pack it:

```bash
mkdir -p P7_rootless/var/jb/Library/MobileSubstrate/DynamicLibraries
cp P7.dylib P7_rootless/var/jb/Library/MobileSubstrate/DynamicLibraries/
cp deb/Library/MobileSubstrate/DynamicLibraries/P7.plist P7_rootless/var/jb/Library/MobileSubstrate/DynamicLibraries/
# Edit control if needed, then:
mkdir -p P7_rootless/DEBIAN
cp deb/DEBIAN/control P7_rootless/DEBIAN/
dpkg-deb -b P7_rootless P7_1.0_iphoneos-arm_rootless.deb
```

Install that .deb instead.

---

## 5. If P7 doesn’t load in Animal Company (wrong bundle ID)

The tweak only loads into apps whose **bundle ID** is in **P7.plist**. The plist currently has:

- `com.woostergames.animalcompany`
- `com.woostergames.AnimalCompany`

If Animal Company uses a different ID, the dylib won’t inject.

**Find the real bundle ID:**

- On the device: install **BundleIDs** (Cydia/Sileo) or **Crane** and look for the game, or
- From a backup: open the app’s **Info.plist** and read `CFBundleIdentifier`.

Then edit **deb/Library/MobileSubstrate/DynamicLibraries/P7.plist**: change the `<string>...</string>` entries to the correct bundle ID(s), rebuild the deb (or replace the plist in the installed path and respring).

---

## Summary

| Step | Where | What |
|------|--------|------|
| 1 | Mac | Run `./build_mac.sh` → get **P7.dylib** and **P7_1.0_iphoneos-arm.deb** |
| 2 | iPhone | Copy the .deb to the device |
| 3 | iPhone | Install .deb (Filza / Sileo / dpkg), then respring |
| 4 | iPhone | Open Animal Company → P7 button appears; tap to open menu |

If the menu never appears, check (1) bundle ID in P7.plist and (2) rootless paths (/var/jb) for your jailbreak.
