<script lang="ts" setup>
    const route = useRoute();

    const newChatDialog = ref(false);
</script>

<template>
    <main>
        <aside>
            <ChatsDropdownMenu @open-dialog="newChatDialog = true" />
            <ChatsList />
        </aside>
        <section class="messages">
            <slot />
            <ChatsDragDropUploadImage v-if="route.params.id" />
        </section>
        <VDialog v-model="newChatDialog" class="dialog">
            <ChatsFindNew @close="newChatDialog = false" />
        </VDialog>
        <LazyClientOnly>
            <ParticlesBg />
        </LazyClientOnly>
    </main>
</template>

<style lang="scss" scoped>
    main {
        display: flex;
        flex-flow: row;
        justify-content: space-between;
        align-items: center;
        height: 100vh;
        width: 70%;
        margin: 0 auto;

        aside {
            display: flex;
            flex-flow: column;
            align-items: center;
            height: 95%;
            width: 30%;
            border: 1px solid $primary;
            border-radius: 10px;
            z-index: 100;
            background-color: #fff;
        }

        section {
            display: flex;
            flex-flow: column;
            align-items: center;
            height: 95%;
            width: 67%;
            border: 1px solid $primary;
            border-radius: 10px;
            position: relative;
            background-color: #fff;
            z-index: 1;
        }
    }
</style>
