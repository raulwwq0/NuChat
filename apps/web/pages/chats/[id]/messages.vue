<script lang="ts" setup>
    import { Profile } from '~~/interfaces/profile.interface';

    definePageMeta({
        middleware: ['authenticated', 'empty-profile'],
        layout: 'chats',
    });

    const chatId = useRoute().params.id;
    const profile = ref<Profile>();
    const { getFromChatId } = useProfile();
    const { errorNotification } = useSwal();

    useSeoMeta({
        title: `NuChat | ${profile.value?.full_name || 'Chat'}`,
        description: 'Just a chat app built with Nuxt 3 and Supabase',
    });

    onMounted(() => {
        getFromChatId(chatId as string)
            .then(profileResponse => {
                profile.value = profileResponse!;
            })
            .catch(error => {
                errorNotification(error.message);
            });
    });
</script>

<template>
    <ChatsMessages />
</template>

<style lang="scss" scoped>
    main {
        display: flex;
        flex-flow: column;
        justify-content: center;
    }
</style>
