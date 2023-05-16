<script lang="ts" setup>
    import { storeToRefs } from 'pinia';
    import { useProfileStore } from '~~/stores/profile.store';

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
