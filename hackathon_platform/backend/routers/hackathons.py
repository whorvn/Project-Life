from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime
from utils.database import get_db
from models.database import Hackathon, User
from models.schemas import (
    HackathonCreate, HackathonResponse, HackathonUpdate, HackathonListResponse,
    SuccessResponse, ErrorResponse
)
from utils.auth import get_current_active_user

router = APIRouter(prefix="/hackathons", tags=["hackathons"])

@router.get("/", response_model=HackathonListResponse)
async def get_hackathons(
    page: int = Query(1, ge=1),
    size: int = Query(10, ge=1, le=100),
    status: str = Query(None),
    search: str = Query(None),
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get paginated list of hackathons"""
    try:
        query = db.query(Hackathon)
        
        # Apply filters based on user role
        if current_user.role == "organizer":
            query = query.filter(Hackathon.organizer_id == current_user.id)
        
        # Apply status filter
        if status:
            query = query.filter(Hackathon.status == status)
        
        # Apply search filter
        if search:
            query = query.filter(
                Hackathon.name.contains(search) | 
                Hackathon.description.contains(search)
            )
        
        # Get total count
        total = query.count()
        
        # Apply pagination
        hackathons = query.offset((page - 1) * size).limit(size).all()
        
        # Convert to response format
        hackathon_responses = []
        for hackathon in hackathons:
            hackathon_dict = hackathon.__dict__.copy()
            hackathon_dict['organizer'] = hackathon.organizer
            hackathon_dict['participant_count'] = len(hackathon.participants)
            hackathon_dict['team_count'] = len(hackathon.teams)
            hackathon_dict['submission_count'] = len(hackathon.submissions)
            
            # Map field names for frontend compatibility
            hackathon_dict['prize_pool_details'] = hackathon_dict.get('prize_pool', '')
            hackathon_dict['theme_focus_area'] = hackathon_dict.get('theme', '')
            hackathon_dict['application_start_date'] = hackathon_dict.get('application_start_date')
            hackathon_dict['application_end_date'] = hackathon_dict.get('application_end_date')
            
            hackathon_responses.append(HackathonResponse(**hackathon_dict))
        
        return HackathonListResponse(
            hackathons=hackathon_responses,
            total=total,
            page=page,
            size=size,
            has_next=(page * size) < total,
            has_prev=page > 1
        )
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch hackathons: {str(e)}"
        )

@router.get("/{hackathon_id}", response_model=HackathonResponse)
async def get_hackathon(
    hackathon_id: int,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get specific hackathon details"""
    try:
        hackathon = db.query(Hackathon).filter(Hackathon.id == hackathon_id).first()
        
        if not hackathon:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Hackathon not found"
            )
        
        # Check access permissions
        if current_user.role == "organizer" and hackathon.organizer_id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Access denied"
            )
        
        # Prepare response
        hackathon_dict = hackathon.__dict__.copy()
        hackathon_dict['organizer'] = hackathon.organizer
        hackathon_dict['participant_count'] = len(hackathon.participants)
        hackathon_dict['team_count'] = len(hackathon.teams)
        hackathon_dict['submission_count'] = len(hackathon.submissions)
        
        # Map field names for frontend compatibility and ensure required fields have values
        hackathon_dict['prize_pool_details'] = hackathon_dict.get('prize_pool') or ''
        hackathon_dict['theme_focus_area'] = hackathon_dict.get('theme') or ''
        hackathon_dict['application_start_date'] = hackathon_dict.get('application_start_date')
        hackathon_dict['application_end_date'] = hackathon_dict.get('application_end_date')
        
        # Ensure all required fields have default values if missing
        if 'prize_pool_details' not in hackathon_dict or hackathon_dict['prize_pool_details'] is None:
            hackathon_dict['prize_pool_details'] = ''
        if 'theme_focus_area' not in hackathon_dict or hackathon_dict['theme_focus_area'] is None:
            hackathon_dict['theme_focus_area'] = ''
        
        return HackathonResponse(**hackathon_dict)
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch hackathon: {str(e)}"
        )

@router.post("/", response_model=HackathonResponse)
async def create_hackathon(
    hackathon_data: HackathonCreate,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Create a new hackathon"""
    try:
        # Check permissions
        if current_user.role not in ["organizer", "superadmin"]:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only organizers and super admins can create hackathons"
            )
        
        # Create hackathon instance
        hackathon = Hackathon(
            name=hackathon_data.name,
            description=hackathon_data.description,
            type=hackathon_data.type,
            theme=hackathon_data.theme_focus_area,
            location=hackathon_data.location,
            start_date=hackathon_data.start_date,
            end_date=hackathon_data.end_date,
            application_open=hackathon_data.application_open or hackathon_data.start_date,
            application_close=hackathon_data.application_close or hackathon_data.start_date,
            application_start_date=hackathon_data.application_start_date,
            application_end_date=hackathon_data.application_end_date,
            prize_pool=hackathon_data.prize_pool_details,
            rules=hackathon_data.rules,
            eligibility="Open to all participants",  # Default eligibility
            min_team_size=hackathon_data.min_team_size,
            max_team_size=hackathon_data.max_team_size,
            submission_requirements="TBD",  # Default submission requirements
            evaluation_criteria="TBD",  # Default evaluation criteria
            communication_channels="TBD",  # Default communication channels
            sponsors=None,  # Default sponsors
            # Landing page configuration
            landing_page_type=hackathon_data.landing_page_type,
            custom_landing_url=hackathon_data.custom_landing_url,
            landing_color_scheme=hackathon_data.landing_color_scheme,
            landing_logo_url=hackathon_data.landing_logo_url,
            has_sponsors=hackathon_data.has_sponsors,
            sponsors_data=hackathon_data.sponsors_data,
            organizer_id=current_user.id,
            status="upcoming",  # Default status
            is_featured=False,  # Default to not featured
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow()
        )
        
        # Save to database
        db.add(hackathon)
        db.commit()
        db.refresh(hackathon)
        
        # Prepare response
        hackathon_dict = hackathon.__dict__.copy()
        hackathon_dict['organizer'] = current_user
        hackathon_dict['participant_count'] = 0
        hackathon_dict['team_count'] = 0
        hackathon_dict['submission_count'] = 0
        
        # Map field names for frontend compatibility and ensure required fields have values
        hackathon_dict['prize_pool_details'] = hackathon_dict.get('prize_pool') or ''
        hackathon_dict['theme_focus_area'] = hackathon_dict.get('theme') or ''
        hackathon_dict['application_start_date'] = hackathon_dict.get('application_start_date')
        hackathon_dict['application_end_date'] = hackathon_dict.get('application_end_date')
        
        # Ensure all required fields have default values if missing
        if 'prize_pool_details' not in hackathon_dict or hackathon_dict['prize_pool_details'] is None:
            hackathon_dict['prize_pool_details'] = ''
        if 'theme_focus_area' not in hackathon_dict or hackathon_dict['theme_focus_area'] is None:
            hackathon_dict['theme_focus_area'] = ''
        
        return HackathonResponse(**hackathon_dict)
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create hackathon: {str(e)}"
        )

@router.put("/{hackathon_id}", response_model=HackathonResponse)
async def update_hackathon(
    hackathon_id: int,
    hackathon_data: HackathonUpdate,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Update an existing hackathon"""
    try:
        hackathon = db.query(Hackathon).filter(Hackathon.id == hackathon_id).first()
        
        if not hackathon:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Hackathon not found"
            )
        
        # Check permissions
        if current_user.role == "organizer" and hackathon.organizer_id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You can only update your own hackathons"
            )
        
        # Update fields with proper field name mapping
        update_data = hackathon_data.dict(exclude_unset=True)
        
        # Field name mappings from frontend to database
        field_mappings = {
            'theme_focus_area': 'theme',
            'prize_pool_details': 'prize_pool'
        }
        
        for field, value in update_data.items():
            if value is not None:
                # Map frontend field names to database field names
                db_field = field_mappings.get(field, field)
                if hasattr(hackathon, db_field):
                    setattr(hackathon, db_field, value)
        
        hackathon.updated_at = datetime.utcnow()
        
        db.commit()
        db.refresh(hackathon)
        
        # Prepare response
        hackathon_dict = hackathon.__dict__.copy()
        hackathon_dict['organizer'] = hackathon.organizer
        hackathon_dict['participant_count'] = len(hackathon.participants)
        hackathon_dict['team_count'] = len(hackathon.teams)
        hackathon_dict['submission_count'] = len(hackathon.submissions)
        
        # Map field names for frontend compatibility and ensure required fields have values
        hackathon_dict['prize_pool_details'] = hackathon_dict.get('prize_pool') or ''
        hackathon_dict['theme_focus_area'] = hackathon_dict.get('theme') or ''
        hackathon_dict['application_start_date'] = hackathon_dict.get('application_start_date')
        hackathon_dict['application_end_date'] = hackathon_dict.get('application_end_date')
        
        # Ensure all required fields have default values if missing
        if 'prize_pool_details' not in hackathon_dict or hackathon_dict['prize_pool_details'] is None:
            hackathon_dict['prize_pool_details'] = ''
        if 'theme_focus_area' not in hackathon_dict or hackathon_dict['theme_focus_area'] is None:
            hackathon_dict['theme_focus_area'] = ''
        
        return HackathonResponse(**hackathon_dict)
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to update hackathon: {str(e)}"
        )

@router.delete("/{hackathon_id}", response_model=SuccessResponse)
async def delete_hackathon(
    hackathon_id: int,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Delete a hackathon"""
    try:
        hackathon = db.query(Hackathon).filter(Hackathon.id == hackathon_id).first()
        
        if not hackathon:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Hackathon not found"
            )
        
        # Check permissions
        if current_user.role == "organizer" and hackathon.organizer_id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You can only delete your own hackathons"
            )
        
        # Delete related records (cascade delete)
        for participant in hackathon.participants:
            db.delete(participant)
        
        for team in hackathon.teams:
            db.delete(team)
        
        for mentor_session in hackathon.mentor_sessions:
            db.delete(mentor_session)
        
        for submission in hackathon.submissions:
            db.delete(submission)
        
        # Delete the hackathon
        db.delete(hackathon)
        db.commit()
        
        return SuccessResponse(
            success=True,
            message="Hackathon deleted successfully"
        )
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to delete hackathon: {str(e)}"
        )

@router.get("/{hackathon_id}/landing", response_model=dict)
async def get_hackathon_landing_page(
    hackathon_id: int,
    db: Session = Depends(get_db)
):
    """Get hackathon landing page data (public endpoint)"""
    try:
        hackathon = db.query(Hackathon).filter(Hackathon.id == hackathon_id).first()
        
        if not hackathon:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Hackathon not found"
            )
        
        # Return landing page data
        landing_data = {
            "id": hackathon.id,
            "name": hackathon.name,
            "description": hackathon.description,
            "type": hackathon.type,
            "theme_focus_area": hackathon.theme,
            "location": hackathon.location,
            "start_date": hackathon.start_date.isoformat() if hackathon.start_date else None,
            "end_date": hackathon.end_date.isoformat() if hackathon.end_date else None,
            "application_start_date": hackathon.application_start_date.isoformat() if hackathon.application_start_date else None,
            "application_end_date": hackathon.application_end_date.isoformat() if hackathon.application_end_date else None,
            "prize_pool_details": hackathon.prize_pool,
            "rules": hackathon.rules,
            "min_team_size": hackathon.min_team_size,
            "max_team_size": hackathon.max_team_size,
            "landing_page_type": hackathon.landing_page_type or "template",
            "custom_landing_url": hackathon.custom_landing_url,
            "landing_color_scheme": hackathon.landing_color_scheme or "#1976d2",
            "landing_logo_url": hackathon.landing_logo_url,
            "has_sponsors": hackathon.has_sponsors or False,
            "sponsors_data": hackathon.sponsors_data,
        }
        
        return landing_data
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch landing page data: {str(e)}"
        )
