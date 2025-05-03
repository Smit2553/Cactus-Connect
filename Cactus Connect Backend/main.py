import os
import uuid
import psycopg2
from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def get_db_conn():
    return psycopg2.connect(
        dbname=os.getenv('PGDATABASE'),
        user=os.getenv('PGUSERNAME'),
        password=os.getenv('PGPASSWORD'),
        host=os.getenv('PGIP'),
        port=os.getenv('PGPORT')
    )

app = FastAPI(title="Cactus Connect API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
def health():
    try:
        conn = get_db_conn()
        cur = conn.cursor()
        cur.execute("SELECT 1")
        cur.close()
        conn.close()
        return {"status": "ok"}
    except Exception as e:
        return {"status": "error", "detail": str(e)}

@app.post("/cities/", status_code=status.HTTP_201_CREATED)
def create_city(city: dict):
    try:
        conn = get_db_conn()
        cur = conn.cursor()
        city_uuid = str(uuid.uuid4())
        cur.execute("INSERT INTO city (uuid, name) VALUES (%s, %s) RETURNING uuid, name", (city_uuid, city["name"]))
        result = cur.fetchone()
        conn.commit()
        cur.close()
        conn.close()
        return {"uuid": result[0], "name": result[1]}
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error creating city: {str(e)}")

@app.get("/cities/")
def read_cities():
    try:
        conn = get_db_conn()
        cur = conn.cursor()
        cur.execute("SELECT uuid, name FROM city")
        rows = cur.fetchall()
        cur.close()
        conn.close()
        return [{"uuid": row[0], "name": row[1]} for row in rows]
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error reading cities: {str(e)}")

@app.get("/cities/{city_uuid}")
def read_city(city_uuid: str):
    try:
        conn = get_db_conn()
        cur = conn.cursor()
        cur.execute("SELECT uuid, name FROM city WHERE uuid = %s", (city_uuid,))
        row = cur.fetchone()
        cur.close()
        conn.close()
        if not row:
            raise HTTPException(status_code=404, detail="City not found")
        return {"uuid": row[0], "name": row[1]}
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error reading city: {str(e)}")

@app.put("/cities/{city_uuid}")
def update_city(city_uuid: str, city: dict):
    try:
        conn = get_db_conn()
        cur = conn.cursor()
        cur.execute("UPDATE city SET name = %s WHERE uuid = %s RETURNING uuid, name", (city["name"], city_uuid))
        row = cur.fetchone()
        conn.commit()
        cur.close()
        conn.close()
        if not row:
            raise HTTPException(status_code=404, detail="City not found")
        return {"uuid": row[0], "name": row[1]}
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error updating city: {str(e)}")

# @app.delete("/cities/{city_uuid}", status_code=status.HTTP_204_NO_CONTENT)
# def delete_city(city_uuid: str):
#     try:
#         conn = get_db_conn()
#         cur = conn.cursor()
#         cur.execute("DELETE FROM city WHERE uuid = %s", (city_uuid,))
#         conn.commit()
#         cur.close()
#         conn.close()
#         return None
#     except Exception as e:
#         raise HTTPException(status_code=400, detail=f"Error deleting city: {str(e)}")

@app.post("/events/", status_code=status.HTTP_201_CREATED)
def create_event(event: dict):
    try:
        conn = get_db_conn()
        cur = conn.cursor()
        event_uuid = str(uuid.uuid4())
        cur.execute(
            "INSERT INTO event (uuid, name, url, description, category, isvolunteerevent, city_uuid, location, date) "
            "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING uuid, name, url, description, category, isvolunteerevent, city_uuid, location, date",
            (event_uuid, event["name"], event.get("url"), event.get("description"), event.get("category"),
             event.get("isVolunteerEvent", False), event["city_uuid"], event.get("location"), event.get("date"))
        )
        result = cur.fetchone()
        conn.commit()
        cur.close()
        conn.close()
        return {
            "uuid": result[0], "name": result[1], "url": result[2], "description": result[3], "category": result[4],
            "isVolunteerEvent": result[5], "city_uuid": result[6], "location": result[7], "date": result[8]
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error creating event: {str(e)}")

@app.get("/events/")
def read_events():
    try:
        conn = get_db_conn()
        cur = conn.cursor()
        cur.execute("SELECT uuid, name, url, description, category, isvolunteerevent, city_uuid, location, date FROM event")
        rows = cur.fetchall()
        cur.close()
        conn.close()
        return [
            {
                "uuid": row[0], "name": row[1], "url": row[2], "description": row[3], "category": row[4],
                "isVolunteerEvent": row[5], "city_uuid": row[6], "location": row[7], "date": row[8]
            } for row in rows
        ]
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error reading events: {str(e)}")

@app.get("/events/{event_uuid}")
def read_event(event_uuid: str):
    try:
        conn = get_db_conn()
        cur = conn.cursor()
        cur.execute("SELECT uuid, name, url, description, category, isvolunteerevent, city_uuid, location, date FROM event WHERE uuid = %s", (event_uuid,))
        row = cur.fetchone()
        cur.close()
        conn.close()
        if not row:
            raise HTTPException(status_code=404, detail="Event not found")
        return {
            "uuid": row[0], "name": row[1], "url": row[2], "description": row[3], "category": row[4],
            "isVolunteerEvent": row[5], "city_uuid": row[6], "location": row[7], "date": row[8]
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error reading event: {str(e)}")

@app.put("/events/{event_uuid}")
def update_event(event_uuid: str, event: dict):
    try:
        conn = get_db_conn()
        cur = conn.cursor()
        cur.execute(
            "UPDATE event SET name = %s, url = %s, description = %s, category = %s, isvolunteerevent = %s, city_uuid = %s, location = %s, date = %s "
            "WHERE uuid = %s RETURNING uuid, name, url, description, category, isvolunteerevent, city_uuid, location, date",
            (event["name"], event.get("url"), event.get("description"), event.get("category"),
             event.get("isVolunteerEvent", False), event["city_uuid"], event.get("location"), event.get("date"), event_uuid)
        )
        row = cur.fetchone()
        conn.commit()
        cur.close()
        conn.close()
        if not row:
            raise HTTPException(status_code=404, detail="Event not found")
        return {
            "uuid": row[0], "name": row[1], "url": row[2], "description": row[3], "category": row[4],
            "isVolunteerEvent": row[5], "city_uuid": row[6], "location": row[7], "date": row[8]
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error updating event: {str(e)}")

# @app.delete("/events/{event_uuid}", status_code=status.HTTP_204_NO_CONTENT)
# def delete_event(event_uuid: str):
#     try:
#         conn = get_db_conn()
#         cur = conn.cursor()
#         cur.execute("DELETE FROM event WHERE uuid = %s", (event_uuid,))
#         conn.commit()
#         cur.close()
#         conn.close()
#         return None
#     except Exception as e:
#         raise HTTPException(status_code=400, detail=f"Error deleting event: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)