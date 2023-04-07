<script lang="ts" setup>
    import { MessageResponse } from '~/types/response.types'

    const supabase = useSupabaseClient()

    const chatId = useRoute().params.id
    const messages = ref<MessageResponse[]>([])
    const messagesWatcher = ref()

    async function getMessages() {
        return await supabase
            .from('messages')
            .select('*')
            .eq('chat_id', chatId)
            .order('created_at', { ascending: true })
    }

    async function updateMessages() {
        const { data: messagesResponse } = await getMessages()
        messages.value = messagesResponse!
    }

    onMounted(async () => {
        await updateMessages()

        messagesWatcher.value = supabase
            .channel('custom-all-channel')
            .on(
                'postgres_changes',
                { event: '*', schema: 'public', table: 'messages' },
                async () => {
                    await updateMessages()
                }
            )
            .subscribe()
    })

    onUnmounted(() => {
        messagesWatcher.value.unsubscribe()
    })
</script>

<template>
    <header>Component: chats/messages {{ chatId }}</header>
    <section>
        <ChatsMessage
            v-for="message in messages"
            :key="message.id"
            :message="message"
        />
    </section>
    <ChatsSendMessage :chat-id="chatId" />
</template>

<style scoped>
    header {
        font-size: 1.5rem;
        font-weight: 600;
        height: 50px;
        background-color: #fff;
        width: 100%;
    }

    section {
        display: flex;
        flex-flow: column;
        align-items: center;
        height: 100%;
        width: 100%;
        background-color: antiquewhite;
    }
</style>
