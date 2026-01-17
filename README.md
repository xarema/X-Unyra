# 💑 Unyra

> A modern mobile and web application designed for couples to strengthen their connection through daily check-ins, shared goals, meaningful conversations, and personal messages.

[![Status](https://img.shields.io/badge/status-MVP%20Complete-brightgreen)](./docs/00-INDEX.md)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Python](https://img.shields.io/badge/Python-3.9%2B-blue)](https://www.python.org/)
[![Django](https://img.shields.io/badge/Django-5.2-green)](https://www.djangoproject.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.38-blue)](https://flutter.dev)

---

## 📖 Table of Contents

- [Overview](#overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Quick Start](#-quick-start)
- [Installation](#-installation)
- [Usage](#-usage)
- [API Documentation](#-api-documentation)
- [Development](#-development)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Contributing](#-contributing)
- [License](#-license)

---

## Overview

Unyra is a comprehensive platform built to help couples strengthen their relationships through:

- **Daily Connection**: Morning mood check-ins and real-time synchronization
- **Shared Growth**: Collaborative goal-setting and tracking with micro-actions
- **Better Communication**: Daily Q&A prompts that spark meaningful conversations
- **Personal Touch**: Private letters for intimate messages and reflections
- **Multi-Platform**: Native Android, iOS (coming soon), and web support via Flutter

**Current Status**: Backend MVP complete with 79/79 tests passing ✅ | Frontend in progress

---

## 🎯 Features

### Core Features (MVP)

| Feature | Description | Status |
|---------|-------------|--------|
| **Authentication** | Secure JWT-based registration and login | ✅ Complete |
| **Couple Pairing** | Create or join a couple using invitation codes | ✅ Complete |
| **Daily Check-ins** | Track mood, stress, and energy levels (0-10) | ✅ Complete |
| **Smart Q&A** | 3-status questions (Answered, Needs Time, Clarify) | ✅ Complete |
| **Shared Goals** | Create and track relationship goals with actions | ✅ Complete |
| **Love Letters** | Draft and send personal messages to your partner | ✅ Complete |
| **Real-time Sync** | Smart polling for near-instant updates | ✅ Complete |
| **Multi-Platform** | iOS, Android, and Web support | ✅ In Progress |

### Upcoming Features (v1.1+)

- Push notifications
- PDF export functionality
- Guided conflict resolution flow
- Advanced analytics dashboard
- Internationalization (EN/FR/KO)

---

## 🏗️ Tech Stack

### Backend

| Component | Technology | Version |
|-----------|------------|---------|
| **Framework** | Django REST Framework | 5.2 |
| **Language** | Python | 3.9+ |
| **Authentication** | SimpleJWT | 5.3+ |
| **Database** | SQLite (dev) / PostgreSQL (prod) | Latest |
| **CORS** | django-cors-headers | 4.3+ |
| **Server** | Gunicorn | 21.2+ |

### Frontend

| Component | Technology | Version |
|-----------|------------|---------|
| **Framework** | Flutter | 3.38+ |
| **Language** | Dart | 3.1+ |
| **State Management** | Riverpod | Latest |
| **HTTP Client** | Dio | Latest |
| **Routing** | GoRouter | Latest |
| **Platforms** | Android, iOS, Web | All |

### DevOps

- **Hosting**: cPanel with traditional hosting
- **API Server**: Gunicorn + Nginx
- **Static Files**: WhiteNoise
- **Database**: PostgreSQL (production)
- **Monitoring**: Basic health checks

---

## 📁 Project Structure

```
unyra/
├── backend/                          # Django REST API
│   ├── accounts/                     # User authentication & profiles
│   ├── couples/                      # Couple management & pairing
│   ├── checkins/                     # Daily mood check-ins
│   ├── qna/                          # Q&A prompts & responses
│   ├── goals/                        # Shared goals & tracking
│   ├── letters/                      # Love letters system
│   ├── sync/                         # Synchronization engine
│   ├── couple_backend/               # Project settings
│   ├── manage.py                     # Django CLI
│   ├── requirements.txt              # Python dependencies
│   └── db.sqlite3                    # Development database
│
├── frontend/                         # Flutter application
│   ├── lib/
│   │   ├── features/                 # Feature modules (screens & logic)
│   │   ├── core/                     # Shared services & config
│   │   ├── main.dart                 # Entry point
│   │   └── ...
│   ├── pubspec.yaml                  # Flutter dependencies
│   ├── pubspec.lock                  # Dependency lock file
│   └── build/                        # Build output
│
├── docs/                             # Documentation
│   ├── 00-INDEX.md                   # Documentation index
│   ├── 05-Roadmap-MVP.md            # Complete roadmap
│   ├── 07-QuickStart-Phase0-1.md    # Quick start guide
│   ├── 08-Executive-Summary.md      # Project overview
│   └── ...
│
└── README.md                         # This file
```

---

## 🚀 Quick Start

### Prerequisites

- **Python** 3.9 or higher
- **Flutter** 3.38 or higher
- **Git** for version control
- **Node.js** (optional, for frontend tooling)

### One-Line Setup

```bash
# Backend only
git clone https://github.com/yourusername/unyra.git && cd unyra/backend && python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt && python manage.py migrate && python manage.py runserver

# Frontend only (requires backend running)
cd frontend && flutter pub get && flutter run -d chrome
```

---

## 📦 Installation

### Backend Installation

#### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/unyra.git
cd unyra/backend
```

#### 2. Create Virtual Environment

```bash
# macOS / Linux
python3 -m venv .venv
source .venv/bin/activate

# Windows
python -m venv .venv
.venv\Scripts\activate
```

#### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

#### 4. Run Migrations

```bash
python manage.py migrate
```

#### 5. Create Test Users (Optional)

```bash
python force_create_couple.py  # Creates test couple with code
```

#### 6. Start Development Server

```bash
python manage.py runserver 0.0.0.0:8000
```

**Backend API**: http://localhost:8000
**API Documentation**: http://localhost:8000/api/

### Frontend Installation

#### 1. Navigate to Frontend

```bash
cd frontend
```

#### 2. Install Dependencies

```bash
flutter pub get
```

#### 3. Configure Backend URL

Update `lib/core/config/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8000/api';
}
```

#### 4. Run on Your Device/Emulator

```bash
# Chrome Web
flutter run -d chrome

# Android Emulator
flutter run -d emulator-5554

# iOS Simulator
flutter run -d ios
```

---

## 💻 Usage

### Backend API Examples

#### Register a New User

```bash
POST /api/auth/register/
Content-Type: application/json

{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "SecurePassword123!",
  "first_name": "John",
  "last_name": "Doe"
}
```

#### Create a Couple

```bash
POST /api/couples/create/
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "partner_name": "Jane Doe"
}
```

#### Submit Daily Check-in

```bash
POST /api/checkins/create/
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "mood": 8,
  "stress": 3,
  "energy": 7,
  "notes": "Great day!"
}
```

#### Get Q&A Prompts

```bash
GET /api/qna/questions/today/
Authorization: Bearer {access_token}
```

---

## 📚 API Documentation

Complete API documentation is available at:

- **OpenAPI/Swagger**: http://localhost:8000/swagger/ (when running locally)
- **API Endpoints**: [API.md](./API.md)
- **Backend README**: [backend/README.md](./backend/README.md)

### Authentication

All protected endpoints require JWT authentication:

```bash
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## 🔧 Development

### Running Tests

#### Backend Tests

```bash
cd backend

# Run all tests with coverage
python manage.py test --verbosity=2

# Run specific app tests
python manage.py test accounts
python manage.py test couples
python manage.py test checkins
python manage.py test qna
python manage.py test goals
python manage.py test letters

# Run with coverage report
coverage run --source='.' manage.py test
coverage report
coverage html
```

#### Frontend Tests

```bash
cd frontend

# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Generate coverage report
flutter test --coverage
```

### Code Quality

#### Backend

```bash
# Format code
black .
isort .

# Lint
flake8 .
pylint **/*.py

# Type checking
mypy .
```

#### Frontend

```bash
# Analyze
flutter analyze

# Format
dart format lib/

# Lint
dartanalyzer lib/
```

### Environment Variables

Create `.env` file in backend root:

```env
DEBUG=False
SECRET_KEY=your-secret-key-here
ALLOWED_HOSTS=localhost,127.0.0.1,yourdomain.com
DATABASE_URL=sqlite:///db.sqlite3
JWT_SECRET=your-jwt-secret
CORS_ORIGINS=http://localhost:3000,http://localhost:8081
```

---

## ✅ Testing

### Test Coverage

**Backend**: 79/79 tests passing (100% coverage) ✅

| Phase | Tests | Status | Coverage |
|-------|-------|--------|----------|
| Phase 0 (Auth) | 14/14 | ✅ Pass | 100% |
| Phase 1 (Pairing) | 23/23 | ✅ Pass | 100% |
| Phase 2 (Sync) | 15/15 | ✅ Pass | 100% |
| Phase 3 (Features) | 27/27 | ✅ Pass | 100% |

### Running Test Suite

```bash
# Run all tests
./run_tests.sh

# Run with coverage
./run_tests.sh --coverage

# Run specific test
python manage.py test accounts.tests.AuthenticationTests
```

---

## 🚢 Deployment

### Prerequisites

- cPanel account with SSH access
- Python 3.9+ installed on server
- PostgreSQL database
- SSL certificate (provided by cPanel)

### Deployment Steps

1. **Connect to Server**
   ```bash
   ssh user@yourdomain.com
   ```

2. **Clone Repository**
   ```bash
   cd ~/public_html
   git clone https://github.com/yourusername/unyra.git
   ```

3. **Setup Backend**
   ```bash
   cd unyra/backend
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   python manage.py migrate --settings=couple_backend.settings.production
   python manage.py collectstatic --noinput
   ```

4. **Configure Gunicorn**
   ```bash
   gunicorn -b 127.0.0.1:8000 couple_backend.wsgi:application
   ```

5. **Setup Nginx Reverse Proxy**
   ```nginx
   server {
       server_name yourdomain.com;
       listen 443 ssl;
       
       location / {
           proxy_pass http://127.0.0.1:8000;
           proxy_set_header Host $host;
       }
   }
   ```

6. **Build & Deploy Frontend**
   ```bash
   cd frontend
   flutter build web
   # Upload build/web to public_html/frontend
   ```

For detailed deployment guide, see [Deployment Documentation](./docs/04-Deploy-cPanel.md)

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the Repository**
   ```bash
   git clone https://github.com/yourusername/unyra.git
   ```

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes & Test**
   ```bash
   # Backend
   cd backend && python manage.py test
   
   # Frontend
   cd frontend && flutter test
   ```

4. **Commit & Push**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   git push origin feature/your-feature-name
   ```

5. **Submit Pull Request**
   - Describe your changes clearly
   - Link any related issues
   - Include screenshots for UI changes

### Code Standards

- **Python**: PEP 8 (enforced with Black & isort)
- **Dart**: Dart style guide (enforced with dartanalyzer)
- **Commits**: Conventional Commits format
- **Tests**: Minimum 80% coverage required
- **Documentation**: Update docs with feature additions

See [CONTRIBUTING.md](./CONTRIBUTING.md) for detailed guidelines.

---

## 📄 Documentation

Complete documentation is available in the `docs/` folder:

- **[00-INDEX.md](./docs/00-INDEX.md)** - Documentation hub
- **[05-Roadmap-MVP.md](./docs/05-Roadmap-MVP.md)** - Complete roadmap & phases
- **[07-QuickStart-Phase0-1.md](./docs/07-QuickStart-Phase0-1.md)** - Quick start guide
- **[08-Executive-Summary.md](./docs/08-Executive-Summary.md)** - Project overview
- **[Backend README](./backend/README.md)** - Backend specifics
- **[Frontend README](./frontend/README.md)** - Frontend specifics

---

## 🐛 Troubleshooting

### Backend Issues

**Port 8000 already in use:**
```bash
lsof -i :8000  # Find process
kill -9 <PID>  # Kill process
```

**Database migration errors:**
```bash
python manage.py migrate --run-syncdb
python manage.py migrate --fake-initial
```

**CORS errors:**
Ensure `CORS_ORIGINS` in `.env` includes your frontend URL.

### Frontend Issues

**Flutter version mismatch:**
```bash
flutter upgrade
flutter pub get
flutter clean
flutter pub get
```

**Build cache issues:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📊 Project Status

**MVP Status**: Backend Complete ✅ | Frontend in Progress 🔄

- **Backend**: 79/79 tests passing (100%)
- **API Documentation**: Complete
- **Database Schema**: Finalized
- **Frontend UI**: 60% complete
- **Testing**: In progress
- **Deployment**: Documentation complete

Latest update: January 16, 2026

---

## 📞 Support

### Getting Help

- **Issues**: [GitHub Issues](https://github.com/yourusername/unyra/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/unyra/discussions)
- **Documentation**: [Full Documentation](./docs/)
- **Email**: support@unyra.dev

### Reporting Bugs

Please include:
1. Detailed description of the bug
2. Steps to reproduce
3. Expected vs actual behavior
4. Screenshots (if applicable)
5. Environment details (OS, versions, etc.)

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🎓 Authors & Contributors

### Core Team

- **Lead Developer**: Alexandre
- **Architecture**: Based on modern Flutter & Django best practices

### Contributors

We appreciate all contributions! See [CONTRIBUTING.md](./CONTRIBUTING.md) for how to get involved.

---

## 🙏 Acknowledgments

- Flutter community for excellent documentation
- Django & DRF community for robust frameworks
- All contributors and testers

---

## 📈 Roadmap

**Phase 4 (Current)**: Frontend mobile app completion
**Phase 5**: iOS app & advanced features
**Phase 6**: Analytics & insights
**Phase 7**: Production deployment
**Phase 8**: Post-launch optimization

See [Complete Roadmap](./docs/05-Roadmap-MVP.md) for detailed timeline.

---

<div align="center">

**Made with ❤️ for couples**

[GitHub](https://github.com/yourusername/unyra) • [Documentation](./docs/) • [Issues](https://github.com/yourusername/unyra/issues)

[![Code Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen)](./backend/)
[![Tests](https://img.shields.io/badge/tests-79%2F79-success)](./backend/)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

</div>
