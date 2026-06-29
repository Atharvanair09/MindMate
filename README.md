# MindMate

![MindMate Logo - Insert Image Here](path/to/your/logo_image.png)

> **MINDMATE // NO PRETENDING, NO DATA MINING.**  
> A privacy-first, secure, and resilient mental wellness companion. MindMate empowers users to track their thoughts, engage in safe community chats, and interact with AI-driven insights, all while ensuring complete data privacy and security.

![Hero Banner / App Mockup - Insert Image Here](path/to/your/hero_banner_image.png)

## 🌟 Key Features

*   **Absolute Privacy & Security**: No personal data mining. Authentication relies on UUIDs, recovery phrases, and short-lived OTPs.
*   **AI-Powered Companion**: Integrated with the Anthropic AI SDK to provide contextual and empathetic mental wellness insights.
*   **Voice & Text Journaling**: Seamlessly log your thoughts using robust speech-to-text and text-to-speech capabilities.
*   **Local & Secure Storage**: Journals and sensitive data are kept locally encrypted via Isar Database and Flutter Secure Storage.
*   **Community Chat**: Safe, real-time community engagement powered by Socket.io.
*   **Crisis Help Integration**: Immediate, 24/7 assistance protocols built directly into the core app experience.
*   **On-Device Machine Learning**: Utilizes Google ML Kit for Face Detection and ONNX Runtime for local AI inferences.

---

## 📸 Screenshots

| Home Dashboard | Journaling Experience | Community Chat |
| :---: | :---: | :---: |
| ![Home Screenshot - Insert Image Here](path/to/home_screenshot.png) | ![Journal Screenshot - Insert Image Here](path/to/journal_screenshot.png) | ![Chat Screenshot - Insert Image Here](path/to/chat_screenshot.png) |

---

## 🛠 Tech Stack

### Frontend (Mobile)
*   **Framework**: Flutter (Dart)
*   **Local Database**: Isar DB
*   **State Management**: Provider
*   **ML/AI**: Google ML Kit (Face Detection), ONNX Runtime
*   **Media**: Speech to Text, Flutter TTS, Image Picker
*   **Security**: Flutter Secure Storage, Encrypt

### Backend (Server)
*   **Runtime**: Node.js
*   **Framework**: Express.js
*   **Database**: MongoDB Atlas (Mongoose)
*   **Real-time Communication**: Socket.io
*   **AI Integration**: Anthropic AI SDK
*   **Email Services**: Brevo API (for Secure OTPs)
*   **Security**: JWT, bcryptjs, express-rate-limit

---

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or higher)
*   [Node.js](https://nodejs.org/) (v16.x or higher)
*   MongoDB Instance (Local or Atlas)
*   API Keys for Brevo and Anthropic AI

### Backend Setup
1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file in the `backend` root and configure the following:
   ```env
   PORT=3000
   MONGODB_URI=your_mongodb_connection_string
   JWT_SECRET=your_super_secret_jwt_key
   BREVO_API_KEY=your_brevo_api_key
   ```
4. Start the development server:
   ```bash
   npm start
   ```

### Frontend Setup
1. Navigate to the frontend directory:
   ```bash
   cd frontend/mindmate
   ```
2. Install Flutter packages:
   ```bash
   flutter pub get
   ```
3. Run the application (ensure you have an emulator running or a physical device connected):
   ```bash
   flutter run
   ```

---

## 🔒 Privacy Protocol

MindMate architecture is built for resilience. This is the first and last time we see your data. We adhere to a strict **Zero Data Mining** policy. Your identity verification and journal data are secured with end-to-end encryption methodologies.

---

## 📜 License
*MindMate Architecture. Built for Resilience. All Rights Reserved.*