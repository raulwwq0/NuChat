<script lang="ts" setup>
    import { Profile } from '~~/interfaces/profile.interface';

    definePageMeta({
        middleware: ['authenticated', 'empty-profile'],
    });

    const chatId = useRoute().params.id;
    const profile = ref<Profile>(
        await useProfile().getFromChatId(chatId as string)
    );

    useSeoMeta({
        title: `NuChat | ${profile.value?.full_name || 'Chat'}`,
        description: 'Just a chat app built with Nuxt 3 and Supabase',
    });
</script>

<template>
    <NuxtLayout name="chats">
        <template #chatList>
            <ChatsList />
        </template>
        <template #messages>
            <ChatsMessages />
        </template>
    </NuxtLayout>
</template>

<style lang="scss" scoped>
    main {
        display: flex;
        flex-flow: column;
        justify-content: center;
        height: 100vh;
        width: 70%;
        background-color: $secondary;
        margin: 0 auto;
    }
</style>
