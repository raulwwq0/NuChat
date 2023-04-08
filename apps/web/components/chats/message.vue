<script lang="ts" setup>
    import { format } from 'date-fns';
    import { MessageResponse } from '~/types/response.types';

    const user = useSupabaseUser();
    const userId = user.value?.id;

    const props = defineProps<{
        message: MessageResponse;
    }>();

    const isOwnMessage = computed(() => {
        return props.message.user_id === userId;
    });

    const dateFormatted = computed(() => {
        return format(new Date(props.message.created_at!), 'dd/MM/yyyy HH:mm');
    });
</script>

<template>
    <article :class="{ 'own-message': isOwnMessage }">
        <div>{{ props.message.content }}</div>
        <div>{{ dateFormatted }}</div>
    </article>
</template>

<style lang="scss" scoped>
    article {
        display: flex;
        flex-flow: column;
        align-items: flex-end;
        padding: 10px;
        background-color: #000;
        color: #fff;
        border-radius: 10px;
        align-self: flex-start;
        max-width: 30%;
        width: auto;
        margin: 10px;

        &.own-message {
            align-self: flex-end;
            background-color: #fff;
            color: #000;
        }
    }
</style>
