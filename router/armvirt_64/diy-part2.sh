#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/op
# Description: Automatically Build OpenWrt for Armvirt 64
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Copyright (C) 2020 https://github.com/P3TERX/Actions-OpenWrt
# Copyright (C) 2020 https://github.com/ophub/op
#========================================================================================================================

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
sed -i 's/192.168.1.1/192.168.1.10/g' package/base-files/files/bin/config_generate
sed -i 's/services/system/g' package/lean/luci-app-cpufreq/luasrc/controller/cpufreq.lua
sed -i 's/DEPENDS:=@(.*/DEPENDS:=@(TARGET_bcm27xx||TARGET_bcm53xx||TARGET_ipq40xx||TARGET_ipq806x||TARGET_mvebu||TARGET_sunxi||TARGET_rockchip||TARGET_armvirt) \\/g' package/lean/autocore/Makefile

# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Modify default root's password（FROM 'password'[$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.] CHANGE TO 'your password'）
# sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Add third-party software packages (The entire repository)
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

# Apply patch
# git apply ../router-config/patches/{0001*,0002*}.patch --directory=feeds/luci

# Modify some code adaptation
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile

# Mydiy luci-app and luci-theme（use to /.config luci-app&theme）
# ==========luci-app-url==========
# git clone https://github.com/kenzok8/openwrt-packages.git package/openwrt-packages
# ==========luci-theme-url==========
# svn co https://github.com/Lienol/openwrt-package/trunk/lienol/luci-theme-bootstrap-mod package/luci-theme-bootstrap-mod

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
#sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings

#使用源码自带ShadowSocksR Plus+出国软件
#sed -i 's/#src-git helloworld/src-git helloworld/g' ./feeds.conf.default

#添加额外软件包
#rm -rf package/lean/luci-app-dockerman
git clone https://github.com/lisaac/luci-app-dockerman.git package/luci-app-dockerman
#git clone https://github.com/0118Add/sirpdboy-package.git package/sirpdboy-package
git clone https://github.com/Lienol/openwrt-package.git package/openwrt-package
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/brook package/brook
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/chinadns-ng package/chinadns-ng
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-go package/trojan-go
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-plus package/trojan-plus
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ssocks package/ssocks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall package/luci-app-passwall
svn co https://github.com/fw876/helloworld/trunk/xray-core package/xray-core
svn co https://github.com/fw876/helloworld/trunk/xray-plugin package/xray-plugin
svn co https://github.com/fw876/helloworld/trunk/shadowsocks-rust package/shadowsocks-rust
svn co https://github.com/fw876/helloworld/trunk/shadowsocksr-libev package/shadowsocksr-libev
svn co https://github.com/fw876/helloworld/trunk/v2ray-plugin package/v2ray-plugin
svn co https://github.com/fw876/helloworld/trunk/tcping package/tcping
svn co https://github.com/fw876/helloworld/trunk/naiveproxy package/naiveproxy
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
git clone https://github.com/vernesong/OpenClash.git package/luci-app-openclash
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
rm -rf package/lean/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
#svn co https://github.com/garypang13/openwrt-packages/trunk/smartdns-le package/smartdns-le
#git clone https://github.com/garypang13/luci-app-bypass.git package/luci-app-bypass
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
git clone https://github.com/tuanqing/install-program.git package/install-program
#rm -rf package/lean/v2ray-plugin
#svn co https://github.com/xiaorouji/openwrt-passwall/trunk/v2ray-plugin package/v2ray-plugin
svn co https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom/trunk/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
#svn co https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw/luci-app-gost package/lean/luci-app-gost
#svn co https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw/gost package/lean/gost

#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-vssr/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-alt/shadowsocksr-libev-ssr-redir/g' {}
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-vssr/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-server/shadowsocksr-libev-ssr-server/g' {}
