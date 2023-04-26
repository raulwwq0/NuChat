<script lang="ts" setup>
    const { auth } = useSupabaseClient();

    const logout = async () => {
        await auth.signOut();
        navigateTo('/auth/sign-in');
    };

    const menu = ref(false);

    const menuItems = [
        {
            title: 'New Chat',
            action: () => {
                newChatDialog.value = true;
            },
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

    const newChatDialog = ref(false);
</script>

<template>
    <main>
        <aside>
            <VMenu v-model="menu">
                <template #activator="{ props }">
                    <header color="primary" v-bind="props">
                        <div>You</div>
                        <div>
                            <Icon
                                v-if="!menu"
                                name="line-md:close-to-menu-alt-transition"
                                class="menu-icon"
                            />
                            <Icon
                                v-else
                                name="line-md:menu-to-close-alt-transition"
                                class="menu-icon"
                            />
                        </div>
                    </header>
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
        <VDialog v-model="newChatDialog">
            <ChatsFindNew />
        </VDialog>
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

            header {
                width: 100%;
                height: 50px;
                border-radius: 8px;
                border-bottom-left-radius: 0px;
                border-bottom-right-radius: 0px;
                display: flex;
                flex-flow: row;
                justify-content: space-between;
                align-items: center;
                background-color: $primary;
                color: #fff;

                div {
                    margin: 0 20px;

                    .menu-icon {
                        font-size: 1.2rem;
                    }
                }
            }
        }

        section {
            display: flex;
            flex-flow: column;
            align-items: center;
            height: 95%;
            width: 67%;
            //background-color: antiquewhite;
            border: 1px solid $primary;
            border-radius: 10px;
        }
    }
</style>
