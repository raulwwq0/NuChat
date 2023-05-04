export const useDefaultAvatar = () => {
    const config = useRuntimeConfig();

    const ifNeeded = (url: string) => {
        try {
            // eslint-disable-next-line no-new
            new URL(url);
            return url;
        } catch (_) {
            return new URL('/default-avatar.jpg', config.baseUrl).href;
        }
    };

    return {
        ifNeeded,
    };
};
