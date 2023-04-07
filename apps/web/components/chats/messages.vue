<script lang="ts" setup>
    import { MessageResponse } from '~/types/response.types'

    const supabase = useSupabaseClient()

    const chatId = useRoute().params.id
    const messages = ref<MessageResponse[]>([])

    async function getMessages() {
        return await supabase
            .from('messages')
            .select('*')
            .eq('chat_id', chatId)
            .order('created_at', { ascending: true })
    }

    onMounted(async () => {
        const { data: messagesResponse } = await getMessages()
        messages.value = messagesResponse!
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
