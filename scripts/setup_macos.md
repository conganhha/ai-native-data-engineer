# Setup macOS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git python@3.11
brew install --cask visual-studio-code docker dbeaver-community
```

Mở Docker Desktop một lần, sau đó:
```bash
python3.11 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
./scripts/preflight_macos.sh
```
