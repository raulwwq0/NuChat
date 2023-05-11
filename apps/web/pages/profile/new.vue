<script setup lang="ts">
    useServerSeoMeta({
        title: 'NuChat | Complete your profile',
        description: 'Create a new profile',
    });
</script>

<template>
    <AuthFormProfile
        title="Complete your profile before start chatting"
        @saved="() => navigateTo('/chats')"
    />
</template>
