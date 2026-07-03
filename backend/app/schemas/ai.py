from pydantic import BaseModel
from typing import Optional


class VoiceCommandRequest(BaseModel):
    text: str
    context: Optional[str] = None    # current_screen, last_action, etc.
    user_disability_types: list = []


class VoiceCommandResponse(BaseModel):
    response_text: str
    action: Optional[str] = None     # open_screen | send_message | set_reminder | read_content
    action_payload: Optional[dict] = None
    audio_url: Optional[str] = None


class OCRRequest(BaseModel):
    image_base64: str


class OCRResponse(BaseModel):
    extracted_text: str
    confidence: float


class SentimentResponse(BaseModel):
    score: float     # -1.0 to 1.0
    label: str       # positive | neutral | negative
