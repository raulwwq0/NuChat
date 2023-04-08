<script lang="ts" setup>
    import { MessageResponse } from '~~/types/response.types';

    const props = defineProps<{
        chatId: string | string[];
    }>();

    const supabase = useSupabaseClient();
    const user = useSupabaseUser();

    const userId = computed(() => user.value?.id);

    const messageContent = ref('');

    const isMessageEmpty = computed(() => messageContent.value === '');

    async function sendMessage() {
        if (isMessageEmpty.value) return;

        const message: MessageResponse = {
            chat_id: props.chatId as string,
            user_id: userId.value as string,
            content: messageContent.value,
        };

        await supabase
            .from('messages')
            .insert([message as never])
            .single();

        messageContent.value = '';
    }
</script>

<template>
    <section class="send-message">
        <input
            v-model="messageContent"
            type="text"
            placeholder="Write your message..."
            @keyup.enter="sendMessage"
        />
        <button
            @click.prevent="sendMessage"
            :class="{ disabled: isMessageEmpty }"
        >
            Send
        </button>
    </section>
</template>

<style lang="scss" scoped>
    .send-message {
        display: flex;
        flex-flow: row;
        align-items: center;
        justify-content: space-evenly;
        height: 75px;
        width: 100%;
        background-color: aqua;

        input {
            height: 50px;
            width: 80%;
            border: none;
            border-radius: 5px;
            padding: 0 10px;
            font-size: 1.2rem;
        }

        button {
            height: 50px;
            width: 10%;
            border: none;
            border-radius: 5px;
            background-color: #fff;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;

            &.disabled {
                background-color: #ccc;
                cursor: not-allowed;
            }
        }
    }
</style>
