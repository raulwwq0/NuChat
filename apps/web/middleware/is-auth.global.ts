const notAuthenticatedRoutes = [
    '/',
    '/auth/sign-in',
    '/auth/processing',
    '/profile/new',
];

export default defineNuxtRouteMiddleware(to => {
    // if the route not exists (404)
    if (!to.matched.length) {
        return;
    }

    if (notAuthenticatedRoutes.includes(to.path)) {
        return;
    }

    const user = useSupabaseUser();

    if (!user.value) {
        return '/auth/sign-in';
    }
});
