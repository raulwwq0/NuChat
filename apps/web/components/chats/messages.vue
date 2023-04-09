<script lang="ts" setup>
    import { MessageResponse } from '~/types/response.types';

    const supabase = useSupabaseClient();

    const chatId = useRoute().params.id;
    const messages = ref<MessageResponse[]>([]);
    const messagesWatcher = ref();
    const messageList = ref<HTMLElement>();
    const { y: messageListVerticalScrollPosition } = useScroll(messageList);

    async function getMessages() {
        return await supabase
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
        await updateMessages();
        scrollToBottom();

        messagesWatcher.value = supabase
            .channel('custom-all-channel')
            .on(
                'postgres_changes',
                { event: '*', schema: 'public', table: 'messages' },
                async () => {
                    await updateMessages();
                    if (!isAtBottom.value) return;
                    scrollToBottom();
                }
            )
            .subscribe();
    });

    onUnmounted(() => {
        messagesWatcher.value.unsubscribe();
    });
</script>

<template>
    <header>
        <h1>Chat: {{ chatId }}</h1>
    </header>
    <section ref="messageList">
        <ChatsMessage
            v-for="message in messages"
            :key="message.id"
            :message="message"
        />
        <span v-if="!messages.length">No messages</span>
        <button v-if="!isAtBottom" class="down-button" @click="scrollToBottom">
            Scroll to bottom
        </button>
    </section>
    <ChatsSendMessage :chat-id="chatId" />
</template>

<style lang="scss" scoped>
    header {
        font-size: 1.5rem;
        font-weight: 600;
        height: 50px;
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
            margin: 10px;
            padding: 10px;
            background-color: #000;
            color: #fff;
            border-radius: 10px;
            border: none;
            cursor: pointer;
        }
    }
</style>
