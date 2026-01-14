#!/bin/bash

SLUG="{{cookiecutter.project_slug}}"

setup_monorepo_workflows() {
    local git_root="$1"
    local rel_path="$2"

    mkdir -p "$git_root/.github/workflows"

    # Process ci.yml for monorepo
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

    # Process cruft-update.yml for monorepo
    python3 -c "
import sys
rel_path = sys.argv[1]

with open('.github/workflows/cruft-update.yml', 'r') as f:
    content = f.read()

# Replace project dir markers
content = content.replace('__CRUFT_PROJECT_DIR__', rel_path)

# Remove workflow exclusion (not needed in monorepo - workflows are at root)
content = content.replace('__CRUFT_MAYBE_EXCLUDE_WORKFLOWS__', '')

# Add cd command for monorepo
content = content.replace('__CRUFT_CD__', f'cd {rel_path}')

print(content, end='')
" "$rel_path" > "$git_root/.github/workflows/${SLUG}-cruft-update.yml"

    echo "   Created: $git_root/.github/workflows/${SLUG}-ci.yml"
    echo "   Created: $git_root/.github/workflows/${SLUG}-cruft-update.yml"

    rm -rf .github
}

setup_standalone_workflows() {
    # Process ci.yml - just remove markers
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' '/# __MONOREPO_/d' .github/workflows/ci.yml
    else
        sed -i '/# __MONOREPO_/d' .github/workflows/ci.yml
    fi

    # Process cruft-update.yml - replace markers with standalone values
    python3 -c "
with open('.github/workflows/cruft-update.yml', 'r') as f:
    content = f.read()

content = content.replace('__CRUFT_PROJECT_DIR__', '.')
content = content.replace('__CRUFT_MAYBE_EXCLUDE_WORKFLOWS__', '!.github/workflows/')
content = content.replace('__CRUFT_CD__\\n', '')  # Remove the line entirely

with open('.github/workflows/cruft-update.yml', 'w') as f:
    f.write(content)
"
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
    read -p "Create workflows at \$GIT_ROOT/.github/workflows/${SLUG}-*.yml? [Y/n] " response

    if [[ ! "$response" =~ ^[Nn]$ ]]; then
        setup_monorepo_workflows "$GIT_ROOT" "$REL_PATH"
    else
        echo "   Skipping workflow creation."
        rm -rf .github
    fi
else
    echo "Setting git up..."
    git init
    setup_standalone_workflows
fi

cp .env.example .env

echo "Setting up symlinks..."
ln -s AGENTS.md CLAUDE.md
ln -s AGENTS.md GEMINI.md

echo ""
echo "Template generated successfully!"
echo "To install dependencies, run: cd $SLUG && make install-all"
