enum ScreenSize {
    WIDTH = 1820,
    HEIGHT = 1080,
}

export default defineNuxtRouteMiddleware(() => {
    const { width } = useWindowSize();

    const isValidResolutions = width.value >= ScreenSize.WIDTH;

    if (!isValidResolutions) {
        return navigateTo('/non-supported-screen');
    }
});
