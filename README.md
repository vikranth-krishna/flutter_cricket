# Flutter Cricket App

A Flutter-based Cricket Application that provides:
- User authentication (Sign Up, Login).
- Player management (Admin can add, edit, delete players).
- Live cricket score carousel with match data (Admin can add, edit, delete live scores).

---

## Features

- **User Management**: 
  - Login and Sign Up functionality.
  - Persistent user authentication using `SharedPreferences`.

- **Admin Access**:
  - Admin user (`operator@op.com` with password `123`) has access to:
    - Add, edit, and delete players.
    - Add, edit, and delete live cricket matches.

- **Live Matches Carousel**:
  - Displays live cricket matches in a carousel viewer.
  - Line charts from `syncfusion_flutter_charts` library to show score trends.

---

## Installation and Setup

### Prerequisites

- Flutter SDK installed (version `>=2.0`).
- Android Studio or Visual Studio Code.

### Steps

Clone the repository:
   ```bash
   git clone https://github.com/your-username/flutter_cricket_app.git

### Admin Credentials
Email: operator@op.com
Password: 123
   
