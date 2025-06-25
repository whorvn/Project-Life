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
        
        print("Creating sample hackathons...")
        
        # Sample hackathon 1
        hackathon1 = Hackathon(
            name="AI Innovation Challenge 2025",
            description="Join us for an exciting 48-hour hackathon focused on AI and machine learning innovations. Build the next generation of AI applications that can solve real-world problems.",
            type="hybrid",
            theme="Artificial Intelligence & Machine Learning",
            location="Tech Hub, San Francisco",
            start_date=datetime.utcnow() + timedelta(days=30),
            end_date=datetime.utcnow() + timedelta(days=32),
            application_open=datetime.utcnow() + timedelta(days=1),
            application_close=datetime.utcnow() + timedelta(days=25),
            application_start_date=datetime.utcnow() + timedelta(days=1),
            application_end_date=datetime.utcnow() + timedelta(days=25),
            prize_pool="$50,000 in prizes: $25,000 First Place, $15,000 Second Place, $10,000 Third Place",
            rules="Teams of 2-6 members. Open source solutions preferred. No pre-existing code allowed.",
            eligibility="Open to all developers, students, and professionals",
            min_team_size=2,
            max_team_size=6,
            submission_requirements="Working prototype, presentation deck, source code repository",
            evaluation_criteria="Innovation, Technical Implementation, Business Impact, Presentation",
            communication_channels="Discord server will be provided",
            sponsors="TechCorp, AI Ventures, Cloud Solutions Inc.",
            status="upcoming",
            is_featured=True,
            landing_page_type="template",
            landing_color_scheme="#2196F3",
            has_sponsors=True,
            sponsors_data='[{"name": "TechCorp", "logo": ""}, {"name": "AI Ventures", "logo": ""}, {"name": "Cloud Solutions Inc.", "logo": ""}]',
            organizer_id=organizer_user.id,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow()
        )
        db.add(hackathon1)
        
        # Sample hackathon 2
        hackathon2 = Hackathon(
            name="Green Tech Sustainability Hack",
            description="Create innovative solutions to tackle climate change and environmental challenges. Focus on renewable energy, waste management, and sustainable living.",
            type="online",
            theme="Environmental Sustainability",
            location="Virtual Event",
            start_date=datetime.utcnow() + timedelta(days=45),
            end_date=datetime.utcnow() + timedelta(days=47),
            application_open=datetime.utcnow() + timedelta(days=5),
            application_close=datetime.utcnow() + timedelta(days=40),
            application_start_date=datetime.utcnow() + timedelta(days=5),
            application_end_date=datetime.utcnow() + timedelta(days=40),
            prize_pool="$30,000 total prizes plus mentorship opportunities",
            rules="Individual or team participation. Focus on environmental impact.",
            eligibility="Students and professionals in tech, environmental science, and related fields",
            min_team_size=1,
            max_team_size=4,
            submission_requirements="Project demo, impact analysis, technical documentation",
            evaluation_criteria="Environmental Impact, Feasibility, Innovation, Scalability",
            communication_channels="Slack workspace and virtual meetups",
            sponsors="GreenTech Foundation, EcoVentures",
            status="upcoming",
            is_featured=False,
            landing_page_type="template",
            landing_color_scheme="#4CAF50",
            has_sponsors=True,
            sponsors_data='[{"name": "GreenTech Foundation", "logo": ""}, {"name": "EcoVentures", "logo": ""}]',
            organizer_id=organizer_user.id,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow()
        )
        db.add(hackathon2)
        
        # Sample hackathon 3
        hackathon3 = Hackathon(
            name="FinTech Revolution",
            description="Revolutionize the financial industry with cutting-edge technology solutions. Focus on blockchain, digital payments, and financial inclusion.",
            type="offline",
            theme="Financial Technology",
            location="Financial District, New York",
            start_date=datetime.utcnow() + timedelta(days=60),
            end_date=datetime.utcnow() + timedelta(days=62),
            application_open=datetime.utcnow() + timedelta(days=10),
            application_close=datetime.utcnow() + timedelta(days=55),
            application_start_date=datetime.utcnow() + timedelta(days=10),
            application_end_date=datetime.utcnow() + timedelta(days=55),
            prize_pool="$75,000 in prizes and investment opportunities",
            rules="Professional teams welcome. Financial industry focus required.",
            eligibility="Developers, financial professionals, and entrepreneurs",
            min_team_size=3,
            max_team_size=5,
            submission_requirements="MVP, business plan, pitch presentation",
            evaluation_criteria="Market Potential, Technical Excellence, Financial Impact",
            communication_channels="In-person networking and online collaboration tools",
            sponsors="FinTech Bank, Investment Partners, Blockchain Corp",
            status="upcoming",
            is_featured=True,
            landing_page_type="template",
            landing_color_scheme="#FF9800",
            has_sponsors=True,
            sponsors_data='[{"name": "FinTech Bank", "logo": ""}, {"name": "Investment Partners", "logo": ""}, {"name": "Blockchain Corp", "logo": ""}]',
            organizer_id=organizer_user.id,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow()
        )
        db.add(hackathon3)
        
        db.commit()
        
        print("Sample data created successfully!")
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
