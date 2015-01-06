#!/bin/bash


APP_FILE=$(find ~|grep WinMover.app$|grep Build)
cp -Rf "$APP_FILE" dist/
hdiutil create -volname dist/WinMover.app -srcfolder dist/ -ov -format UDZO WinMover.dmg