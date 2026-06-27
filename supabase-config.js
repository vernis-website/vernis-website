// Shared Supabase connection used across all Vernis pages.
// The anon key is SAFE to expose publicly — it only allows what our
// Row Level Security rules permit (see backend/setup.sql).
const SUPABASE_URL = "https://torwgszzuemafngmzbpw.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRvcndnc3p6dWVtYWZuZ216YnB3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI0NDk2NjIsImV4cCI6MjA5ODAyNTY2Mn0.g5sjO-u4eNtJKftTOXp9P9rG8sJrXhH1ZmoYrtpvSTc";

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
