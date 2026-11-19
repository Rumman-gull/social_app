import { createClient } from '@supabase/supabase-js';

const supabaseUrl = "https://yqvuilyimthgdfwqqqxx.supabase.co";
const supabaseanonkey = import.meta.env.VITE_SUPABASE_ANON_KEY as string;


export const supabase = createClient(supabaseUrl, supabaseanonkey);