import { OAuthProvider } from '~~/types/oauth-provider.type';

export const useAuth = (provider: OAuthProvider | null) => {
    const supabase = useSupabaseClient();
    const config = useRuntimeConfig();

    const signInOAuth = () => {
        supabase.auth
            .signInWithOAuth({
                provider: provider!,
                options: {
                    redirectTo: `${config.public.baseUrl}/auth/processing`,
                },
            })
            .catch(error => {
                console.error(error);
            });
    };

    return {
        signInOAuth,
    };
};
