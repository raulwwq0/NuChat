import { v4 as uuidv4 } from 'uuid';
import { NonValidImageTypeException } from '~~/exceptions/non-valid-image-type.exception';
import { SupabaseException } from '~~/exceptions/supabase.exception';

export const useBucket = (bucket: string) => {
    const supabase = useSupabaseClient();
    const user = useSupabaseUser();
    const route = useRoute();

    const image = ref<File | null>(null);

    const isAllowedImage = (file: File) => {
        const allowedTypes = ['image/png', 'image/jpeg', 'image/jpg'];
        const allowedExtensions = ['png', 'jpeg', 'jpg'];
        return (
            allowedTypes.includes(file.type) &&
            allowedExtensions.includes(file.name.split('.').pop()!)
        );
    };

    const upload = async (file: File | string) => {
        image.value = file as File;

        if (!image.value) return;

        if (!isAllowedImage(image.value)) {
            throw new NonValidImageTypeException(
                'Invalid image type, only PNG and JPEG are allowed.'
            );
        }

        const { data, error } = await supabase.storage
            .from(bucket)
            .upload(
                `${
                    route.params.id || user.value?.id
                }/${Date.now()}-${uuidv4()}`,
                image.value
            );

        if (error) {
            throw new SupabaseException(error.message);
        }

        return data?.path ?? '';
    };

    const get = async (path: string) => {
        if (!path) return '';
        const { data, error } = await supabase.storage
            .from(bucket)
            .createSignedUrl(path, 60);

        if (error) {
            throw new SupabaseException(error.message);
        }

        return data?.signedUrl ?? '';
    };

    return {
        image,
        upload,
        get,
    };
};
