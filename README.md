# AUDIOFY

A full-featured music streaming application built with Flutter that allows users to register, login, upload songs, manage favorites, and play music with background playback support with Python.

## Features

- User authentication (Registration & Login)
- Music playback with background support
- Favorite songs management
- Song upload functionality
- File management
- Cloud storage integration
- Cache management
- Offline data persistence
- Background playback controls
- Notification support for music controls

## Tech Stack

### Mobile Application (Flutter)
- **State Management**: flutter_riverpod with code generation (annotations)
- **Music Player**: just_audio, just_audio_background
- **Error Handling**: fp_dart
- **Local Storage**: 
  - Hive
  - Isar (caching)
  - SharedPreferences (user data persistence)
- **File Management**: 
  - file_picker
  - permission_handler

### Backend (Python)
- **Framework**: FastAPI (with dependency injection using yield)
- **Database**: 
  - PostgreSQL
  - SQLAlchemy ORM
- **API Validation**: Pydantic schemas
- **Authentication**: JWT (JSON Web Tokens)
- **Cloud Storage**: Cloudinary (for music file storage)

## Getting Started

### Prerequisites
- Flutter SDK
- Python 3.8+
- PostgreSQL
- Cloudinary Account

### Installation

1. Clone the repository
```bash
git clone [repository-url]
```

2. Install Flutter dependencies
```bash
cd [project-directory]
flutter pub get
```

3. Install Python dependencies
```bash
cd backend
pip install -r requirements.txt
```

4. Setup environment variables
```bash
# Backend .env
DATABASE_URL=postgresql://[user]:[password]@localhost:5432/[db_name]
JWT_SECRET_KEY=[your-secret-key]
CLOUDINARY_CLOUD_NAME=[your-cloud-name]
CLOUDINARY_API_KEY=[your-api-key]
CLOUDINARY_API_SECRET=[your-api-secret]

# Flutter .env
API_BASE_URL=[backend-url]
```

### Running the Application

1. Start the backend server
```bash
cd backend
uvicorn main:app --reload
```

2. Run the Flutter application
```bash
flutter run
```

## Architecture

### Mobile Architecture
- The application follows a MVVM architecture pattern
- Uses Riverpod for state management with code generation
- Implements repository pattern for data management
- Uses service classes for external interactions
- Implements caching strategy using Hive and Isar
- Handles errors using functional programming approaches with fp_dart

### Backend Architecture
- FastAPI application with dependency injection
- SQLAlchemy models for database interactions
- Pydantic schemas for request/response validation
- JWT authentication middleware
- Cloudinary integration for file storage
- RESTful API endpoints




## Features in Detail

### Authentication
- JWT-based authentication
- Secure password hashing
- Token persistence using SharedPreferences

### Music Player
- Background playback support
- Notification controls
- Playlist management
- Favorite songs functionality

### File Management
- Music file upload to Cloudinary
- File type validation
- Permission handling
- Progress tracking

### Caching
- Offline song availability
- User data caching
- Optimized storage management

## Contributing
Feel free to submit issues and enhancement requests.

## Acknowledgments
- just_audio for the excellent audio player implementation
- Cloudinary for file storage solutions
- FastAPI for the efficient backend framework
  
## Screenshots
![Screenshot_1735037903](https://github.com/user-attachments/assets/9b5e6c51-38ca-4c13-99c1-a174625f0fdf)
![Screenshot_1735037905](https://github.com/user-attachments/assets/f1311937-65bb-4277-a2c6-100c3a41cbd4)
![Screenshot_1735040692](https://github.com/user-attachments/assets/63199a04-cfc1-40f7-b0e8-d987d21d0099)
![Screenshot_1735040700](https://github.com/user-attachments/assets/c2a50164-2937-4abd-9319-ca8b13d661e0)
![Screenshot_1735040706](https://github.com/user-attachments/assets/7e76fb43-dcd3-4a43-a2c1-a08a350ea996)
![Screenshot_1735040717](https://github.com/user-attachments/assets/d4e69501-cfeb-4835-bfa5-9b418489a90b)

