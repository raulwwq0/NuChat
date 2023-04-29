<script lang="ts" setup>
    useServerSeoMeta({
        title: 'NuChat | Sign In',
        description: 'Just a chat app built with Nuxt 3 and Supabase',
    });
</script>

<template>
    <NuxtLayout name="auth">
        <AuthFormSignIn />
    </NuxtLayout>
</template>
