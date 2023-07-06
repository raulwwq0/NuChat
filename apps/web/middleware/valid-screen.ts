enum ScreenSize {
    WIDTH = 1820,
    HEIGHT = 1080,
}

export default defineNuxtRouteMiddleware(() => {
    const { width } = useWindowSize();
    const { isDesktop } = useDevice();

    const isValidResolutions = width.value >= ScreenSize.WIDTH;

    if (!isDesktop || !isValidResolutions) {
        return navigateTo('/non-supported-screen');
    }
});
