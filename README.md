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
