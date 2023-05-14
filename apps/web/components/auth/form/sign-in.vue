<script lang="ts" setup>
    const config = useRuntimeConfig();
    const supabase = useSupabaseClient();
    const isSendingLink = ref(false);
    const email = ref('');
    const handleLogin = async () => {
        try {
            isSendingLink.value = true;
            const { error } = await supabase.auth.signInWithOtp({
                email: email.value,
                options: {
                    emailRedirectTo: `${config.public.baseUrl}/auth/processing`,
                },
            });
            if (error) throw error;
            alert('Check your email for the login link!');
        } catch (error: any) {
            alert(error.error_description || error.message);
        } finally {
            isSendingLink.value = false;
        }
    };
</script>

<template>
    <form @submit.prevent="handleLogin">
        <h1>Sign In with Magic Link</h1>
        <input
            v-model="email"
            class="input"
            type="email"
            placeholder="Your Email"
        />
        <button class="btn" :disabled="isSendingLink">
            {{ isSendingLink ? 'Sending...' : 'Send Magic Link' }}
        </button>
    </form>
</template>

<style lang="scss" scoped>
    form {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100%;
        padding: 3rem;
        width: 100%;
        h1 {
            margin-bottom: 2rem;
            font-size: 3rem;
            font-family: $title-font;
            color: #fff;
        }
        input {
            border: none;

            &:focus {
                outline: none;
            }
        }

        button {
            border: none;
        }
    }
</style>
