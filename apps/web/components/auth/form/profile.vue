<script lang="ts" setup>
    import * as yup from 'yup';
    import { Profile } from '~~/interfaces/profile.interface';

    const user = useSupabaseUser();

    defineProps({
        title: {
            type: String,
            required: true,
        },
    });

    const profile: Profile = reactive({
        id: user.value!.id || '',
        full_name: '',
        username: '',
        avatar_url: '',
    });

    const validationSchema = yup.object({
        full_name: yup.string().required('Full name is required'),
        username: yup.string().required('Username is required'),
        avatar_url: yup.string().url('Avatar URL must be a valid URL'),
    });

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
            <VeeField
                v-model="profile.full_name"
                name="full_name"
                type="text"
                placeholder="Full Name"
            />
            <VeeErrorMessage name="full_name" class="error" />
            <VeeField
                v-model="profile.username"
                name="username"
                type="text"
                placeholder="Username"
            />
            <VeeErrorMessage name="username" class="error" />
            <VeeField
                v-model="profile.avatar_url"
                name="avatar_url"
                type="text"
                placeholder="Avatar URL"
            />
            <VeeErrorMessage name="avatar_url" class="error" />
            <button type="submit">Save and Continue</button>
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

            input {
                width: 100%;
                padding: 1rem;
                margin-bottom: 1rem;
                border: 1px solid #ccc;
                border-radius: 0.5rem;
                font-size: 1rem;
            }

            .error {
                color: red;
                font-size: 0.8rem;
                margin-bottom: 1rem;
            }

            button {
                width: 100%;
                padding: 1rem;
                margin-bottom: 1rem;
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
