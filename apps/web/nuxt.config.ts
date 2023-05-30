import vuetify from 'vite-plugin-vuetify';

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    imports: {
        dirs: ['stores'],
    },
    modules: [
        '@nuxtjs/supabase',
        '@nuxtjs/robots',
        '@nuxtjs/fontaine',
        '@vueuse/nuxt',
        [
            '@pinia/nuxt',
            {
                autoImports: ['defineStore', 'storeToRefs'],
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
        'nuxt-security',
        'nuxt-icon',
        (_, nuxt) => {
            nuxt.hooks.hook('vite:extendConfig', config =>
                // @ts-ignore
                config.plugins.push(vuetify())
            );
        },
    ],
    nitro: {
        compressPublicAssets: true,
    },
    plugins: ['~/plugins/particles'],
    runtimeConfig: {
        public: {
            baseUrl: process.env.BASE_URL,
        },
    },
    css: ['@/assets/style/reset.scss'],
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
                    @import "~/assets/style/01-components/_buttons.scss";
                    @import "~/assets/style/01-components/_text-inputs.scss";
                    @import "~/assets/style/main.scss";
                    `,
                },
            },
        },
    },
    security: {
        headers: {
            crossOriginEmbedderPolicy: 'unsafe-none',
            contentSecurityPolicy: {
                'img-src': ["'self'", 'data:', process.env.SUPABASE_URL!],
            },
        },
    },
});
