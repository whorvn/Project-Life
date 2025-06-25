from sqlalchemy import Column, Integer, String, DateTime, Boolean, Text, ForeignKey, Float, JSON
from sqlalchemy.orm import relationship
from datetime import datetime
from utils.database import Base

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    username = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    full_name = Column(String, nullable=False)
    role = Column(String, nullable=False)  # 'superadmin' or 'organizer'
    is_active = Column(Boolean, default=True)
    registration_date = Column(DateTime, default=datetime.utcnow)
    last_login = Column(DateTime, nullable=True)
    profile_data = Column(JSON, nullable=True)  # Additional profile information
    
    # Relationships
    organized_hackathons = relationship("Hackathon", back_populates="organizer")
    activity_logs = relationship("ActivityLog", back_populates="user")

class Hackathon(Base):
    __tablename__ = "hackathons"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False, index=True)
    description = Column(Text, nullable=False)
    type = Column(String, nullable=True)  # 'online', 'offline', 'hybrid'
    theme = Column(String, nullable=True)
    location = Column(String, nullable=True)  # Location for offline/hybrid events
    start_date = Column(DateTime, nullable=False)
    end_date = Column(DateTime, nullable=False)
    application_open = Column(DateTime, nullable=False)  # Keep for backward compatibility
    application_close = Column(DateTime, nullable=False)  # Keep for backward compatibility
    application_start_date = Column(DateTime, nullable=True)  # New: When applications open
    application_end_date = Column(DateTime, nullable=True)    # New: When applications close
    prize_pool = Column(String, nullable=False)
    rules = Column(Text, nullable=False)
    eligibility = Column(Text, nullable=True)
    min_team_size = Column(Integer, default=1)
    max_team_size = Column(Integer, default=4)
    submission_requirements = Column(Text, nullable=False)
    evaluation_criteria = Column(Text, nullable=True)
    communication_channels = Column(Text, nullable=False)
    sponsors = Column(Text, nullable=True)
    status = Column(String, default="upcoming")  # 'upcoming', 'ongoing', 'past'
    is_featured = Column(Boolean, default=False)
    
    # Landing page configuration - Essential fields only
    landing_page_type = Column(String, default="template")  # 'template' or 'custom'
    custom_landing_url = Column(String, nullable=True)
    landing_color_scheme = Column(String, default="#1976d2")  # Keep as string for now
    landing_logo_url = Column(String, nullable=True)
    has_sponsors = Column(Boolean, default=False)
    sponsors_data = Column(Text, nullable=True)  # JSON string of sponsor data
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Foreign keys
    organizer_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    
    # Relationships
    organizer = relationship("User", back_populates="organized_hackathons")
    teams = relationship("Team", back_populates="hackathon")
    participants = relationship("Participant", back_populates="hackathon")
    submissions = relationship("Submission", back_populates="hackathon")
    mentor_sessions = relationship("MentorSession", back_populates="hackathon")

class Participant(Base):
    __tablename__ = "participants"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, nullable=False)
    university_company = Column(String, nullable=True)
    region = Column(String, nullable=True)
    skills = Column(JSON, nullable=True)
    registration_date = Column(DateTime, default=datetime.utcnow)
    status = Column(String, default="applied")  # 'applied', 'approved', 'rejected'
    
    # Foreign keys
    hackathon_id = Column(Integer, ForeignKey("hackathons.id"), nullable=False)
    team_id = Column(Integer, ForeignKey("teams.id"), nullable=True)
    
    # Relationships
    hackathon = relationship("Hackathon", back_populates="participants")
    team = relationship("Team", back_populates="members")

class Team(Base):
    __tablename__ = "teams"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    status = Column(String, default="forming")  # 'forming', 'complete', 'submitted'
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Foreign keys
    hackathon_id = Column(Integer, ForeignKey("hackathons.id"), nullable=False)
    
    # Relationships
    hackathon = relationship("Hackathon", back_populates="teams")
    members = relationship("Participant", back_populates="team")
    submissions = relationship("Submission", back_populates="team")

class Submission(Base):
    __tablename__ = "submissions"
    
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(Text, nullable=False)
    github_url = Column(String, nullable=True)
    demo_url = Column(String, nullable=True)
    presentation_url = Column(String, nullable=True)
    status = Column(String, default="submitted")  # 'submitted', 'under_review', 'evaluated'
    score = Column(Float, nullable=True)
    feedback = Column(Text, nullable=True)
    submitted_at = Column(DateTime, default=datetime.utcnow)
    evaluated_at = Column(DateTime, nullable=True)
    
    # Foreign keys
    hackathon_id = Column(Integer, ForeignKey("hackathons.id"), nullable=False)
    team_id = Column(Integer, ForeignKey("teams.id"), nullable=False)
    
    # Relationships
    hackathon = relationship("Hackathon", back_populates="submissions")
    team = relationship("Team", back_populates="submissions")

class MentorSession(Base):
    __tablename__ = "mentor_sessions"
    
    id = Column(Integer, primary_key=True, index=True)
    mentor_name = Column(String, nullable=False)
    mentor_email = Column(String, nullable=False)
    session_topic = Column(String, nullable=False)
    session_date = Column(DateTime, nullable=False)
    duration_minutes = Column(Integer, default=60)
    max_participants = Column(Integer, default=10)
    registered_count = Column(Integer, default=0)
    meeting_link = Column(String, nullable=True)
    notes = Column(Text, nullable=True)
    
    # Foreign keys
    hackathon_id = Column(Integer, ForeignKey("hackathons.id"), nullable=False)
    
    # Relationships
    hackathon = relationship("Hackathon", back_populates="mentor_sessions")

class ActivityLog(Base):
    __tablename__ = "activity_logs"
    
    id = Column(Integer, primary_key=True, index=True)
    action = Column(String, nullable=False)
    resource_type = Column(String, nullable=False)  # 'hackathon', 'user', 'team', etc.
    resource_id = Column(Integer, nullable=True)
    details = Column(JSON, nullable=True)
    timestamp = Column(DateTime, default=datetime.utcnow)
    ip_address = Column(String, nullable=True)
    
    # Foreign keys
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    
    # Relationships
    user = relationship("User", back_populates="activity_logs")
