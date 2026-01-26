#!/usr/bin/env bash
# Example: register a user using the web UI via HTTP POST (works if application uses form fields)
curl -v -X POST http://localhost:5000/register -F "username=test" -F "email=test@example.com" -F "password=secret123" -F "submit=Register"
