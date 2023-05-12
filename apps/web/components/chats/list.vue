<script lang="ts" setup>
    import { storeToRefs } from 'pinia';
    import { useChatsStore } from '~~/stores/chats.store';

    const store = useChatsStore();
    const { chats, areChatsEmpty, areChatsLoading } = storeToRefs(store);
    const { ifNeeded } = useDefaultAvatar();

    const chatsProfilesWithRoomId = () =>
        chats.value.map((chat: any) => ({
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
    <div v-if="areChatsLoading" class="loading">
        <img src="@/assets/images/SvgSpinnersPulseRings3.svg" alt="Loading" />
    </div>
    <VList v-else-if="!areChatsEmpty" lines="one">
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
    <div v-else class="no-chats-found-message">
        <Icon name="material-symbols:arrow-upward-rounded" class="icon" />
        <h3>No chats found</h3>
        <span
            >Start a new chat or search for existing ones in the upper
            menu</span
        >
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

        .no-chats-found-message {
            display: flex;
            flex-flow: column;
            justify-content: start;
            align-items: center;
            height: 90%;
            width: 100%;
            padding-top: 3rem;

            .icon {
                font-size: 5rem;
            }

            h3 {
                font-size: 2rem;
                font-weight: 600;
                margin: 0.5rem 0;
            }

            span {
                font-size: 1.5rem;
                font-weight: 500;
                color: #ccc;
                text-align: center;
            }
        }
    }
</style>
