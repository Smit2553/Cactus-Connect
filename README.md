# 🌵 Cactus Connect 🌵

[![Swift](https://img.shields.io/badge/Swift-5.x-orange.svg)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-blue)](https://developer.apple.com/xcode/swiftui/)
[![Python](https://img.shields.io/badge/Python-3.x-blue.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.x-green.svg)](https://fastapi.tiangolo.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-DATABASE-blue)](https://www.postgresql.org/)

**Discover and connect with local cactus and plant-related events!**

Cactus Connect is a full-stack application featuring an iOS frontend and a Python backend, designed to help users find interesting events happening in their city.

---

## ✨ Features

- **Browse Events:** View a list of upcoming events.
- **Event Details:** See detailed information about each event, including date, time, location, description, and category.
- **Search:** Quickly find events by searching keywords within the title, description, type, or location.
- **External Registration:** Link directly to event registration pages when available.
- **Backend API:** Provides RESTful endpoints for managing cities and events (CRUD operations).
- **Scalable Backend:** Built with FastAPI for high performance.
- **Relational Database:** Uses PostgreSQL for structured data storage.

---

## 🔧 Tech Stack

- **Frontend:**
  - Swift (iOS Native)
  - SwiftUI (Declarative UI Framework)
- **Backend:**
  - Python 3
  - FastAPI (Web Framework)
  - Uvicorn (ASGI Server)
  - Psycopg2 (PostgreSQL Adapter)
  - Python-dotenv (Environment Variable Management)
- **Database:**
  - PostgreSQL

---

## 🚀 Getting Started

### Prerequisites

- Git
- Xcode (for iOS Frontend)
- Python 3.x & Pip
- PostgreSQL Server running
- An IDE/Text Editor (like VS Code)

### Backend Setup (`Cactus Connect Backend`)

1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url>
    cd <your-repository-folder>/Cactus\ Connect\ Backend
    ```
2.  **Create and activate a virtual environment:**
    ```bash
    python -m venv venv
    # On macOS/Linux
    source venv/bin/activate
    # On Windows
    .\venv\Scripts\activate
    ```
3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
4.  **Set up PostgreSQL Database:**
    - Create a PostgreSQL database and user.
    - Grant necessary privileges to the user for the database.
5.  **Configure Environment Variables:**
    - Create a `.env` file in the `Cactus Connect Backend` directory.
    - Add the following variables, replacing the placeholders with your actual database credentials:
      ```env
      PGDATABASE=your_db_name
      PGUSERNAME=your_db_user
      PGPASSWORD=your_db_password
      PGIP=your_db_host_or_ip # e.g., localhost or 127.0.0.1
      PGPORT=your_db_port     # e.g., 5432
      ```
6.  **Create Database Tables:**

    - Connect to your PostgreSQL database using `psql` or a GUI tool.
    - Execute SQL commands to create the `city` and `event` tables based on the structure expected by `main.py`:

      ```sql
      -- Example table structures (Adjust types/constraints as needed)
      CREATE TABLE city (
          uuid UUID PRIMARY KEY,
          name VARCHAR(255) NOT NULL
      );

      CREATE TABLE event (
          uuid UUID PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          url VARCHAR(255),
          description TEXT,
          category VARCHAR(100),
          isVolunteerEvent BOOLEAN DEFAULT FALSE,
          city_uuid UUID REFERENCES city(uuid),
          location VARCHAR(255),
          date TIMESTAMP WITH TIME ZONE -- Or appropriate date/time type
      );
      ```

    - _(Note: Consider using a migration tool like Alembic for more robust schema management in the future)._

7.  **Run the Backend Server:**
    ```bash
    uvicorn main:app --reload --host 0.0.0.0 --port 8000
    ```
    The API should now be running at `http://localhost:8000`. You can access the auto-generated docs at `http://localhost:8000/docs`.

### Frontend Setup (`Cactus Connect`)

1.  **Navigate to the Frontend Directory:**
    ```bash
    cd ../Cactus\ Connect
    ```
2.  **Open the Project in Xcode:**
    - Find the `.xcodeproj` or `.xcworkspace` file and open it with Xcode.
3.  **Build and Run:**

    - Select a simulator or connect a physical iOS device.
    - Click the "Run" button (▶) in Xcode.

    _(**Note:** The current `ContentView.swift` uses hardcoded sample data. To connect to the live backend, you will need to implement network requests (e.g., using `URLSession` or Alamofire) to fetch data from the running backend API endpoints and update the views accordingly.)_

---

## ⚙️ API Endpoints

The backend provides the following RESTful API endpoints:

**Health Check**

- `GET /health`: Checks database connectivity.

**Cities**

- `POST /cities/`: Create a new city.
  - Request Body: `{"name": "City Name"}`
- `GET /cities/`: Retrieve a list of all cities.
- `GET /cities/{city_uuid}`: Retrieve details of a specific city by its UUID.
- `PUT /cities/{city_uuid}`: Update a specific city.
  - Request Body: `{"name": "Updated City Name"}`
- `DELETE /cities/{city_uuid}`: Delete a specific city.

**Events**

- `POST /events/`: Create a new event.
  - Request Body (Example):
    ```json
    {
      "name": "New Event Title",
      "url": "[http://example.com/event](http://example.com/event)",
      "description": "Event description.",
      "category": "Workshop",
      "isVolunteerEvent": false,
      "city_uuid": "valid-city-uuid",
      "location": "Event Location",
      "date": "2025-06-01T10:00:00Z" // ISO 8601 format
    }
    ```
- `GET /events/`: Retrieve a list of all events.
- `GET /events/{event_uuid}`: Retrieve details of a specific event by its UUID.
- `PUT /events/{event_uuid}`: Update a specific event.
  - Request Body: (Similar structure to POST)
- `DELETE /events/{event_uuid}`: Delete a specific event.

_(Refer to `http://localhost:8000/docs` while the backend is running for interactive API documentation)._

---

## 🔮 Future Enhancements

- **Frontend-Backend Integration:** Connect the SwiftUI frontend to fetch and display data from the FastAPI backend.
- **Database Migrations:** Implement Alembic or another tool for managing database schema changes.
- **User Authentication:** Add user accounts and authentication/authorization.
- **Image Handling:** Allow uploading images for events.
- **Improved UI/UX:** Refine the user interface and experience.
- **Testing:** Add unit and integration tests for both frontend and backend.
- **Deployment:** Set up deployment pipelines for both frontend and backend.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

_(Add specific contribution guidelines if desired)_

---

## 📜 License

_(Specify your license here, e.g., MIT License)_
