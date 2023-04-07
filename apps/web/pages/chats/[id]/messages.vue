<script lang="ts" setup>
    definePageMeta({
        middleware: ['empty-profile'],
    })
</script>

<template>
    <NuxtLayout name="chats">
        <template #chatList>
            <ChatsList />
        </template>
        <template #messages>
            <ChatsMessages />
        </template>
    </NuxtLayout>
</template>

<style lang="scss" scoped>
    main {
        display: flex;
        flex-flow: column;
        justify-content: center;
        height: 100vh;
        width: 70%;
        background-color: $secondary;
        margin: 0 auto;
    }
</style>
