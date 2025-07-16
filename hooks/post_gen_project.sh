#!/bin/bash
echo "Setting git up..."
git init

cp .env.example .env

echo "✅ Template generated successfully!"
echo '🛞 To install dependencies, run: "cd {{cookiecutter.project_slug}} && make install-all"'
