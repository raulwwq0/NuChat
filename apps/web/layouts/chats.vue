<script lang="ts" setup>
    const supabase = useSupabaseClient();

    const logout = async () => {
        await supabase.auth.signOut();
        navigateTo('/auth/sign-in');
    };

    const menuItems = [
        {
            title: 'New Chat',
            action: () => {},
        },
        {
            title: 'Profile',
            action: () => navigateTo('/profile'),
        },
        {
            title: 'Logout',
            action: logout,
        },
    ];
</script>

<template>
    <main>
        <aside>
            <VMenu>
                <template v-slot:activator="{ props }">
                    <VBtn color="primary" v-bind="props"> You </VBtn>
                </template>
                <VList>
                    <VListItem
                        v-for="item in menuItems"
                        :key="item.title"
                        @click="item.action"
                    >
                        <VListItemTitle>{{ item.title }}</VListItemTitle>
                    </VListItem>
                </VList>
            </VMenu>

            <slot name="chatList" />
        </aside>
        <section>
            <slot name="messages" />
        </section>
    </main>
</template>

<style lang="scss" scoped>
    main {
        display: flex;
        flex-flow: row;
        justify-content: space-between;
        align-items: center;
        height: 100vh;
        width: 70%;
        margin: 0 auto;
        //background-color: antiquewhite;

        aside {
            display: flex;
            flex-flow: column;
            align-items: center;
            height: 95%;
            width: 30%;
            border: 1px solid $primary;
            border-radius: 10px;

            .v-btn {
                width: 100%;
                height: 50px;
                border-radius: 10px;
                border-bottom-left-radius: 0px;
                border-bottom-right-radius: 0px;
            }
        }

        section {
            display: flex;
            flex-flow: column;
            align-items: center;
            height: 95%;
            width: 67%;
            background-color: antiquewhite;
        }
    }
</style>
