#!/bin/bash
# Quick test script for Phase 0 (Auth API)

set -e

echo "🧪 Running Phase 0 Auth Tests..."
echo ""

# Run Django tests
echo "📝 Running auth tests with pytest..."
python manage.py test accounts.tests --verbosity=2

echo ""
echo "✅ Phase 0 Auth Tests Complete!"
echo ""
echo "📊 Test Summary:"
echo "  ✓ RegisterTests: register_success, duplicate_username, duplicate_email, password_mismatch, weak_password, missing_fields"
echo "  ✓ LoginTests: login_success, invalid_email, invalid_password, missing_fields"
echo "  ✓ MeTests: me_authenticated, me_unauthenticated, me_invalid_token"
echo "  ✓ TokenTests: token_refresh"
echo ""
echo "🚀 To test manually with cURL:"
echo ""
echo "  1. Register:"
echo "     curl -X POST http://127.0.0.1:8000/api/auth/register/ \\"
echo "       -H 'Content-Type: application/json' \\"
echo "       -d '{\"username\": \"alice\", \"email\": \"alice@example.com\", \"password\": \"SecurePass123!\", \"password_confirm\": \"SecurePass123!\"}'"
echo ""
echo "  2. Login:"
echo "     curl -X POST http://127.0.0.1:8000/api/auth/login/ \\"
echo "       -H 'Content-Type: application/json' \\"
echo "       -d '{\"email\": \"alice@example.com\", \"password\": \"SecurePass123!\"}'"
echo ""
echo "  3. Get current user (replace TOKEN with access token from login):"
echo "     curl -X GET http://127.0.0.1:8000/api/auth/me/ \\"
echo "       -H 'Authorization: Bearer TOKEN'"
echo ""
