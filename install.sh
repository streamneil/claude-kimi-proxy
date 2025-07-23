#!/bin/bash

# Kimi K2 + Claude Code 自动安装脚本
# 支持多种配置方式和平台

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# 检测操作系统
detect_os() {
    case "$(uname -s)" in
        Linux*)     OS=Linux;;
        Darwin*)    OS=Mac;;
        CYGWIN*)    OS=Cygwin;;
        MINGW*)     OS=MinGw;;
        *)          OS="UNKNOWN:$(uname -s)"
    esac
    print_message $BLUE "检测到操作系统: $OS"
}

# 安装Node.js
install_nodejs() {
    print_message $YELLOW "🚀 正在安装Node.js..."
    
    if command -v node >/dev/null 2>&1; then
        current_version=$(node -v | sed 's/v//')
        major_version=$(echo $current_version | cut -d. -f1)
        
        if [ "$major_version" -ge 18 ]; then
            print_message $GREEN "✅ Node.js已安装: v$current_version"
            return
        else
            print_message $YELLOW "⚠️ Node.js版本过低 (v$current_version)，正在升级..."
        fi
    fi

    case "$OS" in
        Linux|Mac)
            # 安装nvm
            print_message $BLUE "📥 下载并安装nvm..."
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
            
            # 加载nvm环境
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            
            # 安装Node.js
            print_message $BLUE "📦 安装Node.js v22..."
            nvm install 22
            nvm use 22
            ;;
        *)
            print_message $RED "❌ 不支持的操作系统: $OS"
            print_message $YELLOW "请手动安装Node.js 18+版本"
            exit 1
            ;;
    esac
    
    print_message $GREEN "✅ Node.js安装完成! 版本: $(node -v)"
}

# 安装Claude Code
install_claude_code() {
    if command -v claude >/dev/null 2>&1; then
        print_message $GREEN "✅ Claude Code已安装: $(claude --version)"
    else
        print_message $YELLOW "📦 正在安装Claude Code..."
        npm install -g @anthropic-ai/claude-code
        print_message $GREEN "✅ Claude Code安装完成!"
    fi
}

# 配置Claude Code跳过引导
configure_claude_skip_onboarding() {
    print_message $BLUE "⚙️ 配置Claude Code跳过引导..."
    
    node -e "
    const fs = require('fs');
    const path = require('path');
    const os = require('os');
    
    const homeDir = os.homedir();
    const filePath = path.join(homeDir, '.claude.json');
    
    try {
        let content = {};
        if (fs.existsSync(filePath)) {
            content = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
        }
        content.hasCompletedOnboarding = true;
        fs.writeFileSync(filePath, JSON.stringify(content, null, 2), 'utf-8');
        console.log('✅ Claude配置更新完成');
    } catch (error) {
        console.error('❌ Claude配置失败:', error.message);
    }
    "
}

# 获取API密钥
get_api_key() {
    echo
    print_message $YELLOW "🔑 请选择API提供商:"
    echo "1) Moonshot AI官方 (推荐) - https://platform.moonshot.cn/"
    echo "2) Novita AI (成本更低) - https://novita.ai/"
    echo "3) Groq (速度更快) - https://groq.com/"
    echo "4) OpenRouter (模型更多) - https://openrouter.ai/"
    echo
    read -p "请选择 (1-4): " provider_choice
    
    case $provider_choice in
        1)
            API_PROVIDER="moonshot"
            API_BASE_URL="https://api.moonshot.cn/anthropic/"
            print_message $BLUE "ℹ️ 请从以下地址获取API密钥: https://platform.moonshot.cn/console/api-keys"
            ;;
        2)
            API_PROVIDER="novita"
            API_BASE_URL="https://api.novita.ai/anthropic"
            print_message $BLUE "ℹ️ 请从以下地址获取API密钥: https://novita.ai/"
            ;;
        3)
            API_PROVIDER="groq"
            API_BASE_URL="https://api.groq.com/openai/v1/chat/completions"
            print_message $BLUE "ℹ️ 请从以下地址获取API密钥: https://groq.com/"
            ;;
        4)
            API_PROVIDER="openrouter"
            API_BASE_URL="https://openrouter.ai/api/v1/chat/completions"
            print_message $BLUE "ℹ️ 请从以下地址获取API密钥: https://openrouter.ai/"
            ;;
        *)
            print_message $RED "❌ 无效选择，默认使用Moonshot AI"
            API_PROVIDER="moonshot"
            API_BASE_URL="https://api.moonshot.cn/anthropic/"
            ;;
    esac
    
    echo
    print_message $YELLOW "🔑 请输入您的API密钥:"
    print_message $BLUE "   (输入内容已隐藏，直接粘贴密钥后按回车)"
    echo
    read -s api_key
    echo
    
    if [ -z "$api_key" ]; then
        print_message $RED "❌ API密钥不能为空，请重新运行脚本"
        exit 1
    fi
    
    print_message $GREEN "✅ API密钥设置完成"
}

# 检测当前Shell并配置环境变量
configure_environment() {
    # 检测当前shell
    current_shell=$(basename "$SHELL")
    case "$current_shell" in
        bash)
            rc_file="$HOME/.bashrc"
            ;;
        zsh)
            rc_file="$HOME/.zshrc"
            ;;
        fish)
            rc_file="$HOME/.config/fish/config.fish"
            ;;
        *)
            rc_file="$HOME/.profile"
            ;;
    esac
    
    print_message $BLUE "📝 正在配置环境变量到 $rc_file..."
    
    # 备份现有配置文件
    if [ -f "$rc_file" ]; then
        cp "$rc_file" "${rc_file}.backup.$(date +%Y%m%d_%H%M%S)"
        print_message $GREEN "✅ 已备份原配置文件"
    fi
    
    # 检查是否已存在配置
    if [ -f "$rc_file" ] && grep -q "ANTHROPIC_BASE_URL\|ANTHROPIC_API_KEY" "$rc_file"; then
        print_message $YELLOW "⚠️ 检测到已存在的环境变量配置"
        read -p "是否覆盖现有配置? (y/N): " overwrite
        if [[ $overwrite =~ ^[Yy]$ ]]; then
            # 删除旧配置
            sed -i.bak '/ANTHROPIC_BASE_URL\|ANTHROPIC_API_KEY\|# Claude Code environment variables/d' "$rc_file"
        else
            print_message $YELLOW "⚠️ 跳过环境变量配置，请手动设置:"
            echo "export ANTHROPIC_BASE_URL=$API_BASE_URL"
            echo "export ANTHROPIC_API_KEY=$api_key"
            echo "export ANTHROPIC_AUTH_TOKEN=$api_key"

            return
        fi
    fi
    
    # 添加新配置
    {
        echo ""
        echo "# Claude Code environment variables - Auto generated by kimi-cc installer"
        echo "export ANTHROPIC_BASE_URL=$API_BASE_URL"
        echo "export ANTHROPIC_API_KEY=$api_key"
        echo "export ANTHROPIC_AUTH_TOKEN=$api_key"
        if [ "$API_PROVIDER" = "groq" ] || [ "$API_PROVIDER" = "openrouter" ]; then
            echo "export ANTHROPIC_MODEL=moonshotai/kimi-k2-instruct"
            echo "export ANTHROPIC_SMALL_FAST_MODEL=moonshotai/kimi-k2-instruct"
        fi
    } >> "$rc_file"
    
    print_message $GREEN "✅ 环境变量已添加到 $rc_file"
    
    # 立即导出变量供当前会话使用
    export ANTHROPIC_BASE_URL=$API_BASE_URL
    export ANTHROPIC_API_KEY=$api_key
}

# 测试连接
test_connection() {
    print_message $YELLOW "🧪 正在测试API连接..."
    
    # 简单的测试请求
    if command -v curl >/dev/null 2>&1; then
        case $API_PROVIDER in
            moonshot)
                test_url="https://api.moonshot.cn/v1/models"
                auth_header="Authorization: Bearer $api_key"
                ;;
            *)
                print_message $BLUE "ℹ️ 跳过连接测试，请启动Claude Code验证配置"
                return
                ;;
        esac
        
        if curl -s -H "$auth_header" "$test_url" > /dev/null; then
            print_message $GREEN "✅ API连接测试成功!"
        else
            print_message $YELLOW "⚠️ API连接测试失败，请检查密钥是否正确"
        fi
    fi
}

# 安装Claude Code Router (可选)
install_router() {
    echo
    read -p "是否安装Claude Code Router以支持多模型切换? (y/N): " install_router_choice
    
    if [[ $install_router_choice =~ ^[Yy]$ ]]; then
        print_message $YELLOW "📦 正在安装Claude Code Router..."
        npm install -g @musistudio/claude-code-router
        
        # 创建路由器配置
        router_config_dir="$HOME/.claude-code-router"
        mkdir -p "$router_config_dir"
        
        cat > "$router_config_dir/config.json" << EOF
{
  "LOG": false,
  "Providers": [
    {
      "name": "$API_PROVIDER",
      "api_base_url": "$API_BASE_URL",
      "api_key": "$api_key",
      "models": ["kimi-k2"],
      "transformer": {
        "use": [
          ["maxtoken", { "max_tokens": 16384 }],
          "openrouter"
        ]
      }
    }
  ],
  "Router": {
    "default": "$API_PROVIDER,kimi-k2"
  }
}
EOF
        
        print_message $GREEN "✅ Claude Code Router安装完成!"
        print_message $BLUE "ℹ️ 使用 'cr code' 命令启动路由器版本"
    fi
}

# 显示使用说明
show_usage() {
    echo
    print_message $GREEN "🎉 安装完成！"
    echo
    print_message $BLUE "📋 使用说明:"
    echo "1. 重启终端或运行: source $rc_file"
    echo "2. 启动Claude Code: claude"
    if [[ $install_router_choice =~ ^[Yy]$ ]]; then
        echo "3. 或使用路由器版本: cr code"
    fi
    echo
    print_message $YELLOW "💡 提示:"
    echo "- Kimi K2相比Claude Sonnet成本降低80%以上"
    echo "- 支持128K上下文窗口"
    echo "- 在SWE-bench Verified上达到65.8%的成绩"
    echo
    print_message $BLUE "🔗 相关链接:"
    echo "- Claude Code文档: https://docs.anthropic.com/claude/docs/claude-code"
    echo "- Kimi API文档: https://platform.moonshot.cn/docs/"
    echo "- 问题反馈: https://github.com/LLM-Red-Team/kimi-cc/issues"
}

# 主函数
main() {
    print_message $GREEN "🚀 Kimi K2 + Claude Code 自动安装脚本"
    print_message $BLUE "================================================"
    echo
    
    detect_os
    install_nodejs
    install_claude_code
    configure_claude_skip_onboarding
    get_api_key
    configure_environment
    test_connection
    install_router
    show_usage
}

# 错误处理
trap 'print_message $RED "❌ 安装过程中出现错误，请检查上面的错误信息"' ERR

# 运行主函数
main "$@"
