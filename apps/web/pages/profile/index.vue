<script lang="ts" setup>
    definePageMeta({
        middleware: ['empty-profile', 'authenticated'],
    });

    useServerSeoMeta({
        title: 'NuChat | Your profile',
        description: 'Your profile',
    });

    const { profile } = storeToRefs(useProfileStore());
</script>

<template>
    <AuthFormProfile
        title="Your profile"
        :profile="profile"
        @saved="() => navigateTo('/chats')"
    />
</template>
