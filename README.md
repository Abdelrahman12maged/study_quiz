# AI Study Buddy (Study Quiz)

An AI-powered Flutter application that allows users to photograph their study notes and instantly generates interactive quizzes using Artificial Intelligence. The app uses **Supabase** for backend services (Database, Storage, Auth) and an **n8n webhook** to orchestrate the AI processing (e.g., using Gemini/Tavily).

---

## 🌟 Key Features

* **Authentication**: Secure sign-up, login, and user session management via Supabase Auth.
* **Image Capture**: Pick images from the gallery or use the camera to capture study notes.
* **AI Processing Pipeline**: Asynchronously processes uploaded images via a dedicated n8n webhook to extract text and generate meaningful multiple-choice and true/false questions.
* **Interactive Quizzes**: Take the generated quizzes with immediate feedback, detailed explanations, and source citations.
* **Dashboard & Analytics**: Track your progress with daily streaks, weekly accuracy, and the total number of questions answered.
* **Session History**: View, filter, and review all previous study sessions.
* **Localization**: Full support for both English (en) and Arabic (ar).
* **Theming**: Dynamic Light and Dark modes with preferences saved locally.

---

## 🛠️ Tech Stack & Architecture

This project follows a clean **Feature-First Architecture** combined with Domain-Driven Design principles.

### Core Technologies
* **Framework**: Flutter (`sdk: ^3.5.0`)
* **State Management**: BLoC / Cubit (`flutter_bloc`, `equatable`)
* **Routing**: GoRouter (`go_router`)
* **Dependency Injection**: GetIt (`get_it`)
* **Backend as a Service (BaaS)**: Supabase (`supabase_flutter`)
* **Networking**: Dio (`dio`)
* **Local Storage**: Shared Preferences (`shared_preferences`)

---

## 📂 Project Structure

The project is structured inside the `lib/` directory as follows:

```text
lib/
├── core/
│   ├── constants/       # App-wide constants (colors, strings, keys)
│   ├── di/              # Dependency Injection setup (service_locator.dart)
│   ├── responsive/      # Responsive layout builders (Mobile/Tablet)
│   ├── routing/         # GoRouter configuration and App Shell
│   ├── supabase/        # Supabase client configuration
│   ├── theme/           # App themes and spacing tokens
│   └── widgets/         # Shared UI components (AppCard, Buttons, Loading, etc.)
│
├── features/            # Feature modules
│   ├── auth/            # Sign In, Sign Up, Auth State
│   ├── capture/         # Camera/Gallery image picker and upload
│   ├── history/         # Previous sessions list and grid
│   ├── home/            # Dashboard stats and recent sessions
│   ├── onboarding/      # Welcome screens for new users
│   ├── processing/      # Realtime pipeline animation while waiting for AI
│   ├── quiz/            # Quiz taking, validation, and results screen
│   └── settings/        # Theme toggling, localization, and logout
│
└── main.dart            # Application entry point
```

### Feature Module Structure
Each feature under `lib/features/` generally follows this pattern:
* `data/`: Models and Datasources (e.g., API calls, Supabase queries).
* `domain/`: Entities and Repositories (abstract contracts).
* `presentation/`:
  * `cubit/`: Cubits and States for managing the feature's UI state.
  * `screens/`: Flutter UI pages.
  * `widgets/`: Feature-specific UI components.

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (v3.5.0 or higher)
* A Supabase project (with Auth, Storage bucket named `captures`, and required database tables: `quiz_sessions` and `user_answers`).
* An n8n workflow configured to receive the webhook, process the image via AI, and update the Supabase database.

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository_url>
   cd study_quiz
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase & Webhook**
   Open `lib/core/supabase/supabase_config.dart` and update the constants with your Supabase credentials and your n8n webhook URL:
   ```dart
   class SupabaseConfig {
     static const String url = 'YOUR_SUPABASE_URL';
     static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
     static const String n8nWebhookUrl = 'YOUR_N8N_WEBHOOK_URL';
   }
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

---

## 🔌 Webhook & Backend Flow

1. The user captures an image and it is uploaded to Supabase Storage (`captures` bucket).
2. A new row is inserted into the `quiz_sessions` table with `status = 'processing'`.
3. The app fires a POST request to the `n8nWebhookUrl` with the `uid`, `sessionId`, and `imageUrl`.
4. The user is navigated to the Processing screen, which uses **Supabase Realtime** to listen for status changes on the session row.
5. Once n8n finishes generating questions and inserting them into the database, it returns a `200 OK` response.
6. The app updates the session status to `ready` (or `failed` in case of a timeout/error), and the Realtime listener instantly transitions the user to the Quiz or Error screen.

---

## 📝 License
This project is proprietary and confidential.
