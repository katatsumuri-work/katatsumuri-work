#!/usr/bin/env bash
# AGENTS.md とポインタファイルを各 submodule に同期する（手動・ローカル実行用）
#
# 通常運用は GitHub Actions（.github/workflows/sync-agent-rules.yml）で
# 自動実行されるが、ローカルで動作確認したいときや GHA が止まっている時の
# 緊急用として残してある。
#
# 使い方:
#   ./scripts/sync-agent-rules.sh           # ファイルコピーのみ
#   ./scripts/sync-agent-rules.sh --commit  # 各 submodule で commit + push まで
#
# 親 repo の AGENTS.md / CLAUDE.md / GEMINI.md / .github/copilot-instructions.md
# を正本として、すべての子 repo に同じ内容を配置する。

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SUBMODULES=(api blog web infra)

SRC_AGENTS="$REPO_ROOT/AGENTS.md"
SRC_CLAUDE="$REPO_ROOT/CLAUDE.md"
SRC_GEMINI="$REPO_ROOT/GEMINI.md"
SRC_COPILOT="$REPO_ROOT/.github/copilot-instructions.md"

for f in "$SRC_AGENTS" "$SRC_CLAUDE" "$SRC_GEMINI" "$SRC_COPILOT"; do
    if [[ ! -f "$f" ]]; then
        echo "ERROR: 正本ファイルが見つかりません: $f" >&2
        exit 1
    fi
done

DO_COMMIT=false
if [[ "${1:-}" == "--commit" ]]; then
    DO_COMMIT=true
fi

for sub in "${SUBMODULES[@]}"; do
    echo "==> $sub"
    DST="$REPO_ROOT/$sub"
    if [[ ! -d "$DST/.git" && ! -f "$DST/.git" ]]; then
        echo "  SKIP: $DST は git repo として init されていません"
        continue
    fi
    cp "$SRC_AGENTS" "$DST/AGENTS.md"
    cp "$SRC_CLAUDE" "$DST/CLAUDE.md"
    cp "$SRC_GEMINI" "$DST/GEMINI.md"
    mkdir -p "$DST/.github"
    cp "$SRC_COPILOT" "$DST/.github/copilot-instructions.md"

    if [[ "$DO_COMMIT" == "true" ]]; then
        (
            cd "$DST"
            git add AGENTS.md CLAUDE.md GEMINI.md .github/copilot-instructions.md
            if git diff --cached --quiet; then
                echo "  変更なし、commit スキップ"
            else
                git commit -m "Sync agent rules from parent repo"
                git push
                echo "  commit + push 完了"
            fi
        )
    else
        echo "  ファイル配置完了（commit は --commit オプションで）"
    fi
done

echo ""
echo "Done."
if [[ "$DO_COMMIT" == "true" ]]; then
    echo "次は親 repo で submodule pointer を更新してコミットしてください："
    echo "  git add ${SUBMODULES[*]}"
    echo "  git commit -m 'Update submodule pointers (sync agent rules)'"
    echo "  git push"
fi
