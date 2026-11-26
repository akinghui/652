#!/bin/bash
set -e
cd "${GITHUB_WORKSPACE}/openwrt"

# Use the latest Xray source from the small feed.
rm -rf feeds/packages/net/xray-core feeds/packages/net/xray-example feeds/packages/net/xray-plugin
rm -rf package/feeds/packages/xray-core package/feeds/packages/xray-example package/feeds/packages/xray-plugin

# Xray 26.11.9 requires Go >= 1.27.
rm -rf feeds/packages/lang/golang package/feeds/packages/golang
git clone --depth=1 -b 1.27 https://github.com/kenzok8/golang feeds/packages/lang/golang

./scripts/feeds install golang xray-core luci-app-passwall ddnsto luci-app-ddnsto
