from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    supabase_url: str
    supabase_service_key: str
    openai_api_key: str = ""

    # Optional — IP geolocation (disabled when unset)
    geolite_bucket: str | None = None
    geolite_file: str | None = None

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}


settings = Settings()
