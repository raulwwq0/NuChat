<script lang="ts" setup>
    setTimeout(() => {
        navigateTo('/chats');
    }, 500);
</script>

<template>
    <figure class="loading">
        <img src="@/assets/images/loader.svg" alt="Loading" />
        <figcaption>Getting things ready...</figcaption>
    </figure>
</template>

<style lang="scss" scoped>
    .loading {
        width: 100%;
        height: 100vh;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;

        figcaption {
            margin-top: 1rem;
            font-size: 1.5rem;
            font-weight: 500;
        }
    }
</style>
