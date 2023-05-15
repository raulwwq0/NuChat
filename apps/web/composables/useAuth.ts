import { SupabaseAuthException } from '~~/exceptions/supabase-auth.exception';
import { OAuthProvider } from '~~/types/oauth-provider.type';

export const useAuth = (provider?: OAuthProvider) => {
    const supabase = useSupabaseClient();
    const config = useRuntimeConfig();

    const signInWithEmail = async (email: string) => {
        const { error } = await supabase.auth.signInWithOtp({
            email,
            options: {
                emailRedirectTo: `${config.public.baseUrl}/auth/processing`,
            },
        });

        if (error) {
            throw new SupabaseAuthException(error.message);
        }
    };

    const signInOAuth = () => {
        return supabase.auth
            .signInWithOAuth({
                provider: provider!,
                options: {
                    redirectTo: `${config.public.baseUrl}/auth/processing`,
                },
            })
            .catch(error => {
                throw new SupabaseAuthException(error.message);
            });
    };

    const verifyOTP = (email: string, token: string) => {
        return supabase.auth
            .verifyOtp({
                email,
                token,
                // @ts-ignore
                type: 'email',
            })
            .catch(error => {
                throw new SupabaseAuthException(error.message);
            });
    };

    return {
        signInOAuth,
        signInWithEmail,
        verifyOTP,
    };
};
