# P7 — Easiest way to get the menu on your phone

**In short:** Put your P7 folder on GitHub. GitHub builds the file you need. You download it and install it on your iPhone.

---

## 1. Put your project on GitHub

1. Go to **https://github.com** and sign in (or create a free account).
2. Click the **+** (top right) → **New repository**.
3. Name it **P7**, leave everything else as is, click **Create repository**.
4. On the new page you’ll see “…or push an existing repository from the command line.”  
   You need **Git** on your PC first:
   - Download: **https://git-scm.com/download/win**
   - Install it (next, next, finish).
5. On your PC, open **Command Prompt** or **PowerShell** and type exactly (press Enter after each line):

   ```
   cd C:\Users\peder\Downloads\yee\P7
   git init
   git add .
   git commit -m "P7"
   git remote add origin https://github.com/YOUR_USERNAME/P7.git
   git branch -M main
   git push -u origin main
   ```
   **Replace YOUR_USERNAME with your real GitHub username.**

   When it asks for password: use your GitHub **username** and a **Personal Access Token** (not your normal password). To make one: GitHub → your profile picture → Settings → Developer settings → Personal access tokens → Generate new token. Tick **repo**, generate, copy the token and paste it when Git asks for password.

6. When the last command finishes without errors, your P7 project is on GitHub.

---

## 2. Let GitHub build the .deb

1. Open your repo in the browser: **https://github.com/YOUR_USERNAME/P7**
2. Click the **Actions** tab.
3. On the left, click **Build P7**.
4. On the right, click **Run workflow**, then the green **Run workflow** button.
5. Wait 1–2 minutes until you see a green checkmark.

---

## 3. Download the .deb

1. Click the green checkmark (or the “Build P7” run that just finished).
2. Scroll down to **Artifacts**.
3. Click **P7-deb-packages** — it will download a zip file.
4. Unzip it on your PC. Inside you’ll see **P7_1.0_iphoneos-arm_rootless.deb** (and maybe another .deb).  
   Use the **rootless** one if you have Dopamine or a similar jailbreak.

---

## 4. Install on your iPhone

1. Copy the **.deb** file to your iPhone (AirDrop, cable, iCloud, or open the zip in Filza if you have it).
2. On the iPhone, open **Filza** (or Sileo/Zebra).
3. Find the .deb file and tap it → **Install**.
4. When it’s done, **respring** (or close and reopen the game).
5. Open **Animal Company**. You should see a **P7** button. Tap it to open the menu.

---

**That’s it.**  
If something doesn’t work, say which step (1, 2, 3, or 4) and what you see on the screen.
