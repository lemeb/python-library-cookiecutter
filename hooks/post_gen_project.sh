#!/bin/bash

SLUG="{{cookiecutter.project_slug}}"

setup_monorepo_workflows() {
    local git_root="$1"
    local rel_path="$2"

    mkdir -p "$git_root/.github/workflows"

    # Use Python for reliable cross-platform string replacement
    python3 -c "
import sys
rel_path = sys.argv[1]

with open('.github/workflows/ci.yml', 'r') as f:
    content = f.read()

# Add paths filter for monorepo
paths_block = f\"paths:\\n      - '{rel_path}/**'\"
content = content.replace('# __MONOREPO_PATHS__', paths_block)

# Add defaults block for working-directory
defaults_block = f'''defaults:
  run:
    working-directory: {rel_path}

'''
content = content.replace('# __MONOREPO_DEFAULTS__\\n', defaults_block)

print(content, end='')
" "$rel_path" > "$git_root/.github/workflows/${SLUG}-ci.yml"

    echo "   Created: $git_root/.github/workflows/${SLUG}-ci.yml"
    echo "   Note: cruft-update.yml not created for monorepo - configure manually if needed."

    rm -rf .github
}

cleanup_standalone_markers() {
    # Remove marker comments from standalone workflows (they're harmless but cleaner without)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' '/# __MONOREPO_/d' .github/workflows/ci.yml
    else
        sed -i '/# __MONOREPO_/d' .github/workflows/ci.yml
    fi
}

# Check if we're inside a git repository
if git rev-parse --show-toplevel >/dev/null 2>&1; then
    GIT_ROOT=$(git rev-parse --show-toplevel)
    PROJECT_DIR=$(pwd)
    REL_PATH=$(python3 -c "import os; print(os.path.relpath('$PROJECT_DIR', '$GIT_ROOT'))")

    echo ""
    echo "Detected existing git repository at: $GIT_ROOT"
    echo "Project will be at: $REL_PATH/"
    echo ""
    read -p "Create CI workflow at \$GIT_ROOT/.github/workflows/${SLUG}-ci.yml? [Y/n] " response

    if [[ ! "$response" =~ ^[Nn]$ ]]; then
        setup_monorepo_workflows "$GIT_ROOT" "$REL_PATH"
    else
        echo "   Skipping workflow creation."
        rm -rf .github
    fi
else
    echo "Setting git up..."
    git init
    cleanup_standalone_markers
fi

cp .env.example .env

echo "Setting up symlinks..."
ln -s AGENTS.md CLAUDE.md
ln -s AGENTS.md GEMINI.md

echo ""
echo "Template generated successfully!"
echo "To install dependencies, run: cd $SLUG && make install-all"
