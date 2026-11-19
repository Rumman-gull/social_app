import { createContext } from "react";
import { User } from "@supabase/supabase-js";

export interface AuthContextType {
  user: User | null;
  signInWithGitHub: () => void;
  signOut: () => void;
}

export const AuthContext = createContext<AuthContextType | undefined>(undefined);