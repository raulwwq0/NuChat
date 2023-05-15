<script setup lang="ts">
    const { upload } = useBucket('chats');
    const { errorNotification } = useSwal();

    const emit = defineEmits<{
        (e: 'image-uploaded', path: string): void;
    }>();

    const image = ref<File | null>(null);

    const uploadImage = (e: Event) => {
        image.value = (e.target as HTMLInputElement).files?.[0] ?? null;
        if (!image.value) return;

        upload(image.value)
            .then(path => {
                emit('image-uploaded', path ?? '');
            })
            .catch(error => {
                errorNotification(error.message);
            });
    };
</script>

<template>
    <div>
        <label for="fileInput">
            <Icon
                name="material-symbols:image-outline-rounded"
                class="send-message-emoji-icon"
            />
        </label>
        <input
            id="fileInput"
            type="file"
            name="fileInput"
            accept="image/*"
            @change="uploadImage"
        />
    </div>
</template>

<style lang="scss" scoped>
    input[type='file'] {
        display: none;
    }
</style>
