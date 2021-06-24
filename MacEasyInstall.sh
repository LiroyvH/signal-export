#!/bin/bash
#This file simply triggers the chained commands to do everything on MacOS, for the less tech-savvy. Run at own risk.
git clone https://github.com/liroyvh/signal-export.git && cd signal-export && pip3 install -r requirements.txt --user && brew install openssl sqlcipher wkhtmltopdf && python3 sigexport.py EXPORT && cd EXPORT && echo "Now generating PDF files..." && mkdir -p pdf && find . -maxdepth 2 -name '*.html' -exec sh -c 'for f; do wkhtmltopdf --enable-local-file-access "$f" "./pdf/$(basename "$(dirname "$f")").pdf"; done' _ {} + && open . -a Finder
