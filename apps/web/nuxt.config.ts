// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    modules: [
        '@nuxtjs/supabase',
        '@vueuse/nuxt',
        [
            '@pinia/nuxt',
            {
                autoImports: ['defineStore'],
            },
        ],
    ],
    build: {
        transpile: ['vuetify'],
    },
    css: ['@/assets/style/main.scss'],
    vite: {
        css: {
            preprocessorOptions: {
                scss: {
                    additionalData: `
                        @import "~/assets/style/00-variables/_fonts.scss";
                        @import "~/assets/style/00-variables/_colors.scss";
                    `,
                },
            },
        },
    },
});
