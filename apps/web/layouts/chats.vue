<script lang="ts" setup></script>

<template>
    <main>
        <aside>
            <AuthLogout />
            <slot name="chatList" />
        </aside>
        <section>
            <slot name="messages" />
        </section>
    </main>
</template>

<style lang="scss" scoped>
    main {
        display: flex;
        flex-flow: row;
        height: 100vh;
        width: 70%;
        margin: 0 auto;
        background-color: antiquewhite;

        aside {
            display: flex;
            flex-flow: column;
            align-items: center;
            height: 100%;
            width: 30%;
            background-color: aliceblue;
        }
    }
</style>
