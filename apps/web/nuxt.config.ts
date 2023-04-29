import vuetify from 'vite-plugin-vuetify';

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
        [
            '@vee-validate/nuxt',
            {
                autoImports: true,
                componentNames: {
                    Form: 'VeeForm',
                    Field: 'VeeField',
                    FieldArray: 'VeeFieldArray',
                    ErrorMessage: 'VeeErrorMessage',
                },
            },
        ],
        'nuxt-icon',
        (_, nuxt) => {
            nuxt.hooks.hook('vite:extendConfig', config =>
                // @ts-ignore
                config.plugins.push(vuetify())
            );
        },
    ],
    runtimeConfig: {
        public: {
            baseUrl: process.env.BASE_URL,
        },
    },
    css: ['@/assets/style/main.scss'],
    vite: {
        ssr: {
            noExternal: ['vuetify'],
        },
        css: {
            preprocessorOptions: {
                scss: {
                    additionalData: `
                    @import "~/assets/style/00-variables/_colors.scss";
                    @import "~/assets/style/00-variables/_fonts.scss";
                    `,
                },
            },
        },
    },
});
