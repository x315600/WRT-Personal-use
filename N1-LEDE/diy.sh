#!/bin/bash
# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Remove packages
#删除lean库中的插件，使用自定义源中的包。
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/luci/applications/luci-app-mosdns
#rm -rf feeds/luci/themes/luci-theme-design
#rm -rf feeds/luci/applications/luci-app-design-config

# 自定义
rm -rf feeds/luci/applications/luci-app-wol
rm -rf feeds/packages/net/ddns-go
# rm -rf feeds/packages/net/frp
# rm -rf feeds/luci/applications/luci-app-frps
# rm -rf feeds/luci/applications/luci-app-frpc
rm -rf feeds/packages/net/msd_lite
# rm -rf feeds/luci/applications/luci-app-wrtbwmon
# rm -rf feeds/packages/admin/netdata
# rm -rf feeds/luci/applications/luci-app-netdata
# rm -rf feeds/packages/net/qBittorrent
# rm -rf feeds/packages/net/qBittorrent-static
# rm -rf feeds/luci/applications/luci-app-qbittorrent
# rm -rf feeds/packages/net/alist
rm -rf feeds/luci/applications/luci-app-serverchan
rm -rf feeds/packages/net/lucky

#添加科学上网源
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/ddnsgo
#git clone --depth=1 https://github.com/sirpdboy/NetSpeedTest package/NetSpeedTest

git clone -b lua --single-branch --depth 1 https://github.com/sbwml/luci-app-alist package/alist

# golang版本修复
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# mosdns
# 旧版luci(lua)
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f

# nps
rm -rf feeds/packages/net/nps
rm -rf feeds/luci/applications/luci-app-nps

git clone --depth=1 https://github.com/RayleanB/packages package/RB
mv package/RB/* package
rm -rf package/RB
sed -i 's|("OpenClash"), 50)|("OpenClash"), 1)|g' package/luci-app-openclash/luasrc/controller/*.lua
sed -i 's/"admin", "control"/"admin", "network"/g' package/luci-app-timecontrol/luasrc/controller/*.lua
sed -i 's/("Internet Time Control"), 10)/("Internet Time Control"), 90)/g' package/luci-app-timecontrol/luasrc/controller/*.lua
sed -i 's|("MosDNS"), 30)|("MosDNS"), 5)|g' package/luci-app-mosdns/luasrc/controller/*.lua
sed -i 's/"admin", "vpn"/"admin", "nas"/g' feeds/luci/applications/luci-app-zerotier/luasrc/controller/*.lua


# 1 启用 frps
rm -rf feeds/packages/net/frp
git clone https://github.com/kuoruan/openwrt-frp feeds/packages/net/frp
# git clone https://github.com/kuoruan/openwrt-frp -b v0.53.2-1 feeds/packages/net/frp
# git clone https://github.com/user1121114685/frp.git feeds/packages/net/frp
# rm -rf feeds/luci/applications/luci-app-frps
# git clone https://github.com/user1121114685/luci-app-frps.git feeds/luci/applications/luci-app-frps

# Default IP
#sed -i 's/192.168.1.1/192.168.6.50/g' package/base-files/files/bin/config_generate

# Set DISTRIB_REVISION
sed -i "s/OpenWrt /Lein Build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings
sed -i 's#mount -t cifs#mount.cifs#g' feeds/luci/applications/luci-app-cifs-mount/root/etc/init.d/cifs
sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template

# 修改主机名
#sed -i 's/LEDE/OpenWrt/g' package/base-files/files/bin/config_generate
#sed -i 's/LEDE/N1/g' package/base-files/luci2/bin/config_generate

# Modify default IP   第一行19.07的路径   第二行23.05的路径
#sed -i 's/192.168.1.1/192.168.123.2/g' package/base-files/files/bin/config_generate
#sed -i 's/192.168.1.1/192.168.6.50/g' package/base-files/luci2/bin/config_generate


# 修改主题为默认
sed -i 's/luci-theme-argon/luci-theme-bootstrap/g' ./feeds/luci/collections/luci/Makefile

#修改默认时间格式
sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S %A")/g' $(find ./package/*/autocore/files/ -type f -name "index.htm")
