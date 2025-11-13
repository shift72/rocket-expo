#!/bin/sh
#
#  writeMetadata.sh
#  Shift72RocketSDK
#
#  Created by Declan ter Veer-Burke on 04/11/2025.
#

touch "$SRCROOT/Shift72RocketSDK/Shift72RocketSDKMetadata.swift"
if [ $ACTION != "indexbuild" ]; then
    echo "Writing project version to metadata"
    sed -i '' -E "s/\\\".+\\\"/\\\"$MARKETING_VERSION\\\"/g" "$SRCROOT/Shift72RocketSDK/Shift72RocketSDKMetadata.swift"
fi
