#!/bin/bash
# Tự động dừng script nếu có lệnh gặp lỗi
set -e

# Lấy đường dẫn thư mục hiện tại của script để định vị thư mục practice
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/practice"

echo "=================================================="
echo "=== 1. KHỞI TẠO HẠ TẦNG (TERRAFORM INIT)       ==="
echo "=================================================="
terraform init

echo ""
echo "=================================================="
echo "=== 2. TRIỂN KHAI HẠ TẦNG & APP (AUTO-APPROVE) ==="
echo "=================================================="
terraform apply -auto-approve

echo ""
echo "=================================================="
echo "=== TRIỂN KHAI THÀNH CÔNG!                     ==="
echo "=================================================="
