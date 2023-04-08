<script lang="ts" setup>
    import { storeToRefs } from 'pinia';
    import { useChatsStore } from '~~/stores/chats.store';

    const store = useChatsStore();
    const { chats, areChatsLoaded } = storeToRefs(store);
    const chatsProfiles = computed(() =>
        chats.value.map(chat => ({
            roomId: chat.id,
            ...chat.users[0].profile,
        }))
    );

    onMounted(async () => {
        await store.fetchAllUserChats();
    });
</script>

<template>
    <VList lines="one" v-if="!areChatsLoaded">
        <VListItem
            v-for="chat in chatsProfiles"
            :key="chat.id"
            :title="chat.full_name"
            :subtitle="`@${chat.username}`"
            :prepend-avatar="chat.avatar_url"
            @click="() => navigateTo(`/chats/${chat.roomId}/messages`)"
        >
            <VDivider />
        </VListItem>
    </VList>
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

        .v-list {
            width: 100%;
            height: 100%;
            overflow-y: scroll;
        }
    }
</style>
