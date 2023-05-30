<script lang="ts" setup>
    import data from '@/assets/emojis.json';

    defineEmits<{
        (e: 'emoji-click', emoji: string): void;
    }>();

    const searchEmoji = ref('');

    const categories = computed(() => Object.keys(data));
    const allCategoryEmojis = (category: string): string[] =>
        Object.values((data as any)[category]);

    const filteredCategoryEmojis = (category: string): string[] => {
        if (!searchEmoji.value) return allCategoryEmojis(category);

        const emojis = (data as any)[category];

        const possibleKeys = Object.keys(emojis).filter(key =>
            key.includes(searchEmoji.value)
        );

        const possibleEmojis = possibleKeys.map(key => (emojis as any)[key]);

        return possibleEmojis;
    };
</script>

<template>
    <section class="emoji-picker">
        <div class="search-bar">
            <input
                v-model="searchEmoji"
                type="text"
                placeholder="Search emoji..."
            />
        </div>
        <div class="picker-container">
            <div
                v-for="category in categories"
                :key="`category_${category}`"
                class="category"
            >
                <span>{{ category }}</span>
                <div class="emojis-container">
                    <button
                        v-for="(emoji, index) in filteredCategoryEmojis(
                            category
                        )"
                        :key="`emoji_${index}`"
                        @click.prevent="$emit('emoji-click', emoji)"
                    >
                        {{ emoji }}
                    </button>
                </div>
            </div>
        </div>
    </section>
</template>

<style lang="scss" scoped>
    .emoji-picker {
        position: relative;
        display: flex;
        flex-direction: column;
        width: 20rem;
        height: 20rem;
        max-width: 100%;
        border-radius: 10px;
        background: white;
        box-shadow: 0 0 5px 1px rgba(0, 0, 0, 0.0975);

        .search-bar {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 40px;
            width: 100%;

            input {
                width: 100%;
                height: 40px;
                border: none;
                outline: none;
                font-size: 1.2rem;
                padding: 0 1rem;
                caret-color: $primary;
            }
        }

        .picker-container {
            position: relative;
            padding: 1rem;
            overflow: auto;
            z-index: 1;

            .category {
                display: flex;
                flex-direction: column;
                margin-bottom: 1rem;
                color: rgb(169, 169, 169);

                span {
                    font-size: 1.1rem;
                    font-weight: 500;
                    margin-bottom: 0.5rem;
                }

                .emojis-container {
                    display: flex;
                    flex-wrap: wrap;
                }
                button {
                    margin: 0.5rem;
                    margin-left: 0;
                    background: inherit;
                    border: none;
                    font-size: 1.75rem;
                    padding: 0;
                    cursor: pointer;
                    transition: all 0.2s ease-in-out;

                    &:hover {
                        transform: scale(1.1);
                    }
                }
            }
        }
    }
</style>
