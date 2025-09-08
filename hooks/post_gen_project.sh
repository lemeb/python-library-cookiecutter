#!/bin/bash
echo "Setting git up..."
git init

cp .env.example .env

echo "Setting up symlinks..."
ln -s AGENTS.md CLAUDE.md
ln -s AGENTS.md GEMINI.md

echo "✅ Template generated successfully!"
echo '🛞 To install dependencies, run: "cd {{cookiecutter.project_slug}} && make install-all"'
