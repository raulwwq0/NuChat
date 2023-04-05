<script lang="ts" setup>
    const supabase = useSupabaseClient()
    const isSendingLink = ref(false)
    const email = ref('')
    const handleLogin = async () => {
        try {
            isSendingLink.value = true
            const { error } = await supabase.auth.signInWithOtp({
                email: email.value,
                options: {
                    emailRedirectTo: 'http://localhost:3000/auth/processing',
                },
            })
            if (error) throw error
            alert('Check your email for the login link!')
        } catch (error: any) {
            alert(error.error_description || error.message)
        } finally {
            isSendingLink.value = false
        }
    }
</script>

<template>
    <form @submit.prevent="handleLogin">
        <h1>Sign In</h1>
        <input v-model="email" type="email" placeholder="Your Email" />
        <input
            type="submit"
            class="button"
            :value="isSendingLink ? 'Sending...' : 'Send Magic Link'"
            :disabled="isSendingLink"
        />
    </form>
</template>

<style lang="scss" scoped>
    form {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100%;
        background-color: #fefefe;
        padding: 3rem;
        width: 30%;
        background: rgba(255, 255, 255, 0.25);
        box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        backdrop-filter: blur(13px);
        h1 {
            margin-bottom: 2rem;
            font-size: 2rem;
            font-family: $title-font;
        }
        input {
            width: 100%;
            max-width: 500px;
            padding: 0.5rem;
            margin-bottom: 1rem;
            border: 1px solid #ccc;
            border-radius: 4px;

            &.button {
                background-color: #333;
                color: #fff;
                border: none;
                cursor: pointer;
            }
        }
    }
</style>
