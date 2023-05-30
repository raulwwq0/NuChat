<script lang="ts" setup>
    definePageMeta({
        middleware: ['already-authenticated'],
    });

    useServerSeoMeta({
        title: 'NuChat | Sign In',
        description: 'Just a chat app built with Nuxt 3 and Supabase',
    });
</script>

<template>
    <NuxtLayout name="auth">
        <template #magic-link>
            <AuthFormSignIn />
        </template>
        <template #providers>
            <h1>Or using these OAuth providers</h1>
            <AuthProvider provider="github" icon="bi:github" />
        </template>
    </NuxtLayout>
</template>

<style lang="scss" scoped>
    h1 {
        margin-bottom: 2rem;
        font-size: 2rem;
        font-family: $body-font;
        color: #fff;
    }
</style>
