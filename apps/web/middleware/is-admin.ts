import { useProfileStore } from '~~/stores/profile.store';

export default defineNuxtRouteMiddleware(() => {
    const { isAdmin } = useProfileStore();

    if (!isAdmin()) {
        return navigateTo('/chats');
    }
});
