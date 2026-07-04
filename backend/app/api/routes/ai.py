from fastapi import APIRouter, Depends
from backend.app.schemas.ai import VoiceCommandRequest, VoiceCommandResponse, OCRRequest, OCRResponse
from backend.app.services.auth_service import get_current_user
from backend.app.ai.openai_service import process_voice_command, perform_ocr
from backend.app.models.user import User

router = APIRouter(prefix="/ai", tags=["AI"])


@router.post("/voice", response_model=VoiceCommandResponse)
async def voice_command(data: VoiceCommandRequest, user: User = Depends(get_current_user)):
    result = await process_voice_command(
        text=data.text,
        context=data.context or "dashboard",
        disability_types=user.disability_types or [],
    )
    return VoiceCommandResponse(**result)


@router.post("/ocr", response_model=OCRResponse)
async def ocr(data: OCRRequest, user: User = Depends(get_current_user)):
    result = await perform_ocr(data.image_base64)
    return OCRResponse(**result)
