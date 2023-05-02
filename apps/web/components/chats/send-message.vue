<script lang="ts" setup>
    import { Message } from '@/interfaces/message.interface';

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

        const message: Message = {
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
        <VMenu location="top" open-on-hover :close-on-content-click="false">
            <template #activator="{ props }">
                <Icon
                    v-bind="props"
                    name="fluent-emoji-high-contrast:beaming-face-with-smiling-eyes"
                    class="emoji-icon"
                />
            </template>

            <EmojiPicker @emoji-click="emoji => (messageContent += emoji)" />
        </VMenu>
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

        .emoji-icon {
            height: 25px;
            width: 25px;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease-in-out;

            &:hover {
                color: $primary;
            }
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
