#!/usr/bin/env bash

echo "Building macOS target ..."

echo "Installing requirements ..."
python3 -m venv venv
source venv/bin/activate

# Install requirements with xargs to continue on error (pyside6)
cat requirements.txt | xargs -n 1 pip install
pip install nuitka imageio pyside6

# remove all .DS_Store files from the project since Nuitka errors out on them
find . -name '.DS_Store' -type f -delete

echo "Building with Nuitka ..."
python -m nuitka app.py \
  --standalone \
  --follow-imports \
  --show-modules \
  --assume-yes-for-downloads \
  --enable-plugin=pyside6 \
  --include-qt-plugins=sensible,styles,qml,multimedia \
  --include-data-files=./artemis/resources.py=./artemis/resources.py \
  --include-data-files=./config/qtquickcontrols2.conf=./config/qtquickcontrols2.conf \
  --include-data-files=./building/Linux/create_shortcut.sh=./create_shortcut.sh \
  --macos-create-app-bundle \
  --macos-app-icon=images/artemis_icon.ico \
  --macos-signed-app-name=com.AresValley.Artemis \
  --macos-app-name=Artemis \
  --macos-app-mode=gui \
  --macos-sign-identity=ad-hoc \
  --macos-app-version=4.1.0

echo "Building Linux target finished."
