<script lang="ts" setup>
    import { format } from 'date-fns';
    import { Message, MessageType } from '@/interfaces/message.interface';

    const config = useRuntimeConfig();
    const user = useSupabaseUser();
    const userId = user.value?.id;

    const props = defineProps<{
        message: Message;
    }>();

    const isOwnMessage = computed(() => {
        return props.message.user_id === userId;
    });

    const isTextMessage = computed(() => {
        return props.message.type === MessageType.TEXT;
    });

    const isImageMessage = computed(() => {
        return props.message.type === MessageType.IMAGE;
    });

    const dateFormatted = computed(() => {
        return format(new Date(props.message.created_at!), 'dd/MM/yyyy HH:mm');
    });
</script>

<template>
    <article :class="{ 'own-message': isOwnMessage }">
        <div v-if="isTextMessage" class="content">
            {{ props.message.content }}
        </div>
        <div v-if="isImageMessage" class="content">
            <img
                :src="`${config.public.imageBucketUrl}/${props.message.content}`"
                alt="image"
            />
        </div>
        <div class="date">{{ dateFormatted }}</div>
    </article>
</template>

<style lang="scss" scoped>
    article {
        display: flex;
        flex-flow: column;
        align-items: flex-end;
        padding: 10px;
        background-color: $secondary;
        color: #fff;
        border-radius: 10px;
        align-self: flex-start;
        max-width: 50%;
        width: auto;
        margin: 10px;

        .content {
            font-size: 1.2rem;

            img {
                max-width: 100%;
                height: auto;
            }
        }

        .date {
            font-size: 0.8rem;
            margin-top: 5px;
        }

        &.own-message {
            align-self: flex-end;
            background-color: $primary;
            color: #fff;
        }
    }
</style>
