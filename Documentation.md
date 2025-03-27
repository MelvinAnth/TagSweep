TagSweep Documentation
1. Introduction
TagSweep is a macOS app designed to restore missing metadata from Google Takeout photo exports. It automates the process of fixing timestamps and geotags so that your memories are correctly organized.

2. Installation
Download & Install
Download the latest release from GitHub Releases.

Open the .dmg file and move TagSweep to the Applications folder.

Launch the app.

Dependencies
TagSweep requires:

Homebrew

EXIFTool

jq

If any of these are missing, you’ll be prompted to install them manually. In a future release, an automated installer may be included.

3. Step-by-Step Guide
TagSweep follows a structured process to ensure accurate metadata restoration.

Step 1: Prerequisites Check
The app checks if Homebrew, EXIFTool, and jq are installed.

If any are missing, you’ll be provided with terminal commands to install them.

Step 2: Organize Files
This step renames image and JSON files for consistency.

📌 Important: Drag & drop the main folder containing all subfolders into the app. Running this step is mandatory for the next steps to work properly.

Step 3: Merge Metadata
This step merges JSON metadata with media files.

It does not modify or reformat data—just links the correct JSON data to its media counterpart.

This step is necessary before fixing dates.

Step 4: Fix Date & Time
Corrects the file creation and modification dates using metadata.

If EXIF data is available, it is used. Otherwise, the tool retrieves timestamps from JSON files.

This ensures your media files have accurate timestamps when imported into another system.

Step 5: Extras (Work in Progress)
Future updates may include:

Batch file renaming (based on timestamps or titles)

Automatic cleanup (removing unnecessary JSON files, unsupported formats, etc.)

Step 6: Final Step
Displays a thank-you page with:

Support options (e.g., Patreon)

Contributor acknowledgments

4. Frequently Asked Questions
Q: Does this modify my original files?
No, TagSweep creates corrected copies in a separate folder.

Q: Will this work on Windows or Linux?
No, TagSweep is macOS-exclusive. However, the underlying script can be adapted for other platforms.

Q: Can I suggest new features?
Since this is a one-time project, no new features will be added. However, feel free to modify the source code.

5. License & Contributions
TagSweep is open-source and released under GNU General Public License v3.0. Contributions are welcome!

For bug reports or feature requests, create an issue on GitHub or contact me at hello@melvin-anthony.com.