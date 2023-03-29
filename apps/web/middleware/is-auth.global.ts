const notAuthenticatedRoutes = [
    '/', 
    '/auth/sign-in',
    '/auth/processing',
];

export default defineNuxtRouteMiddleware((to, from) => {
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
})
