"""
AI service layer — wraps OpenAI for voice, mood, sentiment, and OCR responses.
Falls back gracefully if OPENAI_API_KEY is not set.
"""
from app.core.config import settings
import base64
import io

try:
    from openai import AsyncOpenAI
    client = AsyncOpenAI(api_key=settings.OPENAI_API_KEY) if settings.OPENAI_API_KEY else None
except Exception:
    client = None

MOOD_PROMPTS = {
    1: "very sad or struggling",
    2: "feeling low",
    3: "neutral or okay",
    4: "good and positive",
    5: "excellent and joyful",
}


async def get_mood_feedback(mood_score: int, notes: str) -> str:
    if not client:
        fallback = {
            1: "It's okay to have hard days. Be gentle with yourself today.",
            2: "Low days pass. Try one small kind act for yourself.",
            3: "A steady day — that's perfectly fine. Keep going.",
            4: "Great to hear you're doing well! Keep the momentum.",
            5: "You're shining today! That energy is contagious.",
        }
        return fallback.get(mood_score, "Thank you for checking in.")

    mood_desc = MOOD_PROMPTS.get(mood_score, "okay")
    prompt = (
        f"A user with a disability says they're feeling {mood_desc}. "
        f"Their note: '{notes}'. "
        "Give a warm, encouraging 1-2 sentence response. Be empathetic, not clinical."
    )
    resp = await client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        max_tokens=100,
    )
    return resp.choices[0].message.content.strip()


async def get_sentiment_score(text: str) -> float:
    """Returns a float from -1.0 (very negative) to 1.0 (very positive)."""
    if not client:
        return 0.0
    prompt = (
        f"Score the sentiment of this text from -1.0 (very negative) to 1.0 (very positive). "
        f"Reply with only the float number, nothing else.\n\nText: {text}"
    )
    resp = await client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        max_tokens=10,
    )
    try:
        return float(resp.choices[0].message.content.strip())
    except ValueError:
        return 0.0


async def process_voice_command(text: str, context: str, disability_types: list) -> dict:
    if not client:
        return {
            "response_text": f"I heard: '{text}'. AI is not configured yet — add your OPENAI_API_KEY.",
            "action": None,
            "action_payload": None,
        }

    system = (
        "You are an AI accessibility assistant inside the Orth_pedeon app. "
        f"The user has these accessibility needs: {', '.join(disability_types) or 'general'}. "
        f"Current screen context: {context}. "
        "Help them complete digital tasks. If they want to navigate, send a message, set a reminder, "
        "or read something, return a JSON with keys: response_text, action (one of: open_screen, "
        "send_message, set_reminder, read_content, none), action_payload (dict or null). "
        "Keep responses concise and warm."
    )
    resp = await client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": system},
            {"role": "user", "content": text},
        ],
        max_tokens=200,
        response_format={"type": "json_object"},
    )
    import json
    try:
        return json.loads(resp.choices[0].message.content)
    except Exception:
        return {"response_text": resp.choices[0].message.content, "action": None, "action_payload": None}


async def perform_ocr(image_base64: str) -> dict:
    """Use GPT-4o vision to extract text from an image."""
    if not client:
        return {"extracted_text": "OCR requires OPENAI_API_KEY to be set.", "confidence": 0.0}

    resp = await client.chat.completions.create(
        model="gpt-4o",
        messages=[{
            "role": "user",
            "content": [
                {"type": "image_url", "image_url": {"url": f"data:image/jpeg;base64,{image_base64}"}},
                {"type": "text", "text": "Extract all text from this image. Return only the extracted text, nothing else."},
            ],
        }],
        max_tokens=500,
    )
    text = resp.choices[0].message.content.strip()
    return {"extracted_text": text, "confidence": 0.95}
