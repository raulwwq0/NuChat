<script lang="ts" setup>
const supabase = useSupabaseClient();
const loading = ref(false);
const email = ref("");
const handleLogin = async () => {
    try {
        loading.value = true;
        const { error } = await supabase.auth.signInWithOtp({
            email: email.value,
            options: {
                emailRedirectTo: "http://localhost:3000/auth/processing",
            },
        });
        if (error) throw error;
        alert("Check your email for the login link!");
    } catch (error: any) {
        alert(error.error_description || error.message);
    } finally {
        loading.value = false;
    }
};
</script>

<template>
    <form @submit.prevent="handleLogin">
        <h1>Register</h1>
        <input type="email" placeholder="Email" v-model="email" />
        <input
            type="submit"
            class="button block"
            :value="loading ? 'Loading' : 'Send magic link'"
            :disabled="loading"
        />
    </form>
</template>

<style scoped></style>
