from pydantic import BaseModel, EmailStr
from typing import Optional, List, Dict, Any
from datetime import datetime
from enum import Enum

# Enums
class UserRole(str, Enum):
    SUPERADMIN = "superadmin"
    ORGANIZER = "organizer"

class HackathonStatus(str, Enum):
    UPCOMING = "upcoming"
    ONGOING = "ongoing"
    PAST = "past"

class ParticipantStatus(str, Enum):
    APPLIED = "applied"
    APPROVED = "approved"
    REJECTED = "rejected"

class TeamStatus(str, Enum):
    FORMING = "forming"
    COMPLETE = "complete"
    SUBMITTED = "submitted"

class SubmissionStatus(str, Enum):
    SUBMITTED = "submitted"
    UNDER_REVIEW = "under_review"
    EVALUATED = "evaluated"

# Authentication Models
class UserLogin(BaseModel):
    email: EmailStr
    password: str
    remember_me: Optional[bool] = False

class UserCreate(BaseModel):
    email: EmailStr
    username: str
    password: str
    full_name: str
    role: UserRole

class UserResponse(BaseModel):
    id: int
    email: str
    username: str
    full_name: str
    role: str
    is_active: bool
    registration_date: datetime
    last_login: Optional[datetime]
    
    class Config:
        from_attributes = True

class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse
    expires_in: int

# Dashboard Models
class DashboardMetrics(BaseModel):
    total_hackathons: int
    total_organizers: int
    total_participants: int
    total_teams: int
    total_submissions: int
    total_mentor_sessions: int
    average_participants_per_hackathon: float
    active_hackathons: int

class ChartData(BaseModel):
    labels: List[str]
    datasets: List[Dict[str, Any]]

class DashboardFilters(BaseModel):
    date_range: Optional[str] = None
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    organizer_id: Optional[int] = None
    status: Optional[HackathonStatus] = None
    region: Optional[str] = None
    hackathon_type: Optional[str] = None
    hackathon_id: Optional[int] = None

class DashboardResponse(BaseModel):
    metrics: DashboardMetrics
    charts: Dict[str, ChartData]
    recent_activities: List[Dict[str, Any]]
    filters: DashboardFilters

# Hackathon Models
class HackathonBase(BaseModel):
    name: str
    description: str
    type: Optional[str] = None  # 'online', 'offline', 'hybrid'
    theme: Optional[str] = None
    location: Optional[str] = None
    start_date: datetime
    end_date: datetime
    application_open: Optional[datetime] = None
    application_close: Optional[datetime] = None
    application_start_date: Optional[datetime] = None  # When applications start
    application_end_date: Optional[datetime] = None    # When applications end
    prize_pool: str
    rules: str
    eligibility: Optional[str] = None
    min_team_size: int = 1
    max_team_size: int = 4
    submission_requirements: Optional[str] = None
    evaluation_criteria: Optional[str] = None
    communication_channels: Optional[str] = None
    sponsors: Optional[str] = None
    # Landing page configuration - Essential fields only
    landing_page_type: Optional[str] = "template"
    custom_landing_url: Optional[str] = None
    landing_color_scheme: Optional[str] = "#1976d2"  # Keep as string for now
    landing_logo_url: Optional[str] = None
    has_sponsors: Optional[bool] = False
    sponsors_data: Optional[str] = None  # JSON string for now

class HackathonCreate(BaseModel):
    name: str
    description: str
    type: Optional[str] = None  # online, offline, hybrid
    theme_focus_area: Optional[str] = None
    start_date: datetime
    end_date: datetime
    application_open: Optional[datetime] = None
    application_close: Optional[datetime] = None
    application_start_date: Optional[datetime] = None  # When applications start
    application_end_date: Optional[datetime] = None    # When applications end
    prize_pool_details: str
    timezone: Optional[str] = "UTC"
    location: Optional[str] = None
    rules: str
    min_team_size: int = 1
    max_team_size: int = 4
    # Landing page configuration - Essential fields only
    landing_page_type: Optional[str] = "template"
    custom_landing_url: Optional[str] = None
    landing_color_scheme: Optional[str] = "#1976d2"
    landing_logo_url: Optional[str] = None
    has_sponsors: Optional[bool] = False
    sponsors_data: Optional[str] = None

class HackathonUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    type: Optional[str] = None
    theme_focus_area: Optional[str] = None  # Frontend field name
    location: Optional[str] = None
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    application_open: Optional[datetime] = None
    application_close: Optional[datetime] = None
    application_start_date: Optional[datetime] = None
    application_end_date: Optional[datetime] = None
    prize_pool_details: Optional[str] = None  # Frontend field name
    timezone: Optional[str] = None
    rules: Optional[str] = None
    eligibility: Optional[str] = None
    min_team_size: Optional[int] = None
    max_team_size: Optional[int] = None
    submission_requirements: Optional[str] = None
    evaluation_criteria: Optional[str] = None
    communication_channels: Optional[str] = None
    sponsors: Optional[str] = None
    status: Optional[str] = None
    # Landing page configuration - Essential fields only
    landing_page_type: Optional[str] = None
    custom_landing_url: Optional[str] = None
    landing_color_scheme: Optional[str] = None
    landing_logo_url: Optional[str] = None
    has_sponsors: Optional[bool] = None
    sponsors_data: Optional[str] = None

class HackathonResponse(BaseModel):
    id: int
    name: str
    description: str
    type: Optional[str] = None
    theme_focus_area: Optional[str] = None
    location: Optional[str] = None
    start_date: datetime
    end_date: datetime
    application_start_date: Optional[datetime] = None
    application_end_date: Optional[datetime] = None
    prize_pool_details: str
    timezone: Optional[str] = None
    rules: str
    min_team_size: int
    max_team_size: int
    status: str
    is_featured: bool
    organizer: UserResponse
    participant_count: int
    team_count: int
    submission_count: int
    created_at: datetime
    updated_at: datetime
    # Landing page configuration - Essential fields only
    landing_page_type: Optional[str] = None
    custom_landing_url: Optional[str] = None
    landing_color_scheme: Optional[str] = None
    landing_logo_url: Optional[str] = None
    has_sponsors: Optional[bool] = None
    sponsors_data: Optional[str] = None
    
    class Config:
        from_attributes = True

class HackathonListResponse(BaseModel):
    hackathons: List[HackathonResponse]
    total: int
    page: int
    size: int
    has_next: bool
    has_prev: bool

# Generic Response Models
class SuccessResponse(BaseModel):
    success: bool
    message: str
    data: Optional[Dict[str, Any]] = None

class ErrorResponse(BaseModel):
    success: bool = False
    message: str
    details: Optional[str] = None
