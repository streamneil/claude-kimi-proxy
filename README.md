# Claude Kimi Proxy

**中文** | [English](README_EN.md)

使用 Kimi、Groq、Novita 或 OpenRouter 的强大模型，全面驱动和增强您的 Claude Code 开发体验。

## 功能特性

- 🚀 **多模型支持**: 无缝切换 Kimi、Groq、Novita、OpenRouter 等多种高效模型。
- 🔑 **简易配置**: 脚本引导式 API Key 配置，自动设置环境变量。
- ⚡ **一键安装**: 提供自动化安装脚本，简化 Node.js 和 Claude Code 的安装流程。
- 🛡️ **安全可靠**: 脚本开源，配置过程透明，保障您的 API Key 安全。
- 🔄 **模型路由 (可选)**: 支持安装 `claude-code-router`，实现更灵活的多模型切换策略。

## 快速开始

### 1. 一键安装

在您的终端中运行以下命令，即可开始自动化安装：

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/streamneil/claude-kimi-proxy/main/install.sh)"
```

安装脚本将引导您完成以下步骤：
1.  **检测并安装 Node.js** (如果未安装或版本过低)。
2.  **安装 Claude Code**。
3.  **选择 API 提供商** (Moonshot, Novita, Groq, OpenRouter)。
4.  **输入您的 API Key**。
5.  **自动配置环境变量**。

### 2. 手动配置环境变量

如果您希望手动配置，可以设置以下环境变量。请根据您选择的 API 提供商调整 `ANTHROPIC_BASE_URL`。

```bash
# .bashrc, .zshrc, or .profile
export ANTHROPIC_API_KEY="YOUR_API_KEY"
export ANTHROPIC_BASE_URL="<YOUR_CHOSEN_API_BASE_URL>"
export ANTHROPIC_AUTH_TOKEN="<YOUR_CHOSEN_API_KEY>"

# 例如，使用 Moonshot AI:
export ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
```

### 3. API 提供商

脚本支持以下 API 提供商，您可以根据需求选择：

| 提供商 | 基础 URL | 特点 |
| :--- | :--- | :--- |
| **Moonshot AI** | `https://api.moonshot.cn/anthropic/` | 官方推荐，性能稳定 |
| **Novita AI** | `https://api.novita.ai/anthropic` | 成本效益高 |
| **Groq** | `https://api.groq.com/openai/v1/chat/completions` | 速度极快 |
| **OpenRouter** | `https://openrouter.ai/api/v1/chat/completions` | 模型选择多样 |

> **注意**: 当使用 Groq 或 OpenRouter 时，脚本会自动为您配置 `ANTHROPIC_MODEL` 和 `ANTHROPIC_SMALL_FAST_MODEL` 环境变量，以确保兼容性。

## 如何使用

1.  **重启您的终端** 或运行 `source ~/.bashrc` / `source ~/.zshrc` 来加载新的环境变量。
2.  启动 Claude Code：
    ```bash
    claude
    ```

## 高级功能

### Claude Code Router (可选)

为了更灵活地管理和切换多个模型，安装脚本提供了安装 `claude-code-router` 的选项。

如果您在安装过程中选择安装此工具，可以使用以下命令启动：
```bash
cr code
```
这使您能够根据项目需求或个人偏好，轻松地在不同模型之间切换。

## 开发说明

### 本地开发

1.  克隆项目：
    ```bash
    git clone https://github.com/streamneil/claude-kimi-proxy.git
    cd claude-kimi-proxy
    ```

2.  安装依赖：
    ```bash
    npm install
    ```

3.  启动开发服务器：
    ```bash
    npm run dev
    ```

### 构建

```bash
npm run build
```

## 许可证

本项目基于 MIT 许可证。详情请见 [LICENSE](LICENSE) 文件。

## 支持与反馈

如果您遇到任何问题或有功能建议，请随时在 [GitHub Issues](https://github.com/streamneil/claude-kimi-proxy/issues) 中提出。
