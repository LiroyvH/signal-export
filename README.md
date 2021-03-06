# signal-export: PDF friendly
Export/backup chats from the [Signal](https://www.signal.org/) [Desktop app](https://www.signal.org/download/) to Markdown and HTML files with attachments. Each chat is exported as an individual .md/.html file and the attachments for each are stored in a separate folder. Attachments are linked from the Markdown files and displayed in the HTML (pictures, videos, voice notes). This is forked from https://github.com/carderne/signal-export. 

In this fork, I have made changes to the script to ensure PDF files can properly be generated from the output. This version of this script removes all pagination present in the original, for the sake of generating PDF's. It also re-renders emoji's in the HTML-output, so that webkit renders can successfully include emoji's in the output PDF; which is not possible with the original output.

Originally adapted from https://github.com/mattsta/signal-backup.  
This is currently the only known way to back-up Signal Desktop and also the only way to get some form of backup for iPhone/iOS users. Signal's developers have so far refused to give iOS users any means to export a back-up and they have shot down any attempts and all viable solutions; even when they were extraordinary safe solutions. Signal's developers have refused to offer an explanation as to why they wish to deny us any means of backing up our data, even when this can be done in a simple and secure way - even through AMB or on iCloud. It looks like, unfortunately, Signal wants to keep your iOS data hostage at all costs. So good news: if your Signal Desktop instance is in-sync with your iPhone, you can now at least create a backup to HTML and/or PDF files so that at least your message history is safe to some extent. (Note: from the time you started using Desktop. Anything before that time is not included.) Of course if you wish to upload this as a backup to a cloud service, then I strongly recommend uploading it in an encrypted container for your own safety - don't ever upload the plain-text HTML/PDF!

Please continue reading to find all installation instructions and instructions to generate PDF's.  
Everything comes as-is and comes with zero guarantees (of proper or safe operation). Using this tool, any commands or instructions is at your own risk. Do not rely on the output of these scripts and commands as your sole backup and double-check the output. Tool can stop working if Signal changes anything to Signal Desktop. Let's hope they don't make any blocking changes that keep us away from safeguarding our data. :) 

This is a work in progress, more convenience features and commands to automate the process will be added in the near future.  

&nbsp;
## Example
An export for a group conversation looks as follows:
```markdown
[2019-05-29, 15:04] Me: How is everyone?
[2019-05-29, 15:10] Aya: We're great!
[2019-05-29, 15:20] Jim: I'm not.
```

Images are attached inline with `![name](path)` while other attachments (voice notes, videos, documents) are included as links like `[name](path)` so a click will take you to the file.

This is converted to HTML at the end so it can be opened with any web browser. 
The stylesheet `.css` is still very basic but I'll get to it sooner or later.

&nbsp;
## Installation - SEMI-AUTOMATED (MacOS ONLY! (at this time))
- Open up the Terminal-app on your Mac and install [Homebrew](https://brew.sh) by copy/pasting this command and pressing enter:  
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```  
It may at some point prompt you for the password of your Mac. Type it in and hit enter, note that you will NOT see anything happening whilst you type. No \*\*\*\*\* or anything.
- Check if pip is installed by running: `sudo easy_install pip`
- Now we're going to do the magic, please use the commands for your architecture (Intel/Apple):
- - For **INTEL** Mac-users: 
once this is all succesfully installed: to automatically download this script + dependencies and backup all your chats + also convert them to PDF; copy/paste this command to your Terminal and press enter:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/liroyvh/signal-export/master/MacEasyInstall.sh)"
```
- - For **Apple Silicon (M1, M1 Pro, etc.)** Mac-users:
once this is all succesfully installed: to automatically download this script + dependencies and backup all your chats + also convert them to PDF; copy/paste and run (enter) these two commands in your Terminal one-by-one:
```
arch -x86_64 /bin/zsh --login
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/liroyvh/signal-export/master/MacEasyInstall.sh)"
```
- Now let it do its thing. It can take several minutes and it might prompt you for your Mac's password again. If you have tons and tons of media it can actually take quite some time. Once it's done, a Finder window will open with all your conversations in folders. You can find the PDF copies in the "pdf" folder. 
- This is for first time use only, for future use (with new backups): jump to the "Usage" chapter.

&nbsp;
## Installation - MANUAL (MacOS and Linux)


First, clone and install requirements (preferably into a virtualenv):
```
git clone https://github.com/liroyvh/signal-export.git
cd signal-export
```

### For MacOS:
- Install [Homebrew](https://brew.sh).
- Run `brew install openssl sqlcipher wkhtmltopdf` and if it says permissions are wrong: run the commands it asks you to.
- NOTE: If you're on an Apple Silicon (M1, M1 Pro, etc.) Mac, you need to switch the architecture and shell before continuing, by running the following command: `arch -x86_64 /bin/zsh --login`. Conversely, if you're on a Mac with Intel CPU using zsh you must first switch to bash. (`arch -x86_64 /bin/bash`)
- Check if pip is installed: `sudo easy_install pip`
- Run `pip3 install -r requirements.txt`


### For Linux
First get sqlcipher working:
```
sudo apt install libsqlcipher-dev libssl-dev
```

Then clone [sqlcipher](https://github.com/sqlcipher/sqlcipher) and install it:
```
git clone https://github.com/sqlcipher/sqlcipher.git
cd sqlcipher
mkdir build && cd build
../configure --enable-tempstore=yes CFLAGS="-DSQLITE_HAS_CODEC" LDFLAGS="-lcrypto"
sudo make install
```

&nbsp;
## Usage
The following should work, and exports all your conversations to a sub-directory named "EXPORT":
```
./sigexport.py EXPORT
```
If you get an error regarding pysqlcipher3 not being able to run due to a wrong architecture (arm64 instead of x86_64), you're probably running on a M1-powered Mac. Switch your terminal to x86_64 first: `arch -x86_64 /bin/zsh --login`. Then try again.

If you get the following error:

    pysqlcipher3.dbapi2.DatabaseError: file is not a database

try adding the `--manual` option.


The full options are below:
```
Usage: ./sigexport.py [OPTIONS] [DEST]

Options:
  -s, --source PATH  Path to Signal config and database
      --old PATH     Path to previous export to merge with
  -c, --chats "NAME"  Comma-separated chat names to include. These are contact names or group names
  --list-chats              List all available chats/conversations
  --old PATH         Path to previous export to merge with
  -o, --overwrite    Flag to overwrite existing output
  -m, --manual       Flag to manually decrypt the database
  -v, --verbose      Enable verbose output logging
  --help             Show this message and exit.
```

You can add `--source /path/to/source/dir/` if the script doesn't manage to find the Signal config location. Default locations per OS are below. The directory should contain a folder called `sql` with a `db.sqlite` inside it.
- Linux: `~/.config/Signal/`
- macOS: `~/Library/Application Support/Signal/`
- Windows: `~/AppData/Roaming/Signal/`

You can also use `--old /previously/exported/dir/` to merge the new export with a previous one. _Nothing will be overwritten!_ It will put the combined results in whatever output directory you specified and leave your previos export untouched. Exercise is left to the reader to verify that all went well before deleting the previous one.

## Convert to PDF 
If you want to convert all the conversations to PDF, please run the following command in your "EXPORT" folder:
```
mkdir -p pdf && find . -maxdepth 2 -name '*.html' -exec sh -c 'for f; do wkhtmltopdf --enable-local-file-access "$f" "./pdf/$(basename "$(dirname "$f")").pdf"; done' _ {} +
```
**PLEASE BE AWARE THAT THE COMMAND ABOVE TO EXPORT TO PDF HAS BEEN WRITTEN FOR MacOS**  
For Linux: please first find instructions to install wkhtmltopdf for your distribution. (Example: [Ubuntu](https://websiteforstudents.com/how-to-install-wkhtmltopdf-wkhtmltoimage-on-ubuntu-18-04-16-04/)) Then run the above command.

Enjoy! :) 
