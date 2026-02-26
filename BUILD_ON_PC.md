# Build P7 and get a .deb **without a Mac** (on PC)

You have two ways to get a `.deb` using only your PC.

---

## Option A: Build in the cloud (easiest)

GitHub gives you a free Mac runner. Use it to build the dylib and create the .deb, then download the result.

1. **Create a GitHub account** if you don’t have one (github.com).

2. **Put the P7 project in a Git repo and push it:**
   - Only the **contents** of the `P7` folder should be the repo (so `P7 Backend.m`, `P7 Frontend.m`, `deb/`, `.github/`, etc. are in the **root** of the repo).
   - In a terminal (or Git Bash on Windows):
     ```bash
     cd C:\Users\peder\Downloads\yee\P7
     git init
     git add .
     git commit -m "P7 menu"
     ```
   - On GitHub, create a **new repository** (empty, no README).
   - Then:
     ```bash
     git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
     git branch -M main
     git push -u origin main
     ```

3. **Run the build:**
   - Open your repo on GitHub → **Actions**.
   - Click **Build P7** (or the only workflow).
   - Click **Run workflow** → **Run workflow**.

4. **Download the .deb:**
   - When the run is finished (green check), open the run.
   - Under **Artifacts**, download **P7-deb-packages** (zip with the .deb files and `P7.dylib`).
   - Unzip on your PC. Use:
     - **P7_1.0_iphoneos-arm_rootless.deb** for rootless (e.g. Dopamine), or  
     - **P7_1.0_iphoneos-arm.deb** for classic jailbreaks.

5. **Install on the iPhone:** copy the .deb to the device and install with Filza / Sileo / Zebra, then respring.

---

## Option B: Build the .deb on PC (when you already have P7.dylib)

If you already have **P7.dylib** (e.g. from Option A’s artifact, or from someone else), you can create the .deb on your PC with Python.

1. **Install Python** on Windows (python.org). Use Python 3.8+.

2. **Put `P7.dylib`** in the P7 folder:
   ```
   C:\Users\peder\Downloads\yee\P7\P7.dylib
   ```
   (Same folder as `make_deb_on_pc.py`.)

3. **Run the script** in Command Prompt or PowerShell:
   ```bash
   cd C:\Users\peder\Downloads\yee\P7
   python make_deb_on_pc.py
   ```

4. You’ll get in that folder:
   - **P7_1.0_iphoneos-arm.deb**
   - **P7_1.0_iphoneos-arm_rootless.deb**

5. Copy the right .deb to your iPhone and install (Filza / Sileo / Zebra), then respring.

---

## Summary

| Goal                         | What to do on PC                                      |
|-----------------------------|--------------------------------------------------------|
| Build dylib + .deb (no Mac) | Use **Option A**: push P7 to GitHub, run Actions, download artifact. |
| Only pack a .deb            | Use **Option B**: put `P7.dylib` in P7 folder, run `python make_deb_on_pc.py`. |

You **cannot** build the iOS dylib itself (the `.m` → `P7.dylib` step) natively on Windows without a Mac or a Mac runner like GitHub Actions; that step needs the iOS SDK. The .deb **can** be created on PC with the script once you have the dylib.
