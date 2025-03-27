# TagSweep

TagSweep
Restore lost EXIF metadata from Google Takeout exports with ease.

TagSweep is a free, open-source macOS app that helps restore missing EXIF metadata (timestamps, geotags, etc.) when migrating photos from Google Photos. Built for those moving to self-hosted solutions like Immich, this tool ensures your memories retain their correct metadata.

Why TagSweep?
Google Takeout exports your photos and videos but strips essential metadata from them. This can cause issues when importing them into alternative photo storage platforms. TagSweep solves this by:

Restoring timestamps: Uses filenames and JSON data to correct missing EXIF dates.

Fixing geotags: Recovers location data where available.

Batch processing: Processes thousands of photos at once.

Simple UI, powerful backend: A clean macOS interface running robust command-line tools under the hood.

How It Works
TagSweep follows a step-by-step process:

Check Prerequisites: Ensures Homebrew, EXIFTool, and jq are installed.

Organize Files: Renames images and JSON files for consistency.

Merge Metadata: Combines JSON data with media files.

Fix Date & Time: Corrects file creation and modification timestamps.

Extras (Work in Progress): Features like batch renaming and cleanup.

Final Step: Displays acknowledgments and support options.

Installation
Download
Get the latest version from GitHub Releases.

Requirements
macOS 12+ (Monterey or later)

Homebrew, EXIFTool, jq (installed automatically if missing)

Support & Contributions
This is a one-time project, meaning no guaranteed updates. However, you're free to modify, contribute, or fork the project. If you find this tool useful, consider supporting my work on Patreon.

For any issues, create a GitHub issue or contact me at hello@melvin-anthony.com.

## Prerequisites

Before building and running TagSweep, ensure you have the following dependencies installed:

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required dependencies
brew install exiftool
brew install jq
```

## Development

### Requirements
- Xcode 13 or later
- macOS 12 or later

### Building
1. Clone the repository
2. Open `TagSweep.xcodeproj` in Xcode
3. Build and run the project (⌘R)

## Features
- Multi-step workflow for batch metadata management
- Drag and drop interface for file handling
- Integration with system commands for metadata operations
- Real-time command output streaming

License
TagSweep is released under GNU General Public License v3.0. You can modify and distribute it as per the terms of this license.