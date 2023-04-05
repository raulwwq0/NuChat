<script lang="ts" setup>
    definePageMeta({
        middleware: ['empty-profile'],
    })
</script>

<template>
    <main>
        <ChatsList />
    </main>
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
