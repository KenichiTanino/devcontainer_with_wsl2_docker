# WSL2 Dev Container 設定 with podman

## 概要

このリポジトリには、VS Code の Dev Container 設定が含まれています。
ここでは WSL2 上で、podman を使用する方法を記載しています。

## 設定ファイル

- `.devcontainer/devcontainer.json`: Dev Container の主要な設定ファイルです。
  - `name`: Dev Container の名前を定義します。
  - `build.dockerfile`: 使用する`Dockerfile`のパスを指定します。
  - `workspaceFolder`: コンテナ内のワークスペースのパスを指定します。
  - `customizations.vscode.extensions`: Dev Container 内でインストールする VS Code 拡張機能を指定します。
- `Dockerfile`: Docker イメージをビルドするための手順を定義します。
  - `FROM`: ベースとなる Docker イメージを指定します。

## VS Code での利用手順

1. **Docker Desktop のインストール**: まだインストールしていない場合は、[Docker Desktop](https://www.docker.com/products/docker-desktop)をインストールしてください。
2. **VS Code 拡張機能のインストール**: VS Code の拡張機能マーケットプレイスから、「[Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)」をインストールします。
3. **リポジトリを開く**: VS Code でこのリポジトリのフォルダを開きます。
4. **Dev Container で開く**: VS Code の左下にある緑色のリモートウィンドウインジケーターをクリックし、表示されるメニューから「Reopen in Container」を選択します。または、コマンドパレット（`Ctrl+Shift+P`または`Cmd+Shift+P`）を開き、「Dev Containers: Reopen in Container」を実行します。
5. **ビルドの待機**: 初回起動時は、Docker イメージのビルドとコンテナの作成が行われます。これには数分かかる場合があります。VS Code のターミナルに進捗状況が表示されます。
6. **開発開始**: ビルドが完了すると、VS Code がコンテナに接続された状態で再読み込みされます。これで、コンテナ内の環境で開発を開始できます。

## vscode での設定

vscode の settings.json に以下を追加する必要があります。
dev.containers.dockerComposePath は podman-compose を使用する場合には設定します。

```
  "dev.containers.dockerPath": "podman",
  "dev.containers.dockerComposePath": "podman-compose",
  "dev.containers.dockerSocketPath": "",
```

## devcontainer.json に docker-compose.yml を指定する場合

devcontainer.json を以下のようにすれば docker-compose.yml を指定できます。

```
{
    "name": "Docker Compose",
    "dockerComposeFile": "docker-compose.yml",
    "service": "app",
    "workspaceFolder": "/workspace",
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-python.python"
            ]
        }
    }
}
```

ただし、上記のようにした場合、WSL2 の devcontainer の場合、デフォルトでは root で起動するので docker-compose.yml 内の context は/root が基準になります。よって fullpath にする必要があります。

```
      # WSL2 does not support build context as a relative path
      # context: current directory(fullpath)..
      dockerfile: ../Dockerfile
```
