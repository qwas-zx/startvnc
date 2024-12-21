#!/bin/bash
#########################################################################
#    __     ___   _ ____    ____       _               
#    \ \   / / \ | / ___|  / ___|  ___| |_ _   _ _ __  
#     \ \ / /|  \| \___ \  \___ \ / _ \ __| | | | '_ \ 
#      \ V / | |\  |___) |  ___) |  __/ |_| |_| | |_) |
#       \_/  |_| \_|____/  |____/ \___|\__|\__,_| .__/ 
#                                                |_|    
#########################################################################
#
# VNC Server Setup Script
# Version: 1.0.0
#
# Author: Your Name
# GitHub: https://github.com/qwas-zx
# License: MIT License
#
# Copyright (c) 2024 Your Name
# All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#########################################################################
# 功能说明：
# 1. 支持安装 TurboVNC、TigerVNC、TightVNC 和 X2Go
# 2. 自动配置 Xfce 桌面环境
# 3. 提供服务管理功能
# 4. 包含完整的错误处理和依赖检查
#########################################################################
# 检测用户的shell配置文件
if [ -f "$HOME/.bashrc" ]; then
    CONFIG_FILE="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    CONFIG_FILE="$HOME/.zshrc"
else
    echo "未找到shell配置文件，环境变量设置已跳过。"
    exit 1
fi

# 设置环境变量
echo "export VNC_SETUP_SCRIPT=\"/path/to/your/script.sh\"" >> "$CONFIG_FILE"

# 重新加载配置文件以立即应用环境变量设置
source "$CONFIG_FILE"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查root权限
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}请使用root权限运行此脚本${NC}"
        exit 1
    fi
}

# 检查系统环境
check_system() {
    if [ ! -f /etc/debian_version ]; then
        echo -e "${RED}此脚本仅支持Debian/Ubuntu系统${NC}"
        exit 1
    fi
}

# 定义ASCII艺术标志
show_banner() {
    echo -e "${GREEN}"
    echo '██╗   ██╗███╗   ██╗ ██████╗    ███████╗███████╗████████╗██╗   ██╗██████╗ '
    echo '██║   ██║████╗  ██║██╔════╝    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗'
    echo '██║   ██║██╔██╗ ██║██║         ███████╗█████╗     ██║   ██║   ██║██████╔╝'
    echo '╚██╗ ██╔╝██║╚██╗██║██║         ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ '
    echo ' ╚████╔╝ ██║ ╚████║╚██████╗    ███████║███████╗   ██║   ╚██████╔╝██║     '
    echo '  ╚═══╝  ╚═╝  ╚═══╝ ╚═════╝    ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     '
    echo -e "${NC}"
}

# 定义一个函数来显示菜单
show_menu() {
    clear
    show_banner
    echo -e "${GREEN}==================================${NC}"
    echo -e "${YELLOW}      远程桌面安装配置脚本 v1.0    ${NC}"
    echo -e "${GREEN}==================================${NC}"
    echo -e "╭───────────────────────────────────╮"
    echo -e "│                                   │"
    echo -e "│  [1] ⚡ TurboVNC + Xfce           │"
    echo -e "│  [2] 🐯 TigerVNC + Xfce          │"
    echo -e "│  [3] 🔒 TightVNC + Xfce          │"
    echo -e "│  [4] 🌐 X2Go + Xfce              │"
    echo -e "│  [5] ⚙️  管理VNC服务             │"
    echo -e "│  [6] 🗑️  卸载已安装的VNC服务     │"
    echo -e "│  [7] 🚪 退出                     │"
    echo -e "│                                   │"
    echo -e "╰───────────────────────────────────╯"
    echo -e "${GREEN}==================================${NC}"
    read -p "请输入您的选择 [1-7]: " choice
}

# 定义VNC服务管理函数
manage_vnc_service() {
    clear
    echo -e "${GREEN}╭───────────── VNC服务管理 ─────────────╮${NC}"
    echo -e "${GREEN}│                                        │${NC}"
    echo -e "${GREEN}│  [1] 🟢 启动VNC服务                   │${NC}"
    echo -e "${GREEN}│  [2] 🔴 停止VNC服务                   │${NC}"
    echo -e "${GREEN}│  [3] 🔄 重启VNC服务                   │${NC}"
    echo -e "${GREEN}│  [4] 📊 查看VNC状态                   │${NC}"
    echo -e "${GREEN}│  [5] ↩️  返回主菜单                   │${NC}"
    echo -e "${GREEN}│                                        │${NC}"
    echo -e "${GREEN}╰────────────────────────────────────────╯${NC}"
    read -p "请选择操作 [1-5]: " vnc_choice

    case $vnc_choice in
        1)
            vncserver :1
            echo -e "${GREEN}VNC服务已启动${NC}"
            ;;
        2)
            vncserver -kill :1
            echo -e "${GREEN}VNC服务已停止${NC}"
            ;;
        3)
            vncserver -kill :1
            sleep 2
            vncserver :1
            echo -e "${GREEN}VNC服务已重启${NC}"
            ;;
        4)
            ps aux | grep Xvnc
            ;;
        5)
            return
            ;;
        *)
            echo -e "${RED}无效的选择${NC}"
            ;;
    esac
    read -p "按回车键继续..."
}

# 定义卸载函数
uninstall_vnc() {
    echo -e "${YELLOW}警告: 此操作将卸载所有VNC相关服务${NC}"
    read -p "是否继续? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
        apt remove --purge -y turbovnc tigervnc-* tightvncserver x2goserver
        apt autoremove -y
        rm -rf ~/.vnc
        echo -e "${GREEN}VNC服务已完全卸载${NC}"
    fi
}

# 定义错误处理函数
handle_error() {
    local exit_code=$?
    local command=$1
    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}错误: 执行 '$command' 失败${NC}"
        echo -e "${YELLOW}正在尝试修复...${NC}"
        return 1
    fi
    return 0
}

# 检查并安装必要的依赖
check_dependencies() {
    local dependencies=("curl" "wget" "vim" "gpg" "apt-transport-https" "software-properties-common")
    
    echo -e "${YELLOW}检查必要的依赖...${NC}"
    for dep in "${dependencies[@]}"; do
        if ! command -v $dep &> /dev/null; then
            echo -e "${YELLOW}正在安装 $dep...${NC}"
            apt update &> /dev/null
            apt install -y $dep || {
                echo -e "${RED}安装 $dep 失败${NC}"
                return 1
            }
        fi
    done
    return 0
}

# 定义重试函数
retry_command() {
    local max_attempts=3
    local command=$@
    local attempt=1

    until $command; do
        if ((attempt >= max_attempts)); then
            echo -e "${RED}执行命令 '$command' 失败，已达到最大重试次数${NC}"
            return 1
        fi
        echo -e "${YELLOW}命令失败，正在进行第 $attempt 次重试...${NC}"
        ((attempt++))
        sleep 2
    done
    return 0
}

# 定义文件完整性检查函数
check_files_integrity() {
    local vnc_type=$1
    local missing_files=()
    
    echo -e "${YELLOW}正在检查文件完整性...${NC}"
    
    case $vnc_type in
        "turbovnc")
            local required_files=(
                "/usr/bin/vncserver"
                "/usr/bin/Xvnc"
                "/usr/bin/vncpasswd"
                "/etc/turbovncserver.conf"
                "~/.vnc/xstartup"
            )
            ;;
        "tigervnc")
            local required_files=(
                "/usr/bin/vncserver"
                "/usr/bin/Xvnc"
                "/usr/bin/vncpasswd"
                "~/.vnc/xstartup"
            )
            ;;
        "tightvnc")
            local required_files=(
                "/usr/bin/tightvncserver"
                "/usr/bin/Xtightvnc"
                "/usr/bin/vncpasswd"
                "~/.vnc/xstartup"
            )
            ;;
        "x2go")
            local required_files=(
                "/usr/bin/x2goserver"
                "/etc/x2go/x2goserver.conf"
                "/usr/share/x2go"
            )
            ;;
    esac

    # 检查文件
    for file in "${required_files[@]}"; do
        if [ ! -e "$file" ]; then
            missing_files+=("$file")
        fi
    done

    # 如果有缺失文件，尝试修复
    if [ ${#missing_files[@]} -ne 0 ]; then
        echo -e "${YELLOW}检测到以下文件缺失:${NC}"
        printf '%s\n' "${missing_files[@]}"
        echo -e "${YELLOW}正在尝试修复...${NC}"
        
        case $vnc_type in
            "turbovnc")
                retry_command "apt install --reinstall turbovnc" || return 1
                # 重新创建配置文件
                mkdir -p ~/.vnc
                cp /opt/TurboVNC/bin/xstartup.turbovnc ~/.vnc/xstartup
                chmod +x ~/.vnc/xstartup
                ;;
            "tigervnc")
                retry_command "apt install --reinstall tigervnc-standalone-server tigervnc-common" || return 1
                # 重新创建配置文件
                mkdir -p ~/.vnc
                create_tigervnc_config
                ;;
            "tightvnc")
                retry_command "apt install --reinstall tightvncserver" || return 1
                # 重新创建配置文件
                mkdir -p ~/.vnc
                create_tightvnc_config
                ;;
            "x2go")
                retry_command "apt install --reinstall x2goserver x2goserver-xsession" || return 1
                systemctl restart x2goserver
                ;;
        esac

        # 再次检查文件
        local still_missing=()
        for file in "${missing_files[@]}"; do
            if [ ! -e "$file" ]; then
                still_missing+=("$file")
            fi
        done

        if [ ${#still_missing[@]} -ne 0 ]; then
            echo -e "${RED}以下文件修复失败:${NC}"
            printf '%s\n' "${still_missing[@]}"
            return 1
        else
            echo -e "${GREEN}所有文件已修复${NC}"
        fi
    else
        echo -e "${GREEN}文件完整性检查通过${NC}"
    fi
    return 0
}

# 创建TigerVNC配置文件
create_tigervnc_config() {
    cat > ~/.vnc/xstartup << EOF
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
    chmod +x ~/.vnc/xstartup
}

# 创建TightVNC配置文件
create_tightvnc_config() {
    cat > ~/.vnc/xstartup << EOF
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
    chmod +x ~/.vnc/xstartup
}

# 修改安装函数，添加文件完整性检查
install_turbovnc_xfce() {
    echo "安装TurboVNC和Xfce..."
    
    # 检查依赖
    check_dependencies || {
        echo -e "${RED}依赖检查失败，安装终止${NC}"
        return 1
    }

    # 添加TurboVNC的仓库
    retry_command "wget -q -O- https://packagecloud.io/dcommander/turbovnc/gpgkey | gpg --dearmor >/etc/apt/trusted.gpg.d/TurboVNC.gpg" || return 1
    retry_command "wget https://raw.githubusercontent.com/TurboVNC/repo/main/TurboVNC.list" || return 1
    mv TurboVNC.list /etc/apt/sources.list.d/

    # 更新并安装
    retry_command "apt update" || return 1
    retry_command "apt install -y turbovnc" || return 1

    # 创建软链接
    local binaries=("vncserver" "Xvnc" "vncconnect" "vncpasswd" "vncviewer" "webserver")
    for bin in "${binaries[@]}"; do
        ln -sf /opt/TurboVNC/bin/$bin /usr/bin/$bin || handle_error "创建 $bin 软链接"
    done

    # 安装Xfce
    retry_command "apt install -y xfce4 xfce4-goodies" || {
        echo -e "${RED}安装Xfce失败${NC}"
        return 1
    }

    # 设置环境变量
    export USER=root

    # 配置VNC
    mkdir -p ~/.vnc
    cp /opt/TurboVNC/bin/xstartup.turbovnc ~/.vnc/xstartup || handle_error "复制xstartup文件"
    chmod +x ~/.vnc/xstartup || handle_error "设置xstartup权限"

    # 启动VNC服务器
    vncserver -kill :1 &>/dev/null || true  # 如果已经运行，先关闭
    retry_command "vncserver :1" || {
        echo -e "${RED}启动VNC服务器失败${NC}"
        return 1
    }

    # 检查文件完整性
    check_files_integrity "turbovnc" || {
        echo -e "${RED}文件完整性检查失败${NC}"
        return 1
    }

    echo -e "${GREEN}TurboVNC安装完成！${NC}"
    return 0
}

# 定义一个函数来安装TigerVNC和Xfce
install_tigervnc_xfce() {
    echo "安装TigerVNC和Xfce..."
    # 安装TigerVNC服务器
    apt update && apt install tigervnc-standalone-server tigervnc-common -y
    # 安装Xfce和附加工具
    apt install xfce4 xfce4-goodies -y
    # 设置环境变量
    export USER=root
    # 设置VNC密码
    vncpasswd
    # 创建VNC配置目录
    mkdir -p ~/.vnc
    # 创建xstartup文件
    cat > ~/.vnc/xstartup << EOF
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
    # 给xstartup添加执行权限
    chmod +x ~/.vnc/xstartup
    # 启动VNC服务器
    vncserver :1
    check_files_integrity "tigervnc" || return 1
}

# 定义一个函数来安装TightVNC和Xfce
install_tightvnc_xfce() {
    echo "安装TightVNC和Xfce..."
    # 安装TightVNC服务器
    apt update && apt install tightvncserver -y
    # 安装Xfce和附加工具
    apt install xfce4 xfce4-goodies -y
    # 设置环境变量
    export USER=root
    # 设置VNC密码
    vncpasswd
    # 创建VNC配置目录
    mkdir -p ~/.vnc
    # 创建xstartup文件
    cat > ~/.vnc/xstartup << EOF
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
    # 给xstartup添加执行权限
    chmod +x ~/.vnc/xstartup
    # 启动VNC服务器
    vncserver :1
    check_files_integrity "tightvnc" || return 1
}

# 定义一个函数来安装X2Go和Xfce
install_x2go_xfce() {
    echo "安装X2Go和Xfce..."
    # 添加X2Go仓库
    add-apt-repository ppa:x2go/stable -y
    apt update
    # 安装X2Go服务器
    apt install x2goserver x2goserver-xsession -y
    # 安装Xfce和附加工具
    apt install xfce4 xfce4-goodies -y
    # 重启X2Go服务
    systemctl restart x2goserver
    echo "X2Go安装完成！请使用X2Go客户端接，连接信息："
    echo "主机：服务器IP"
    echo "登录类型：XFCE"
    echo "用户名：root"
    check_files_integrity "x2go" || return 1
}

# 显示安装完成信息
show_completion_info() {
    local vnc_type=$1
    echo -e "${GREEN}╭──────────── 安装完成 ────────────╮${NC}"
    echo -e "${GREEN}│                                  │${NC}"
    echo -e "${GREEN}│  ✅ 安装成功！                   │${NC}"
    echo -e "${GREEN}│                                  │${NC}"
    echo -e "${GREEN}│  📡 连接信息:                    │${NC}"
    echo -e "${GREEN}│  🌐 服务器IP: $(curl -s ifconfig.me)  │${NC}"
    echo -e "${GREEN}│  🔌 端口: 5901                   │${NC}"
    echo -e "${GREEN}│  👤 用户名: root                 │${NC}"
    echo -e "${GREEN}│                                  │${NC}"
    echo -e "${GREEN}│  📝 使用说明：                   │${NC}"
    echo -e "${GREEN}│  1. VNC服务器已在:1端口启动     │${NC}"
    echo -e "${GREEN}│  2. 请使用对应的VNC客户端连接   │${NC}"
    echo -e "${GREEN}│  3. 确保防火墙已开放5901端口    │${NC}"
    echo -e "${GREEN}│                                  │${NC}"
    echo -e "${GREEN}╰───────────────────────────────────╯${NC}"
}

# 主循环
check_root
check_system

# 添加清理函数
cleanup() {
    echo -e "${YELLOW}正   清理...${NC}"
    # 清理临时文件
    rm -f /tmp/vnc_* 2>/dev/null
    # 其他清理操作...
}

# 添加退出处理
trap cleanup EXIT

while true; do
    show_menu
    case $choice in
        1) 
            if install_turbovnc_xfce; then
                show_completion_info "TurboVNC"
            else
                echo -e "${RED}安装失败，请检查错误信息并重试${NC}"
                read -p "按回车键继续..."
            fi
            ;;
        2) 
            install_tigervnc_xfce
            show_completion_info "TigerVNC"
            ;;
        3) 
            install_tightvnc_xfce
            show_completion_info "TightVNC"
            ;;
        4) 
            install_x2go_xfce
            show_completion_info "X2Go"
            ;;
        5)
            manage_vnc_service
            ;;
        6)
            uninstall_vnc
            ;;
        7) 
            echo -e "${GREEN}感谢使用，再见！${NC}"
            break 
            ;;
        *) 
            echo -e "${RED}无效的选项，请重新输入。${NC}"
            sleep 1
            ;;
    esac
done