<script lang="ts" setup>
    import { storeToRefs } from 'pinia';
    import { useChatsStore } from '~~/stores/chats.store';

    const store = useChatsStore();
    const { chats, areChatsLoaded } = storeToRefs(store);

    onMounted(async () => {
        await store.fetchAllUserChats();
    });
</script>

<template>
    <section v-if="!areChatsLoaded">
        <NuxtLink
            v-for="chat in chats"
            :key="chat.id"
            :to="`/chats/${chat.id}/messages`"
        >
            <ChatsCard :profile="chat.users[0].profile" />
        </NuxtLink>
    </section>
    <span v-else>Loading...</span>
</template>

<style lang="scss" scoped>
    aside {
        display: flex;
        flex-flow: column;
        align-items: center;
        height: 100vh;
        width: 30%;
        background-color: $primary;

        section {
            display: flex;
            flex-flow: column;
            align-items: center;
            width: 100%;
            height: 100%;
            overflow-y: scroll;
        }
    }
</style>
