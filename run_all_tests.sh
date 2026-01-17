#!/bin/bash
# Test Suite Complet — MVP Backend (79 tests)
# Usage: bash run_all_tests.sh

set -e

cd "$(dirname "$0")"/backend || exit 1

echo "🧪 Couple App MVP — Test Suite Complet"
echo "========================================"
echo ""
echo "⏱️  Temps estimé: ~30-40 secondes"
echo ""

# Phase 0 — Auth
echo "📝 Phase 0 — Auth API (14 tests)..."
python manage.py test accounts.tests --verbosity=1
echo "✅ Phase 0 complete"
echo ""

# Phase 1 — Pairing
echo "👥 Phase 1 — Pairing API (23 tests)..."
python manage.py test couples.tests --verbosity=1
echo "✅ Phase 1 complete"
echo ""

# Phase 2 — Sync
echo "📡 Phase 2 — Smart Polling (15 tests)..."
python manage.py test sync.tests --verbosity=1
echo "✅ Phase 2 complete"
echo ""

# Phase 3 — Features
echo "🎯 Phase 3 — Feature APIs (27 tests)..."
python manage.py test qna.tests goals.tests checkins.tests letters.tests --verbosity=1
echo "✅ Phase 3 complete"
echo ""

echo "========================================"
echo "🎉 ALL TESTS COMPLETE!"
echo "📊 Total: 79/79 tests passing (100%)"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Run individual test: python manage.py test <app>.tests.<TestClass>"
echo "  2. Start server: python manage.py runserver"
echo "  3. Test endpoints: curl -X POST http://127.0.0.1:8000/api/auth/register/ ..."
echo ""
