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

# Add packages
#添加科学上网源
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/ddnsgo
git clone --depth=1 https://github.com/0x676e67/luci-theme-design package/luci-theme-design
git clone --depth=1 https://github.com/0x676e67/luci-app-design-config package/luci-app-design-config
git clone -b v3.35.0 --single-branch --depth 1 https://github.com/sbwml/luci-app-alist package/luci-app-alist

# iStore
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci

#只能用3.35版本
#git_sparse_clone master https://github.com/sbwml/luci-app-alist alist
#git_sparse_clone v3.35.0 https://github.com/sbwml/luci-app-alist luci-app-alist

#git_sparse_clone master https://github.com/kiddin9/openwrt-packages softethervpn5
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-softethervpn
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-openvpn-server
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages openvpn-dns-hotplug
#git_sparse_clone master https://github.com/immortalwrt/packages net/samba4
#git_sparse_clone master https://github.com/immortalwrt/luci applications/luci-app-samba4
#git_sparse_clone master https://github.com/immortalwrt/packages net/openvpn
#git_sparse_clone master https://github.com/immortalwrt/packages net/openvpn-easy-rsa
#git_sparse_clone master https://github.com/immortalwrt/luci applications/luci-app-openvpn-server

# Remove packages
#rm -rf package/small-package/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd*,miniupnpd-iptables,natflow,wireless-regdb}
#删除lean库中的插件，使用自定义源中的包。
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-design
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/luci/applications/luci-app-design-config
#删除默认的softethvpn
#rm -rf feeds/packages/net/softethervpn5
#rm -rf feeds/luci/applications/luci-app-softethervpn
#删除默认的openvpn
#rm -rf feeds/packages/net/openvpn
#rm -rf feeds/packages/net/openvpn-easy-rsa
#rm -rf feeds/luci/applications/luci-app-openvpn-server
#删除默认的samba4
#rm -rf feeds/packages/net/samba4
#rm -rf feeds/luci/applications/luci-app-samba4 luci-app-samba4

# Default IP
sed -i 's/192.168.1.1/192.168.2.2/g' package/base-files/files/bin/config_generate