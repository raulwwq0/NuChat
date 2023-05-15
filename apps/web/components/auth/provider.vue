<script setup lang="ts">
    import { OAuthProvider } from '~~/types/oauth-provider.type';

    interface ProviderProps {
        provider: OAuthProvider;
        icon?: string;
    }

    const props = defineProps<ProviderProps>();

    const { errorNotification } = useSwal();
    const { signInOAuth } = useAuth(props.provider);

    const handleOAuth = () => {
        signInOAuth().catch(error => {
            errorNotification(error.message);
        });
    };
</script>

<template>
    <figure class="provider" @click="handleOAuth">
        <Icon v-if="icon" :name="icon" class="provider-icon" />
        <h2>Sign in with {{ provider }}</h2>
    </figure>
</template>

<style lang="scss" scoped>
    .provider {
        display: flex;
        align-items: center;
        justify-content: center;
        flex-flow: row;
        cursor: pointer;
        background-color: #000;
        padding: 1rem;
        border-radius: 5px;

        &:hover {
            background-color: #333;
            transition: all 0.2s ease-in-out;
        }

        h2 {
            font-size: 1.2rem;
            font-weight: 600;
            font-family: $title-font;
            color: #fff;
        }

        .icon {
            font-size: 1.5rem;
            margin-right: 1rem;
            color: #fff;
        }
    }
</style>
