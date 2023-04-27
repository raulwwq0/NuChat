<script lang="ts" setup>
    preloadRouteComponents('/chats');
    setTimeout(() => {
        navigateTo('/chats');
    }, 500);
</script>

<template>
    <figure class="loading">
        <img
            src="@/assets/images/SvgSpinnersPulseRings3.svg"
            alt="Loading"
            class="loading-icon"
        />
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

        .loading-icon {
            width: 150px;
            height: 150px;
        }

        figcaption {
            margin-top: 2rem;
            font-size: 1.5rem;
            font-weight: 500;
        }
    }
</style>
