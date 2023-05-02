<script lang="ts" setup>
    import data from '@/assets/emojis.json';

    defineProps<{
        showArrow?: boolean;
    }>();

    defineEmits<{
        'emoji-click': (emoji: string) => void;
    }>();

    const categories = computed(() => Object.keys(data));
    const categoryEmojis = (category: string) =>
        Object.values((data as any)[category]);
</script>

<template>
    <div class="emoji-picker">
        <div class="picker-container">
            <div
                v-for="category in categories"
                :key="`category_${category}`"
                class="category"
            >
                <span>{{ category }}</span>
                <div class="emojis-container">
                    <button
                        v-for="(emoji, index) in categoryEmojis(category)"
                        :key="`emoji_${index}`"
                        @click.prevent="$emit('emoji-click', emoji)"
                    >
                        {{ emoji }}
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showArrow" class="bottom-arrow"></div>
    </div>
</template>

<style scoped>
    .emoji-picker {
        position: relative;
        display: flex;
        flex-direction: column;
        width: 20rem;
        height: 20rem;
        max-width: 100%;
    }
    .emoji-picker,
    .bottom-arrow {
        box-shadow: 0 0 5px 1px rgba(0, 0, 0, 0.0975);
    }
    .emoji-picker,
    .picker-container {
        border-radius: 0.5rem;
        background: white;
    }
    .picker-container {
        position: relative;
        padding: 1rem;
        overflow: auto;
        z-index: 1;
    }
    .category {
        display: flex;
        flex-direction: column;
        margin-bottom: 1rem;
        color: rgb(169, 169, 169);
    }
    .emojis-container {
        display: flex;
        flex-wrap: wrap;
    }
    .category button {
        margin: 0.5rem;
        margin-left: 0;
        background: inherit;
        border: none;
        font-size: 1.75rem;
        padding: 0;
    }
    .bottom-arrow {
        position: absolute;
        left: 50%;
        bottom: 0;
        width: 0.75rem;
        height: 0.75rem;
        transform: translate(-50%, 50%) rotate(45deg);
        background: white;
    }
</style>
