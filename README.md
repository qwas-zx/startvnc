# VNC Setup Script

## 项目简介

这个项目包含一个用于安装和管理VNC服务器的Bash脚本。该脚本支持TurboVNC、TigerVNC、TightVNC和X2Go，并自动配置Xfce桌面环境。它旨在简化VNC服务器的安装和配置过程，使用户能够快速搭建远程桌面环境。

## 优点

1. **自动化安装与配置**：
   - 自动化安装多种VNC服务器（TurboVNC、TigerVNC、TightVNC和X2Go）以及Xfce桌面环境。
   - 提供了完整的依赖检查和安装过程，确保所有必要的软件包都已正确安装。

2. **用户友好界面**：
   - 提供了一个交互式菜单，用户可以通过简单的数字选择来执行不同的操作（如安装、管理、卸载VNC服务等）。
   - 使用ASCII艺术和颜色编码的输出，使脚本的运行更加直观和易读。

3. **错误处理与重试机制**：
   - 包含详细的错误处理函数，能够在命令执行失败时提供有用的错误信息，并尝试修复问题。
   - 实现了重试机制，对于某些关键步骤（如下载文件或安装软件包），如果第一次失败会自动重试。

4. **文件完整性检查**：
   - 在安装完成后，脚本会检查必要的文件是否存在，并尝试修复缺失的文件，确保安装的完整性和稳定性。

5. **服务管理功能**：
   - 提供了启动、停止、重启和查看VNC服务状态的功能，方便用户管理和维护VNC服务。

6. **卸载功能**：
   - 提供了卸载所有VNC相关服务的功能，确保系统在不需要VNC服务时可以彻底清理相关组件。

7. **环境变量设置**：
   - 自动检测用户的shell配置文件（如 `.bashrc` 或 `.zshrc`），并设置必要的环境变量，确保脚本可以在不同环境中正常工作。

8. **兼容性与可移植性**：
   - 该脚本专门针对Debian/Ubuntu系统进行了优化，但其设计思路和实现方式也适用于其他类Unix系统。

## 下载与安装

要下载并使用这个项目，请运行以下命令：

```bash
git clone https://github.com/qwas-zx/vnc-setup.git
cd vnc-setup
chmod +x startvnc.sh
./startvnc.sh
```
或
```bash
curl -sSL https://raw.githubusercontent.com/qwas-zx/startvnc/main/startvnc.sh | bash
```
## 使用说明
  - 克隆项目到本地。
  - 进入项目目录。
  - 赋予脚本执行权限。
  - 运行脚本并按照提示进行操作。

---

> 感谢您使用VNC Setup Script！如果您有任何问题或建议，请随时在GitHub上提交issue。

安装完成后，可以通过运行 `./startvnc.sh` 来启动脚本，并按照提示进行操作。脚本将引导您完成VNC服务器的安装、配置和管理过程。

## 注意事项

请确保在运行脚本之前，您的系统已经连接到互联网，并且具有适当的权限来安装和配置软件包。

## 联系方式

如果您在使用过程中遇到任何问题，或者有任何建议和反馈，请通过项目的GitHub页面提交.
