<script lang="ts" setup>
    useServerSeoMeta({
        title: 'NuChat | Home',
        description: 'Just a chat app built with Nuxt 3 and Supabase',
    });
</script>

<template>
    <main class="container">
        <section class="banner">
            <div class="wrapper">
                <main class="intro">
                    <h1>NuChat</h1>
                    <h2>Just a chat app built with Nuxt 3 and Supabase</h2>
                    <NuxtLink to="/auth/sign-in" class="btn"
                        >Let's begin!</NuxtLink
                    >
                </main>
                <figure>
                    <img
                        src="@/assets/images/logo.png"
                        alt="NuChat Logo"
                        width="300"
                        height="300"
                    />
                </figure>
            </div>
            <img src="@/assets/images/wave-haikei.svg" alt="SVG" class="svg" />
        </section>
        <footer>
            <span
                >Built by
                <a href="https://github.com/raulwwq0">Raúl Aguilar</a> under
                <a
                    href="https://github.com/politecnicoDAW-2022/2022-2023---proyecto-integrado-raulwwq0/blob/main/LICENSE"
                    >MIT License</a
                ></span
            >
        </footer>
        <LazyClientOnly>
            <ParticlesBg />
        </LazyClientOnly>
    </main>
</template>

<style lang="scss" scoped>
    main.container {
        width: 100%;
        height: 100vh;
        display: flex;
        flex-direction: column;
        justify-content: flex-start;
        align-items: center;

        .banner {
            display: flex;
            flex-flow: column;
            justify-content: center;
            align-items: center;
            background-color: transparent;
            z-index: 1;
            width: 100%;
            height: 50vh;
            position: relative;
            pointer-events: none;

            img.svg {
                display: inline-block;
                width: 100%;
                position: absolute;
                top: -30px;
                left: 0;
                pointer-events: none;
            }

            .wrapper {
                display: flex;
                flex-flow: row;
                justify-content: space-between;
                align-items: center;
                width: 70%;
                z-index: 2;
                main.intro {
                    display: flex;
                    flex-flow: column;
                    pointer-events: all;
                    color: #fff;

                    h1 {
                        font-size: 6rem;
                        font-weight: 700;
                    }

                    h2 {
                        margin-top: 3rem;
                        font-size: 1.7rem;
                        font-weight: 500;
                    }
                }

                figure {
                    margin-top: 5rem;
                    img {
                        max-width: 300px;
                    }
                }
            }
        }

        footer {
            margin-top: 2rem;
            font-size: 1.5rem;
            font-weight: 500;
            color: #ccc;
            position: absolute;
            bottom: 10px;

            a {
                color: #999;
                text-decoration: none;
            }
        }
    }
</style>
