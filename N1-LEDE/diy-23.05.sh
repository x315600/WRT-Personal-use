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

###########################################################################
# 自定义添加
# git clone --depth=1 https://github.com/vernesong/OpenClash package/OpenClash
# git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/luci-app-wechatpush
# git clone --depth=1 https://github.com/sundaqiang/openwrt-packages package/openwrt-packages
# mv package/openwrt-packages/luci-app-wolplus package/luci-app-wolplus
# rm -rf package/openwrt-packages
# git clone --depth=1 https://github.com/kuoruan/openwrt-frp package/openwrt-frp
# git clone --depth=1 https://github.com/superzjg/luci-app-frpc_frps package/luci-app-frpc_frps
# git clone --depth=1 https://github.com/gw826943555/openwrt_msd_lite package/openwrt_msd_lite
# git clone --depth=1 https://github.com/riverscn/openwrt-iptvhelper package/openwrt-iptvhelper
###########################################################################
# wrtbwmon use small-packages
# rm -rf feeds/luci/applications/luci-app-wrtbwmon
# git clone --depth 1 https://github.com/brvphoenix/wrtbwmon package/wrtbwmon
# git clone --depth 1 https://github.com/brvphoenix/luci-app-wrtbwmon package/luci-app-wrtbwmon

# lucky
rm -rf feeds/packages/net/lucky
rm -rf feeds/luci/applications/luci-app-lucky
git clone --depth=1 https://github.com/gdy666/luci-app-lucky package/lucky

# msd_lite用23.05自带
# rm -rf feeds/packages/net/msd_lite
# rm -rf feeds/luci/applications/luci-app-msd_lite
# git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite
# git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite

# golang版本修复
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# mosdns
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/luci/applications/luci-app-mosdns
#git clone -b v5-lua --single-branch --depth 1 https://github.com/sbwml/luci-app-mosdns package/mosdns
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
sed -i 's/30/2/g' package/mosdns/luci-app-mosdns/root/usr/share/luci/menu.d/*.json

# 添加passwall
rm -rf feeds/luci/applications/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall

# nps
rm -rf feeds/packages/net/nps
rm -rf feeds/luci/applications/luci-app-nps
git clone --depth=1 https://github.com/djylb/nps-openwrt package/nps-openwrt

# Fix
git clone --depth=1 https://github.com/kenzok8/small-package package/small

# timecontrol
rm -rf feeds/luci/applications/luci-app-timecontrol
mv package/small/luci-app-timecontrol package/luci-app-timecontrol
sed -i 's/"admin", "control"/"admin", "network"/g' package/luci-app-timecontrol/luasrc/controller/*.lua

# openclash
rm -rf feeds/luci/applications/luci-app-openclash
mv package/small/luci-app-openclash package/luci-app-openclash
sed -i 's|("OpenClash"), 50)|("OpenClash"), 1)|g' package/luci-app-openclash/luasrc/controller/*.lua

# fileassistant
rm -rf feeds/luci/applications/luci-app-fileassistant
mv package/small/luci-app-fileassistant package/luci-app-fileassistant

# dockerman
rm -rf feeds/luci/applications/luci-app-dockerman
mv package/small/luci-app-dockerman package/luci-app-dockerman

# serverchan
rm -rf feeds/luci/applications/luci-app-serverchan
mv package/small/luci-app-wechatpush package/luci-app-wechatpush

# design主题,编译主题错误
# rm -rf feeds/luci/themes/luci-theme-design
# mv package/small/luci-theme-design package/luci-theme-design
# mv package/small/luci-app-design-config package/luci-app-design-config

# haproxy
# 添加lua5.4依赖
git clone --depth=1 https://github.com/immortalwrt/packages package/imm
# mv package/imm/lang/lua5.4 feeds/packages/lang/lua5.4
mv package/imm/lang/lua5.4 package/lua5.4
rm -rf package/imm
rm -rf feeds/packages/net/haproxy
mv package/small/haproxy feeds/packages/net/haproxy

# aria2
rm -rf feeds/packages/net/aria2
mv package/small/aria2 feeds/packages/net/aria2
# 调整到网络存储菜单
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aria2/root/usr/share/luci/menu.d/*.json

# netdata
rm -rf feeds/packages/admin/netdata
# git clone --depth=1 https://github.com/sirpdboy/openwrt-netdata feeds/packages/admin/netdata
rm -rf feeds/luci/applications/luci-app-netdata
mv package/small/netdata feeds/packages/admin/netdata
mv package/small/luci-app-netdata feeds/luci/applications/luci-app-netdata

# wrtbwmon
rm -rf feeds/luci/applications/luci-app-wrtbwmon
mv package/small/wrtbwmon package/wrtbwmon
mv package/small/luci-app-wrtbwmon package/luci-app-wrtbwmon

# iptvhelper
mv package/small/iptvhelper package/iptvhelper
mv package/small/luci-app-iptvhelper package/luci-app-iptvhelper

# cloudflarespeedtest
mv package/small/cdnspeedtest package/cdnspeedtest
mv package/small/luci-app-cloudflarespeedtest package/luci-app-cloudflarespeedtest

# dnsfilter
mv package/small/luci-app-dnsfilter package/luci-app-dnsfilter

mv package/small/luci-app-wolplus package/luci-app-wolplus
mv package/small/luci-app-poweroff package/luci-app-poweroff

# mv package/small/luci-app-msd_lite package/luci-app-msd_lite
# mv package/small/netdata package/netdata
# mv package/small/luci-app-netdata package/luci-app-netdata
# mv package/small/qbittorrent package/qbittorrent
# mv package/small/qt6base package/qt6base
# mv package/small/qt6tools package/qt6tools
# mv package/small/rblibtorrent package/rblibtorrent
# mv package/small/luci-app-qbittorrent package/luci-app-qbittorrent
rm -rf package/small

# argon主题
rm -rf feeds/luci/themes/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

# 晶晨宝盒
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic

# ddns-go
rm -rf feeds/packages/net/ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/ddnsgo

# NetSpeedTest编译报错
# git clone --depth=1 https://github.com/sirpdboy/NetSpeedTest package/NetSpeedTest

# alist
rm -rf feeds/packages/net/alist
rm -rf feeds/luci/applications/luci-app-alist
git clone --depth 1 https://github.com/sbwml/luci-app-alist package/alist

# Remove packages
#删除lean库中的插件，使用自定义源中的包。
rm -rf feeds/luci/applications/luci-app-wol
# rm -rf feeds/packages/net/qBittorrent
# rm -rf feeds/packages/net/qBittorrent-static
# rm -rf feeds/luci/applications/luci-app-qbittorrent

# 启用s, luci用自带, frp第三方更新版本
rm -rf feeds/packages/net/frp
rm -rf feeds/luci/applications/luci-app-frps
rm -rf feeds/luci/applications/luci-app-frpc
git clone https://github.com/kuoruan/openwrt-frp feeds/packages/net/frp
git clone --depth=1 https://github.com/superzjg/luci-app-frpc_frps package/luci-app-frpc_frps
# git clone https://github.com/kuoruan/openwrt-frp -b v0.53.2-1 feeds/packages/net/frp
# git clone https://github.com/user1121114685/frp.git feeds/packages/net/frp
# rm -rf feeds/luci/applications/luci-app-frps
# git clone https://github.com/user1121114685/luci-app-frps.git feeds/luci/applications/luci-app-frps


# Set DISTRIB_REVISION
#sed -i "s/R25.4.145 /Lein Build $(TZ=UTC-8 date "+%Y.%m.%d") For N1 /g" package/lean/default-settings/files/zzz-default-settings
sed -i 's#mount -t cifs#mount.cifs#g' feeds/luci/applications/luci-app-cifs-mount/root/etc/init.d/cifs
sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template

# 修改主机名
#sed -i 's/LEDE/OpenWrt/g' package/base-files/files/bin/config_generate
#sed -i 's/LEDE/OpenWrt/g' package/base-files/luci2/bin/config_generate

# Modify default IP   第一行19.07的路径   第二行23.05的路径
#sed -i 's/192.168.1.1/192.168.6.50/g' package/base-files/files/bin/config_generate
#sed -i 's/192.168.1.1/192.168.6.101/g' package/base-files/luci2/bin/config_generate

# 修改主题为默认
#sed -i 's/luci-theme-argon/luci-theme-bootstrap/g' ./feeds/luci/collections/luci/Makefile

# TTYD调整到系统菜单
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/*.json
sed -i 's/vpn/nas/g' feeds/luci/applications/luci-app-zerotier/root/usr/share/luci/menu.d/*.json

#修改默认时间格式
sed -i 's|os.date()|os.date("%Y/%m/%d %H:%M:%S %A")|g' $(find ./package/*/autocore/files/ -type f -name "index.htm")
# sed -i 's|os.date()|os.date("%Y年%m月%d日 %H:%M:%S %A")|g' $(find ./package/*/autocore/files/ -type f -name "index.htm")
