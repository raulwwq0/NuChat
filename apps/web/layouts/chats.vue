<script lang="ts" setup>
    import { useProfileStore } from '~~/stores/profile.store';

    const supabase = useSupabaseClient();
    const user = useSupabaseUser();
    const route = useRoute();
    const { ifNeeded } = useDefaultAvatar();
    const userAvatar = ref('');
    const avatarUrl = ref('');

    const getUserAvatar = async () => {
        const { data: profile, error } = await supabase
            .from('profiles')
            .select('avatar')
            .eq('id', user.value?.id)
            .single();

        if (error) throw error;

        userAvatar.value = profile?.avatar || userAvatar.value;

        if (userAvatar.value) {
            avatarUrl.value = await useBucket('avatars').get(userAvatar.value);
        }
    };

    const logout = async () => {
        await supabase.auth.signOut();
        navigateTo('/auth/sign-in');
    };

    const menu = ref(false);

    const menuItems = [
        {
            icon: 'material-symbols:search-rounded',
            title: 'Find Chats',
            action: () => (newChatDialog.value = true),
            show: true,
        },
        {
            icon: 'ic:baseline-person-outline',
            title: 'Profile',
            action: () => navigateTo('/profile'),
            show: true,
        },
        {
            icon: 'ic:baseline-person-outline',
            title: 'Admin Panel',
            action: () => navigateTo('/admin'),
            show: useProfileStore().isAdmin(),
        },
        {
            icon: 'lucide:log-out',
            title: 'Logout',
            action: logout,
            show: true,
        },
    ];

    const newChatDialog = ref(false);

    onMounted(getUserAvatar);
</script>

<template>
    <main>
        <aside>
            <VMenu v-model="menu">
                <template #activator="{ props }">
                    <header color="primary" v-bind="props">
                        <figure>
                            <img :src="ifNeeded(avatarUrl)" alt="Your avatar" />
                            <figcaption>You</figcaption>
                        </figure>
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
                <VList class="menu-options">
                    <div v-for="item in menuItems" :key="item.title">
                        <VListItem
                            v-if="item.show"
                            class="menu-option"
                            @click="item.action"
                        >
                            <div>
                                <Icon
                                    :name="item.icon"
                                    class="menu-option-icon"
                                />
                                <VListItemTitle class="menu-option-title">{{
                                    item.title
                                }}</VListItemTitle>
                            </div>
                        </VListItem>
                    </div>
                </VList>
            </VMenu>

            <slot name="chatList" />
        </aside>
        <section class="messages">
            <slot name="messages" />
            <ChatsDragDropUploadImage v-if="route.params.id" />
        </section>
        <VDialog v-model="newChatDialog" class="dialog">
            <ChatsFindNew @close="newChatDialog = false" />
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
                height: 60px;
                border-radius: 8px;
                border-bottom-left-radius: 0px;
                border-bottom-right-radius: 0px;
                display: flex;
                flex-flow: row;
                justify-content: space-between;
                align-items: center;
                background-color: $primary;
                color: #fff;

                figure {
                    margin: 0 20px;
                    display: flex;
                    flex-flow: row;
                    justify-content: flex-start;
                    align-items: center;

                    img {
                        width: 40px;
                        height: 40px;
                        border-radius: 9999px;
                        object-fit: cover;
                    }

                    figcaption {
                        margin: 0 10px;
                        padding: 10px 0;
                        font-size: 1.5rem;
                    }
                }

                div {
                    margin: 0 20px;

                    .menu-icon {
                        font-size: 1.4rem;
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
            position: relative;
        }
    }

    .menu-options {
        .menu-option div {
            display: flex;
            flex-flow: row;
            justify-content: flex-start;
            align-items: center;

            .menu-option-icon {
                font-size: 1rem;
                margin-right: 10px;
            }

            .menu-option-title {
                font-size: 1rem;
                width: 90%;
            }
        }
    }
</style>
