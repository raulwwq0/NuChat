<script lang="ts" setup>
    const route = useRoute();
    const dropArea = ref<HTMLElement | null>(null);
    const { errorNotification } = useSwal();
    const { upload } = useBucket('chats');

    const uploadImages = (e: DragEvent) => {
        const files = e.dataTransfer?.files;
        if (!files) return;

        for (const file of files) {
            upload(file)
                .then((path?: string) => {
                    if (!path) return;
                    useMessages(route.params.id as string).sendImage(path);
                })
                .catch(error => {
                    errorNotification(error.message);
                });
        }
    };

    const highlight = () => {
        dropArea.value!.classList.add('highlight');
    };

    const unhighlight = () => {
        dropArea.value!.classList.remove('highlight');
    };

    const onDragEnter = () => {
        highlight();
    };

    const onDragLeave = () => {
        unhighlight();
    };

    const onDrop = (e: DragEvent) => {
        unhighlight();
        uploadImages(e);
    };
</script>

<template>
    <div
        ref="dropArea"
        class="drop-area"
        @dragenter.stop.prevent="onDragEnter"
        @dragleave.stop.prevent="onDragLeave"
        @dragover.stop.prevent="onDragEnter"
        @drop.stop.prevent="onDrop"
    >
        <h4 for="fileInput">Drop to send</h4>
    </div>
</template>

<style lang="scss" scoped>
    .drop-area {
        display: flex;
        flex-flow: column;
        align-items: center;
        justify-content: center;
        width: 110%;
        height: 105%;
        border: 3px dashed transparent;
        border-radius: 10px;
        font-family: sans-serif;
        font-size: 1.2rem;
        transition: 0.3s;
        position: absolute;
        top: -23px;
        left: -23px;
        pointer-events: auto;
        transform: translateZ(-10px);

        h4 {
            display: none;
        }

        &.highlight {
            border-color: $primary;
            background-color: #fff;
            z-index: 100;
            top: -3px;
            left: -3px;
            width: 100%;
            height: 100%;

            h4 {
                color: $primary;
                display: flex;
            }
        }
    }
</style>
