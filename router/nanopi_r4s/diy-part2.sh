#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/op
# Description: Automatically Build OpenWrt for Nanopi R4s
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Copyright (C) 2020 https://github.com/P3TERX/Actions-OpenWrt
# Copyright (C) 2020 https://github.com/ophub/op
#========================================================================================================================

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile
# Modify default root's password（FROM 'password'[$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.] CHANGE TO 'your password'）
# sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

# Mydiy-luci-app-and-theme（use to /.config luci-app&theme）
# ==========luci-app-url==========
# git clone https://github.com/kenzok8/openwrt-packages.git package/openwrt-packages
# ==========luci-theme-url==========
# git clone https://github.com/openwrt-develop/luci-theme-atmaterial.git package/luci-theme-atmaterial
# svn co https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw/luci-theme-edge package/luci-theme-edge

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings

#使用源码自带ShadowSocksR Plus+出国软件
#sed -i 's/#src-git helloworld/src-git helloworld/g' ./feeds.conf.default

#添加额外软件包
rm -rf package/lean/luci-app-dockerman
git clone https://github.com/lisaac/luci-app-dockerman.git package/lean/luci-app-dockerman
git clone https://github.com/Lienol/openwrt-package.git package/openwrt-package
git clone https://github.com/xiaorouji/openwrt-passwall.git package/openwrt-passwall
git clone https://github.com/fw876/helloworld.git package/luci-app-ssr-plus
git clone https://github.com/vernesong/OpenClash.git package/luci-app-openclash
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
rm -rf package/lean/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
svn co https://github.com/garypang13/openwrt-packages/trunk/smartdns-le package/smartdns-le
git clone https://github.com/garypang13/luci-app-bypass.git package/luci-app-bypass
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
#rm -rf package/lean/v2ray
#svn co https://github.com/8688Add/Lienol-openwrt-package/trunk/package/v2ray package/lean/v2ray
svn co https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom/trunk/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
#svn co https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw/luci-app-gost package/lean/luci-app-gost
#svn co https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw/gost package/lean/gost

#修改bypass的makefile
find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-redir/shadowsocksr-libev-alt/g' {}
find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-server/shadowsocksr-libev-server/g' {}
