<script lang="ts" setup>
    import * as yup from 'yup';
    import { Profile } from '~~/interfaces/profile.interface';

    const user = useSupabaseUser();

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

    const userAvatar = ref<string>('');

    const validationSchema = yup.object({
        full_name: yup.string().required('Full name is required'),
        username: yup.string().required('Username is required'),
    });

    const uploadAvatar = () => {
        useBucket('avatars')
            .upload(profile.avatar)
            .then((path?: string) => {
                profile.avatar = path || profile.avatar;
            })
            .then(() => {
                useBucket('avatars')
                    .get(profile.avatar)
                    .then((url: string) => (userAvatar.value = url));
            });
    };

    const saveProfile = () => {
        useProfile()
            .upsert(profile)
            .then(() => {
                navigateTo('/chats');
            })
            .catch(error => {
                if (error.code === '23505') {
                    alert('Username already taken');
                }
            });
    };

    onMounted(() => {
        useBucket('avatars')
            .get(profile.avatar)
            .then((url: string) => (userAvatar.value = url));
    });
</script>

<template>
    <main>
        <h1>{{ $props.title }}</h1>
        <VeeForm :validation-schema="validationSchema" @submit="saveProfile">
            <label for="avatarUrl">
                <img
                    :src="useDefaultAvatar().ifNeeded(userAvatar)"
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
