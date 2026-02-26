# What to do now (you're on PC, no Mac)

You have the **source code** and **packaging files**. You do **not** have the **.deb** yet. Do this to get it.

**Build strategy:** The workflow first builds a **minimal** P7.dylib (single file, UIKit only). That almost always succeeds, so you get a working .deb and a floating **P7** button that opens a simple panel. If the **full** menu (tabs, items, spawn, etc.) also compiles on the runner, it replaces the minimal dylib in the same artifact. So you always get at least the minimal version.

---

## Step 1: Push P7 to GitHub

So GitHub can build the .deb for you (they have the Mac, you don’t).

1. **Install Git** if you don’t have it: https://git-scm.com/download/win  
   (Or use GitHub Desktop.)

2. **Open Command Prompt or PowerShell** and run:

   ```powershell
   cd C:\Users\peder\Downloads\yee\P7
   git init
   git add .
   git commit -m "P7 menu"
   ```

3. **Create a new repo on GitHub:**  
   - Go to https://github.com/new  
   - Repository name: e.g. **P7**  
   - Leave it empty (no README, no .gitignore).  
   - Create repository.

4. **Connect and push** (replace `YOUR_USERNAME` and `P7` with your GitHub username and repo name):

   ```powershell
   git remote add origin https://github.com/YOUR_USERNAME/P7.git
   git branch -M main
   git push -u origin main
   ```

   If it asks for login, use your GitHub username and a **Personal Access Token** (not your password):  
   https://github.com/settings/tokens → Generate new token (classic), tick `repo`, use it as the password when pushing.

---

## Step 2: Run the build on GitHub

1. Open your repo on GitHub (e.g. `https://github.com/YOUR_USERNAME/P7`).
2. Click the **Actions** tab.
3. Click **Build P7** in the left sidebar.
4. Click **Run workflow** (right side) → **Run workflow**.
5. Wait until the run shows a **green check** (about 1–2 minutes).

---

## Step 3: Download the .deb

1. Click the finished (green) run.
2. Scroll to **Artifacts**.
3. Download **P7-deb-packages** (it’s a zip).
4. Unzip it on your PC. You’ll get:
   - **P7_1.0_iphoneos-arm.deb** (classic jailbreak)
   - **P7_1.0_iphoneos-arm_rootless.deb** (rootless, e.g. Dopamine)
   - **P7.dylib** (the tweak binary)

Use the **rootless** one if you’re on Dopamine or another rootless jailbreak; otherwise use the classic one.

---

## Step 4: Install on your iPhone

1. Copy the **.deb** to your iPhone (AirDrop, cable, Filza from PC, etc.).
2. Open **Filza** (or Sileo/Zebra) on the phone.
3. Tap the .deb file → **Install**.
4. **Respring** (or restart the Animal Company app).
5. Open **Animal Company** — the **P7** floating button should appear. Tap it to open the menu.

---

## If something fails

- **“Git not found”** → Install Git (link in Step 1).
- **Push rejected / login** → Use a Personal Access Token instead of password.
- **Workflow doesn’t appear** → Make sure the `.github/workflows/build.yml` file is in the repo and pushed.
- **Menu doesn’t show in the app** → Check BUILD_AND_INSTALL.md for bundle ID and rootless path.

That’s it. You only need to do Steps 1–4 once to get and install the .deb.
