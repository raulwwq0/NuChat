<script lang="ts" setup>
    import { storeToRefs } from 'pinia';
    import { useChatsStore } from '~~/stores/chats.store';

    const store = useChatsStore();
    const { chats, areChatsLoaded } = storeToRefs(store);
    const { ifNeeded } = useDefaultAvatar();

    const chatsProfilesWithRoomId = () =>
        chats.value.map(chat => ({
            roomId: chat.id,
            ...chat.users![0].profile,
        }));

    const chatsProfiles = ref<any[]>([]);

    onMounted(() => {
        store.fetchAllUserChats().then(() => {
            chatsProfiles.value = chatsProfilesWithRoomId();
            for (const chat of chatsProfiles.value) {
                useBucket('avatars')
                    .get(chat.avatar)
                    .then(url => (chat.avatar = url));
            }
        });

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
            :prepend-avatar="ifNeeded(chat.avatar)"
            @click="() => navigateTo(`/chats/${chat.roomId}/messages`)"
        >
            <VDivider />
        </VListItem>
    </VList>
    <div v-else>
        <img src="@/assets/images/SvgSpinnersPulseRings3.svg" alt="Loading" />
    </div>
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
            height: 90%;
            overflow-y: scroll;
            border-bottom-left-radius: 10px;
            border-bottom-right-radius: 10px;
        }

        img {
            width: 100px;
            height: 100px;
            margin-top: 20px;
        }
    }
</style>
