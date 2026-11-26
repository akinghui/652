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
# Runtime UCI defaults
mkdir -p files/etc/uci-defaults

cat > files/etc/uci-defaults/91-set-lan-ip <<'EOF'
#!/bin/sh
uci -q set network.lan.ipaddr='10.0.0.1'
uci -q commit network
exit 0
EOF

cat > files/etc/uci-defaults/98-set-luci-zh <<'EOF'
#!/bin/sh
uci -q set luci.main.lang='zh_cn'
uci -q commit luci
exit 0
EOF

cat > files/etc/uci-defaults/99-set-argon-theme <<'EOF'
#!/bin/sh
uci -q set luci.main.mediaurlbase='/luci-static/argon'
uci -q commit luci
exit 0
EOF

chmod +x files/etc/uci-defaults/91-set-lan-ip
chmod +x files/etc/uci-defaults/98-set-luci-zh
chmod +x files/etc/uci-defaults/99-set-argon-theme
