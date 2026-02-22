"""LLM client — provider abstraction for language model calls.

Handles: prompt construction, API calls, structured output parsing, retries, cost tracking.
Currently stubbed — no actual LLM calls.
"""

from app.config import settings


class LLMClient:
    """Abstraction over LLM providers (OpenAI, Anthropic, etc.)."""

    def __init__(self):
        self.api_key = settings.openai_api_key
        self.model = "gpt-4o"

    async def complete(self, system_prompt: str, user_message: str) -> str:
        """Send a completion request to the LLM.

        Stub — returns a placeholder response.
        """
        # TODO: actual LLM API call
        return f"[LLM stub] Received: {user_message[:100]}"

    async def complete_structured(self, system_prompt: str, user_message: str, schema: dict) -> dict:
        """Send a completion request expecting structured JSON output.

        Stub — returns an empty dict.
        """
        # TODO: actual LLM API call with JSON mode / function calling
        return {}


# Singleton
llm_client = LLMClient()
