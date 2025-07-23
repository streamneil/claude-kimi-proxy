# Claude Kimi Proxy

[中文](README.md) | **English**

Enhance your Claude Code development experience with powerful models from Kimi, Groq, Novita, or OpenRouter.

## Features

- 🚀 **Multi-Model Support**: Seamlessly switch between Kimi, Groq, Novita, OpenRouter, and other efficient models.
- 🔑 **Easy Configuration**: Script-guided API key configuration with automatic environment variable setup.
- ⚡ **One-Click Installation**: Automated installation script simplifies Node.js and Claude Code setup.
- 🛡️ **Secure & Reliable**: Open-source scripts with transparent configuration process to protect your API keys.
- 🔄 **Model Router (Optional)**: Supports installation of `claude-code-router` for more flexible multi-model switching strategies.

## Quick Start

### 1. One-Click Installation

Run the following command in your terminal to begin automated installation:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/streamneil/claude-kimi-proxy/main/install.sh)"
```

The installation script will guide you through these steps:
1.  **Detect and install Node.js** (if not installed or version is too low).
2.  **Install Claude Code**.
3.  **Choose API provider** (Moonshot, Novita, Groq, OpenRouter).
4.  **Enter your API key**.
5.  **Automatically configure environment variables**.

### 2. Manual Environment Variable Configuration

If you prefer to configure manually, you can set these environment variables. Please adjust `ANTHROPIC_BASE_URL` according to your chosen API provider.

```bash
# .bashrc, .zshrc, or .profile
export ANTHROPIC_API_KEY="YOUR_API_KEY"
export ANTHROPIC_BASE_URL="<YOUR_CHOSEN_API_BASE_URL>"
export ANTHROPIC_AUTH_TOKEN="<YOUR_CHOSEN_API_KEY>"

# For example, using Moonshot AI:
export ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
```

### 3. API Providers

The script supports the following API providers. Choose based on your needs:

| Provider | Base URL | Features |
| :--- | :--- | :--- |
| **Moonshot AI** | `https://api.moonshot.cn/anthropic/` | Official recommendation, stable performance |
| **Novita AI** | `https://api.novita.ai/anthropic` | Cost-effective |
| **Groq** | `https://api.groq.com/openai/v1/chat/completions` | Extremely fast |
| **OpenRouter** | `https://openrouter.ai/api/v1/chat/completions` | Diverse model selection |

> **Note**: When using Groq or OpenRouter, the script will automatically configure `ANTHROPIC_MODEL` and `ANTHROPIC_SMALL_FAST_MODEL` environment variables for compatibility.

## How to Use

1.  **Restart your terminal** or run `source ~/.bashrc` / `source ~/.zshrc` to load the new environment variables.
2.  Start Claude Code:
    ```bash
    claude
    ```

## Advanced Features

### Claude Code Router (Optional)

For more flexible management and switching between multiple models, the installation script provides an option to install `claude-code-router`.

If you choose to install this tool during the installation process, you can start it with:
```bash
cr code
```
This allows you to easily switch between different models based on project requirements or personal preferences.

## Development

### Local Development

1.  Clone the project:
    ```bash
    git clone https://github.com/streamneil/claude-kimi-proxy.git
    cd claude-kimi-proxy
    ```

2.  Install dependencies:
    ```bash
    npm install
    ```

3.  Start development server:
    ```bash
    npm run dev
    ```

### Build

```bash
npm run build
```

## License

This project is based on the MIT License. See the [LICENSE](LICENSE) file for details.

## Support & Feedback

If you encounter any issues or have feature suggestions, please feel free to open an issue on [GitHub Issues](https://github.com/streamneil/claude-kimi-proxy/issues).