import Particles from 'particles.vue3';

export default defineNuxtPlugin(nuxtApp => {
    // @ts-ignore
    nuxtApp.vueApp.use(Particles);
});
