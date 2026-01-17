#!/bin/bash
# Démarrer un serveur web simple pour tester la version web
cd "$(dirname "$0")/web" || exit 1

echo "🚀 Couple App Web — Serveur démarré!"
echo ""
echo "📝 URLs disponibles:"
echo "   http://127.0.0.1:8000 (API Backend)"
echo "   http://127.0.0.1:8080 (Web App)"
echo ""
echo "Assurez-vous que le backend Django tourne sur http://127.0.0.1:8000"
echo ""
echo "Appuyez sur Ctrl+C pour arrêter"
echo ""

# Déterminer le port disponible
PORT=8080
while lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; do
    PORT=$((PORT+1))
done

echo "Démarrage sur http://127.0.0.1:$PORT"

# Démarrer le serveur (Python 3)
if command -v python3 &> /dev/null; then
    python3 -m http.server $PORT
elif command -v python &> /dev/null; then
    python -m http.server $PORT
else
    echo "❌ Python n'est pas trouvé!"
    echo "Veuillez installer Python 3 ou ouvrir web/index.html directement dans le navigateur"
    exit 1
fi
