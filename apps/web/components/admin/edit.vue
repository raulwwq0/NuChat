<script setup lang="ts">
    import { Profile } from '~~/interfaces/profile.interface';

    interface ProfileProps {
        profile: Profile;
    }

    defineProps<ProfileProps>();

    defineEmits<{
        (e: 'close'): void;
    }>();
</script>

<template>
    <main>
        <AuthFormProfile
            class="profile-form-admin-edit"
            :title="`Editing profile of @${profile.username}`"
            :profile="profile"
            @saved="$emit('close')"
        />
        <Icon
            name="material-symbols:close-rounded"
            class="close-icon"
            @click="$emit('close')"
        />
    </main>
</template>

<style scoped lang="scss">
    main {
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        background-color: #fff;
        padding: 1rem;
        position: relative;

        .profile-form-admin-edit {
            width: 100%;
            max-width: 500px;
            margin: 20px auto;
            height: auto;
            background-color: transparent;
            color: #000;
        }

        .close-icon {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 2rem;
            color: #ccc;
            cursor: pointer;

            &:hover {
                color: $primary;
                transition: all 0.2s ease-in-out;
            }
        }
    }
</style>
