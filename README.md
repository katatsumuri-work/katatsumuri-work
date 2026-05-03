# katatsumuri-work

合同会社カタツムリワークス / Katatsumuri Works LLC のアンブレラリポジトリです。各プロジェクトは submodule として束ねられています。

## Submodules

| path | repo | visibility | description |
|------|------|------------|-------------|
| `api/` | [katatsumuri-work/api](https://github.com/katatsumuri-work/api) | public | Self-introducing API written in Rust (axum + utoipa) |
| `blog/` | [katatsumuri-work/blog](https://github.com/katatsumuri-work/blog) | public | Tech blog (Hugo) |
| `web/` | [katatsumuri-work/web](https://github.com/katatsumuri-work/web) | public | Frontend (Astro / TBD) |
| `infra/` | [katatsumuri-work/infra](https://github.com/katatsumuri-work/infra) | private | Infrastructure as Code, deployment configs, secrets |

org プロフィール用の [`katatsumuri-work/.github`](https://github.com/katatsumuri-work/.github) は独立して存在しており、本 repo の submodule には含めていません（各 repo の `.github/workflows/` と項目名が衝突するため）。

## Clone

```sh
git clone --recurse-submodules git@github.com:katatsumuri-work/katatsumuri-work.git
```

既に clone 済みの場合：

```sh
git submodule update --init --recursive
```

## Update submodules

```sh
git submodule update --remote --merge
```

## AI エージェントルール

このリポジトリ群は AI コーディングエージェント（Claude Code、Codex CLI、Gemini Code Assist、GitHub Copilot 等）に向けた共通ルールを `AGENTS.md` に定めています。各エージェント固有のファイル（`CLAUDE.md` / `GEMINI.md` / `.github/copilot-instructions.md`）は `AGENTS.md` を参照するポインタになっています。

### Single Source of Truth

**親 repo の `AGENTS.md` が正本** です。子 repo（api / blog / web / infra）の同名ファイルは GitHub Actions で自動同期されるため、子 repo で直接編集してはいけません。子 repo 固有のルールを足したい場合は親 repo に PR を出してください。

### sync の仕組み

親の `AGENTS.md` 等が main ブランチに push されると、`.github/workflows/sync-agent-rules.yml` が走り、4 つの子 repo に同じ内容を反映します。

### sync 用 PAT のセットアップ（初回のみ）

GitHub Actions が子 repo に push するため、PAT を Secrets に登録する必要があります。

1. https://github.com/settings/personal-access-tokens/new でファイングレインド PAT を作成
   - Resource owner: `katatsumuri-work`
   - Repository access: `api`, `blog`, `web`, `infra` の 4 つを選択
   - Repository permissions: **Contents: Read and write**, **Metadata: Read-only**（自動付与）
2. 生成されたトークンをコピー
3. 親 repo の Settings → Secrets and variables → Actions → **New repository secret**
   - Name: `SYNC_PAT`
   - Value: コピーしたトークン

設定後、親 repo の Actions タブから `Sync agent rules to children` workflow を **Run workflow**（workflow_dispatch）で手動実行すると動作確認できます。

### 手動 sync（ローカル）

GHA が止まっている場合や緊急時は、ローカルで以下を実行できます。

```sh
./scripts/sync-agent-rules.sh           # ファイルコピーのみ
./scripts/sync-agent-rules.sh --commit  # 各子 repo で commit + push まで
```
