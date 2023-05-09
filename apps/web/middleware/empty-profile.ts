import { useProfileStore } from '~~/stores/profile.store';

export default defineNuxtRouteMiddleware(async () => {
    const { fetch } = useProfileStore();
    await fetch();
    const profile = useProfileStore().profile!;

    if (!profile.username || !profile.full_name) {
        return navigateTo('/profile/new');
    }
});
