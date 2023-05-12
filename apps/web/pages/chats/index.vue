<script lang="ts" setup>
    definePageMeta({
        middleware: ['authenticated', 'empty-profile'],
    });
    useSeoMeta({
        title: 'NuChat | Chats',
        description: 'Just a chat app built with Nuxt 3 and Supabase',
    });
    await preloadComponents('ChatsList');
</script>

<template>
    <NuxtLayout name="chats">
        <template #chatList>
            <ChatsList />
        </template>
        <template #messages>
            <section class="welcome">
                <h1>Welcome to NuChat</h1>
                <h2>Just a chat app built with Nuxt 3 and Supabase</h2>
            </section>
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

        .welcome {
            display: flex;
            flex-flow: column;
            justify-content: center;
            align-items: center;
            height: 100%;
            width: 70%;

            h1 {
                font-size: 3rem;
                font-weight: 700;
                color: $primary;
                text-align: center;
                margin-bottom: 1rem;
            }

            h2 {
                font-size: 1.5rem;
                font-weight: 500;
                color: #ccc;
                text-align: center;
                width: 50%;
            }
        }
    }
</style>
