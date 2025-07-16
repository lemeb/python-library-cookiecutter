#!/bin/bash
echo "Setting git up..."
git init

cp .env.example .env

echo "✅ Template generated successfully!"
echo '🛞 To install dependencies, run: "make install-all"'
