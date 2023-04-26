<script lang="ts" setup>
    import { storeToRefs } from 'pinia';
    import { useChatsStore } from '~~/stores/chats.store';

    const store = useChatsStore();
    const { chats, areChatsLoaded } = storeToRefs(store);
    const chatsProfiles = computed(() =>
        chats.value.map(chat => ({
            roomId: chat.id,
            ...chat.users![0].profile,
        }))
    );

    onMounted(async () => {
        await store.fetchAllUserChats();
        store.startChatsWatcher();
    });

    onBeforeUnmount(() => {
        store.stopChatsWatcher();
    });
</script>

<template>
    <VList v-if="!areChatsLoaded" lines="one">
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
    <Icon v-else name="svg-spinners:180-ring" />
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
            border-bottom-left-radius: 10px;
            border-bottom-right-radius: 10px;
        }
    }
</style>
