<script lang="ts" setup>
    import { Message, MessageType } from '@/interfaces/message.interface';

    const props = defineProps<{
        chatId: string | string[];
    }>();

    const emit = defineEmits<{
        (e: 'message-sent'): void;
    }>();

    const supabase = useSupabaseClient();
    const user = useSupabaseUser();

    const userId = computed(() => user.value?.id);

    const messageContent = ref('');

    const isMessageEmpty = computed(() => messageContent.value === '');

    async function sendMessage() {
        if (isMessageEmpty.value) return;

        const message: Message = {
            chat_id: props.chatId as string,
            user_id: userId.value as string,
            content: messageContent.value,
            type: MessageType.TEXT,
        };

        await supabase
            .from('messages')
            .insert([message as never])
            .single();

        messageContent.value = '';
        useChat()
            .updateLastMessageAt(props.chatId as string)
            .then(() => {
                emit('message-sent');
            });
    }

    const sendImage = (path: string) => {
        useMessages(props.chatId as string)
            .sendImage(path)
            .then(() => {
                useChat()
                    .updateLastMessageAt(props.chatId as string)
                    .then(() => {
                        emit('message-sent');
                    });
            });
    };
</script>

<template>
    <section class="send-message">
        <input
            v-model="messageContent"
            type="text"
            placeholder="Write your message..."
            @keyup.enter="sendMessage"
        />
        <VMenu location="top" open-on-hover :close-on-content-click="false">
            <template #activator="{ props }">
                <Icon
                    v-bind="props"
                    name="uil:smile"
                    class="send-message-emoji-icon"
                />
            </template>

            <ChatsEmojiPicker
                @emoji-click="emoji => (messageContent += emoji)"
            />
        </VMenu>
        <ChatsUploadImage @image-uploaded="sendImage" />
        <button
            :class="{ disabled: isMessageEmpty }"
            @click.prevent="sendMessage"
        >
            <Icon
                v-if="isMessageEmpty"
                name="ic:baseline-cancel-schedule-send"
            />
            <Icon v-else name="ic:baseline-send" />
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
        //background-color: aqua;
        border-top: 1px solid #ccc;
        border-bottom-left-radius: 10px;
        border-bottom-right-radius: 10px;

        input {
            height: 50px;
            width: 80%;
            border: none;
            border-radius: 5px;
            padding: 0 10px;
            font-size: 1.2rem;
        }

        input:focus {
            outline: none;
            caret-color: $primary;
        }

        button {
            height: 50px;
            width: 10%;
            border: none;
            border-radius: 5px;
            background-color: $primary;
            color: #fff;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;

            &.disabled {
                background-color: #ccc;
                color: #000;
                cursor: not-allowed;
            }
        }
    }
</style>
