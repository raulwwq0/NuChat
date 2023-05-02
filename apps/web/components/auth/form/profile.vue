<script lang="ts" setup>
    import * as yup from 'yup';
    import { Profile } from '~~/interfaces/profile.interface';

    const user = useSupabaseUser();
    const config = useRuntimeConfig();

    interface ProfileProps {
        title: string;
        profile?: Profile;
    }

    const props = withDefaults(defineProps<ProfileProps>(), {
        profile: {
            id: '',
            full_name: '',
            username: '',
            avatar: '',
        } as any,
    });

    const profile: Profile = reactive({
        ...props.profile!,
        id: user.value?.id || '',
    });

    const validationSchema = yup.object({
        full_name: yup.string().required('Full name is required'),
        username: yup.string().required('Username is required'),
    });

    const isCorrectAvatar = computed(() => typeof profile.avatar === 'string');

    const uploadAvatar = () => {
        useImageUpload()
            .upload(profile.avatar, 'avatars')
            .then((path?: string) => {
                profile.avatar = path || profile.avatar;
            });
    };

    const saveProfile = () => {
        useProfile()
            .update(profile)
            .then(() => {
                navigateTo('/chats');
            })
            .catch(error => {
                if (error.code === '23505') {
                    alert('Username already taken');
                }
            });
    };
</script>

<template>
    <main>
        <h1>{{ $props.title }}</h1>
        <VeeForm :validation-schema="validationSchema" @submit="saveProfile">
            <label for="avatarUrl">
                <img
                    v-if="profile.avatar"
                    :src="`${config.public.avatarBucketUrl}/${
                        isCorrectAvatar ? profile.avatar : 'default-avatar'
                    }`"
                    alt="Your avatar"
                />
            </label>
            <VeeField
                id="avatarUrl"
                v-model="profile.avatar"
                name="avatarUrl"
                type="file"
                @change="uploadAvatar"
            />
            <VeeErrorMessage name="avatarUrl" class="error" />
            <label for="full_name">Full Name</label>
            <VeeField
                v-model="profile.full_name"
                name="full_name"
                type="text"
                placeholder="Full Name"
            />
            <VeeErrorMessage name="full_name" class="error" />
            <label for="username">Username</label>
            <VeeField
                v-model="profile.username"
                name="username"
                type="text"
                placeholder="Username"
            />
            <VeeErrorMessage name="username" class="error" />
            <button type="submit">Save</button>
        </VeeForm>
    </main>
</template>

<style lang="scss" scoped>
    main {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100vh;

        h1 {
            font-size: 2rem;
            margin-bottom: 2rem;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;

            label {
                width: 100%;
                margin-bottom: 0.5rem;
                font-size: 1.2rem;
                display: flex;
                justify-content: center;
                cursor: pointer;

                &:first-child {
                    margin-bottom: 3rem;
                    transition: all 0.2s ease-in-out;

                    &:hover {
                        opacity: 0.8;
                    }
                }

                img {
                    width: 100px;
                    height: 100px;
                    border-radius: 9999px;
                    object-fit: cover;
                    border: 1px solid #ccc;
                }
            }

            input {
                width: 100%;
                padding: 1rem;
                margin-bottom: 1rem;
                border: 1px solid #ccc;
                border-radius: 0.5rem;
                font-size: 1rem;
            }

            input[type='file'] {
                display: none;
            }

            .error {
                color: red;
                font-size: 0.8rem;
                margin-bottom: 1rem;
            }

            button {
                width: 100%;
                padding: 1rem;
                margin-top: 1rem;
                border: 1px solid #ccc;
                border-radius: 0.5rem;
                font-size: 1rem;
                background-color: #000;
                color: #fff;
                cursor: pointer;
            }
        }
    }
</style>
