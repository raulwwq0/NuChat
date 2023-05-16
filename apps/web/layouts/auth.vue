<script lang="ts" setup></script>

<template>
    <main>
        <section class="container">
            <article class="magic-link">
                <slot name="magic-link" />
                <img
                    src="@/assets/images/wave-haikei.svg"
                    alt="SVG"
                    class="svg"
                />
            </article>

            <article class="providers">
                <slot name="providers" />
                <img
                    src="@/assets/images/wave-haikei.svg"
                    alt="SVG"
                    class="svg"
                />
            </article>
        </section>
        <LazyClientOnly>
            <ParticlesBg />
        </LazyClientOnly>
    </main>
</template>

<style lang="scss" scoped>
    main {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 100vh;

        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
            width: 40%;
            min-height: 100vh;
            background-color: transparent;
            z-index: 2;
            pointer-events: none;

            .magic-link,
            .providers {
                background-color: $primary;
                width: 100%;
                pointer-events: all;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                position: relative;
            }

            .magic-link {
                padding-top: 2rem;
                img.svg {
                    display: inline-block;
                    width: 100%;
                    position: absolute;
                    bottom: -80%;
                    left: 0;
                    pointer-events: none;
                    z-index: -1;
                }
            }

            .providers {
                padding: 5rem 0;
                img.svg {
                    display: inline-block;
                    width: 100%;
                    position: absolute;
                    bottom: 30%;
                    left: 0;
                    pointer-events: none;
                    z-index: -1;
                    transform: rotate(180deg);
                }
            }
        }
    }
</style>
