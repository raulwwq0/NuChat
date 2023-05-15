import { SupabaseException } from './supabase.exception';

export class SupabaseAuthException extends SupabaseException {
    constructor(message: string) {
        super(message);
        this.name = 'SupabaseAuthException';
    }
}
