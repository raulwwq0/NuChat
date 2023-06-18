<script setup lang="ts">
    useServerSeoMeta({
        title: 'NuChat | Complete your profile',
        description: 'Create a new profile',
    });
    definePageMeta({
        middleware: ['valid-screen'],
    });
</script>

<template>
    <main>
        <AuthFormProfile
            title="Complete your profile before start chatting"
            @saved="() => navigateTo('/chats')"
        />
        <LazyClientOnly>
            <ParticlesBg />
        </LazyClientOnly>
    </main>
</template>
