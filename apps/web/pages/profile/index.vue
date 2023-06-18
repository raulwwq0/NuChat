<script lang="ts" setup>
    definePageMeta({
        middleware: ['empty-profile', 'authenticated', 'valid-screen'],
    });

    useServerSeoMeta({
        title: 'NuChat | Your profile',
        description: 'Your profile',
    });

    const { profile } = storeToRefs(useProfileStore());
</script>

<template>
    <main>
        <AuthFormProfile
            title="Your profile"
            :profile="profile"
            @saved="() => navigateTo('/chats')"
        />
        <LazyClientOnly>
            <ParticlesBg />
        </LazyClientOnly>
    </main>
</template>
