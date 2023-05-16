export default defineNuxtRouteMiddleware(() => {
    const { isAdmin } = useProfileStore();

    if (!isAdmin()) {
        return navigateTo('/chats');
    }
});
