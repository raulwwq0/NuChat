<script lang="ts" setup></script>

<template>
    <main>
        <slot />
    </main>
</template>

<style lang="scss" scoped>
    main {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 100vh;

        &::after {
            content: '';
            position: absolute;
            top: 200px;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('~/assets/images/bottom-wave.svg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            z-index: -1;
        }
    }
</style>
