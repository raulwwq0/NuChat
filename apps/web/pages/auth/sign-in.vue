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
        <AuthFormSignIn />
        <AuthProvider provider="github" icon="bi:github" />
    </NuxtLayout>
</template>
