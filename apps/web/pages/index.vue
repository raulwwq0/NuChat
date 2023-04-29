<script lang="ts" setup>
    useServerSeoMeta({
        title: 'NuChat | Home',
        description: 'Just a chat app built with Nuxt 3 and Supabase',
    });
</script>

<template>
    <main>
        <h1>NuChat</h1>
        <h2>Just a chat app built with Nuxt 3 and Supabase</h2>
        <NuxtLink to="/auth/sign-in" class="btn">Let's begin!</NuxtLink>
    </main>
</template>

<style lang="scss" scoped>
    main {
        width: 100%;
        height: 100vh;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;

        h1 {
            font-size: 3rem;
            font-weight: 700;
        }

        h2 {
            margin-top: 1rem;
            font-size: 1.5rem;
            font-weight: 500;
        }

        .btn {
            margin-top: 2rem;
            padding: 1rem 2rem;
            border-radius: 0.5rem;
            background-color: #000;
            color: #fff;
            font-size: 1.5rem;
            font-weight: 500;
            text-decoration: none;
        }
    }
</style>
