#!/usr/bin/env python3
"""
Script to recreate database tables and add sample data
"""
import sys
import os
from datetime import datetime, timedelta

# Add the backend directory to Python path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from utils.database import engine, Base, SessionLocal
from models.database import User, Hackathon
from utils.auth import get_password_hash

def recreate_database():
    """Drop and recreate all database tables"""
    print("Dropping existing tables...")
    Base.metadata.drop_all(bind=engine)
    
    print("Creating new tables...")
    Base.metadata.create_all(bind=engine)
    
    print("Database tables recreated successfully!")

def create_sample_data():
    """Create sample users and hackathons"""
    db = SessionLocal()
    
    try:
        print("Creating sample users...")
        
        # Create superadmin user
        admin_user = User(
            email="admin@hackathon.com",
            username="admin",
            hashed_password=get_password_hash("admin123"),
            full_name="Super Admin",
            role="superadmin",
            is_active=True,
            registration_date=datetime.utcnow()
        )
        db.add(admin_user)
        
        # Create organizer user
        organizer_user = User(
            email="organizer@hackathon.com",
            username="organizer",
            hashed_password=get_password_hash("organizer123"),
            full_name="Event Organizer",
            role="organizer",
            is_active=True,
            registration_date=datetime.utcnow()
        )
        db.add(organizer_user)
        
        db.commit()
        db.refresh(admin_user)
        db.refresh(organizer_user)
        
        print("Sample users created successfully!")
        print("\nCredentials:")
        print("Admin: admin@hackathon.com / admin123")
        print("Organizer: organizer@hackathon.com / organizer123")
        
    except Exception as e:
        print(f"Error creating sample data: {str(e)}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    print("Recreating database...")
    recreate_database()
    create_sample_data()
    print("Database setup complete!")
