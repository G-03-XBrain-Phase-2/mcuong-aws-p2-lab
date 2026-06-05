#!/bin/bash
# Tự động dừng script nếu có lệnh gặp lỗi
set -e

# Lấy đường dẫn thư mục hiện tại của script để định vị thư mục practice
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/practice"

echo "=================================================="
echo "=== 1. HỦY TOÀN BỘ TÀI NGUYÊN (AUTO-APPROVE)  ==="
echo "=================================================="
terraform destroy -auto-approve

echo ""
echo "=================================================="
echo "=== DỌN DẸP HẠ TẦNG THÀNH CÔNG!                ==="
echo "=================================================="
