# HOW TO GET P7.dylib

You need **P7.dylib** (the compiled tweak) before you can install the menu. Two ways:

---

## 1. From GitHub Actions (no Mac)

1. **Push the latest code** (the workflow was just updated to use iOS 14):
   ```bash
   cd C:\Users\peder\Downloads\yee\P7
   git add .
   git commit -m "iOS 14 min"
   git push
   ```

2. **Run the workflow**: GitHub → your repo **peder7367s/p7** → **Actions** → **Build P7** → **Run workflow**.

3. **If it succeeds (green check):**
   - Open the run → scroll to **Artifacts** → download **P7-deb-packages**.
   - Unzip it. You get **P7.dylib** and the **.deb** files.

4. **If it fails again:**
   - Open the failed run → click the **build** job.
   - Click the step **"Show build log if build failed"**.
   - **Copy the whole log** (the compiler error will be there) and paste it so we can fix the code.

---

## 2. On a Mac (if you have one or borrow one)

1. Copy the **P7** folder to the Mac.
2. Open **Terminal**:
   ```bash
   cd /path/to/P7
   chmod +x build_mac.sh
   ./build_mac.sh
   ```
3. You get **P7.dylib** and the **.deb** files in the same folder.

---

## After you have P7.dylib

- **Jailbroken phone:** Use the **.deb** from the same build → install with Filza/Sileo → respring.
- **Non-jailbroken (Esign):** Inject **P7.dylib** into the Animal Company IPA, then sign the IPA with Esign and install.

Right now the GitHub build has been failing. Push the latest change (iOS 14) and run the workflow again. If it still fails, send the **"Show build log if build failed"** output so we can fix it and you can get the dylib.
