<script lang="ts" setup>
    import { Profile } from '~~/interfaces/profile.interface';

    definePageMeta({
        middleware: ['empty-profile', 'authenticated'],
    });

    useServerSeoMeta({
        title: 'NuChat | Your profile',
        description: 'Your profile',
    });

    const user = useSupabaseUser();
    const profile = ref<Profile>(
        await useProfile().fetchProfile(user.value?.id || '')
    );
</script>

<template>
    <AuthFormProfile title="Your profile" :profile="profile" />
</template>
