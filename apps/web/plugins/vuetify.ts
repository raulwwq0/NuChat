import { createVuetify } from 'vuetify';
import { VDataTable } from 'vuetify/labs/VDataTable';
import { aliases, mdi } from 'vuetify/lib/iconsets/mdi-svg';

export default defineNuxtPlugin(nuxtApp => {
    const vuetify = createVuetify({
        ssr: true,
        components: {
            VDataTable,
        },
        icons: {
            defaultSet: 'mdi',
            aliases,
            sets: {
                mdi,
            },
        },
    });

    nuxtApp.vueApp.use(vuetify);
});
