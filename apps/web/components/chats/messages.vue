<script lang="ts" setup>
    import { Message } from '@/interfaces/message.interface';
    import { Profile } from '~~/interfaces/profile.interface';

    const supabase = useSupabaseClient();

    const chatId = useRoute().params.id;
    const messages = ref<Message[]>([]);
    const messagesWatcher = ref();
    const messageList = ref<HTMLElement>();
    const { y: messageListVerticalScrollPosition } = useScroll(messageList);
    const profile = ref<Profile>(
        await useProfile().getFromChatId(chatId as string)
    );

    function getMessages() {
        return supabase
            .from('messages')
            .select('*')
            .eq('chat_id', chatId)
            .order('created_at', { ascending: true });
    }

    async function updateMessages() {
        const { data: messagesResponse } = await getMessages();
        messages.value = messagesResponse!;
    }

    function scrollToBottom() {
        messageListVerticalScrollPosition.value =
            messageList.value!.scrollHeight;
    }

    const isAtBottom = computed(() => {
        if (!messageList.value) return false;
        return (
            messageListVerticalScrollPosition.value +
                messageList.value.offsetHeight ===
            messageList.value.scrollHeight
        );
    });

    onMounted(async () => {
        messagesWatcher.value = supabase
            .channel('messages-channel')
            .on(
                'postgres_changes',
                { event: '*', schema: 'public', table: 'messages' },
                () => {
                    updateMessages().then(() => {
                        if (isAtBottom.value) scrollToBottom();
                    });
                }
            )
            .subscribe();
        await updateMessages();
        scrollToBottom();
    });

    onBeforeUnmount(() => {
        messagesWatcher.value!.unsubscribe();
    });
</script>

<template>
    <header>
        <img :src="profile.avatar_url" :alt="profile.full_name" />
        <h1>{{ profile.full_name }}</h1>
    </header>
    <section ref="messageList">
        <ChatsMessage
            v-for="message in messages"
            :key="message.id"
            :message="message"
        />
        <span v-if="!messages.length">No messages</span>
        <button v-if="!isAtBottom" class="down-button" @click="scrollToBottom">
            <img
                src="@/assets/images/scroll-down-arrow.svg"
                alt="Scroll down arrow"
            />
            <VTooltip activator="parent" location="left">Scroll down</VTooltip>
        </button>
    </section>
    <ChatsSendMessage :chat-id="chatId" />
</template>

<style lang="scss" scoped>
    header {
        font-size: 1.5rem;
        font-weight: 600;
        height: 60px;
        background-color: $primary;
        width: 100%;
        border-radius: 10px;
        border-bottom-left-radius: 0px;
        border-bottom-right-radius: 0px;
        display: flex;
        align-items: center;

        h1 {
            margin: 0;
            padding: 10px;
            color: #fff;
        }

        img {
            width: 60px;
            height: 60px;
            border-top-left-radius: 10px;
            margin-right: 10px;
        }
    }

    section {
        display: flex;
        flex-flow: column;
        align-items: center;
        height: 100%;
        width: 100%;
        background-color: #fff;
        overflow-y: scroll;

        .down-button {
            position: fixed;
            bottom: 0;
            right: 0;
            margin: 20px;
            padding: 5px;
            background-color: #000;
            color: #fff;
            border-radius: 9999px;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;

            img {
                width: 30px;
                height: 30px;
            }
        }
    }
</style>
