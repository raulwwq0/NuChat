<script lang="ts" setup>
    const supabase = useSupabaseClient();
    const { errorNotification } = useSwal();

    const logout = () => {
        supabase.auth
            .signOut()
            .then(() => {
                navigateTo('/');
            })
            .catch(error => {
                errorNotification(error.message);
            });
    };
</script>

<template>
    <div>
        <span @click="logout()">Logout</span>
    </div>
</template>

<style lang="scss" scoped>
    div {
        display: flex;
        flex-flow: column;
        align-items: center;
        justify-content: center;
        height: 50px;
        width: 100%;
        background-color: $primary;

        span {
            font-size: 1.5rem;
            font-weight: 600;
            font-family: $title-font;
            color: $secondary;
            cursor: pointer;
        }
    }
</style>
