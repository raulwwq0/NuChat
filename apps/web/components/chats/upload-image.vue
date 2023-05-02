<script setup lang="ts">
    const supabase = useSupabaseClient();
    const route = useRoute();

    const emit = defineEmits<{
        (e: 'image-uploaded', path: string): void;
    }>();

    const image = ref<File | null>(null);

    const uploadImage = async (e: Event) => {
        image.value = (e.target as HTMLInputElement).files?.[0] ?? null;
        if (!image.value) return;

        const { data, error } = await supabase.storage
            .from('chats')
            .upload(`${route.params.id}/chat-${Date.now()}`, image.value);

        if (error) {
            console.error(error);
            return;
        }

        console.log(data);
        emit('image-uploaded', data?.path ?? '');
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
