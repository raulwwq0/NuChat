<script setup lang="ts">
    const supabase = useSupabaseClient();
    const { profile } = storeToRefs(useProfileStore());
    const { isAdmin } = useProfileStore();
    const { ifNeeded } = useDefaultAvatar();
    const { get } = useBucket('avatars');
    const { errorNotification } = useSwal();
    const avatarUrl = ref('');

    const emit = defineEmits<{
        (e: 'open-dialog'): void;
    }>();

    const getUserAvatar = () => {
        get(profile.value!.avatar)
            .then(url => (avatarUrl.value = url))
            .catch(error => {
                errorNotification(error.message);
            });
    };

    const logout = () => {
        supabase.auth
            .signOut()
            .then(() => {
                navigateTo('/auth/sign-in');
            })
            .catch(error => {
                errorNotification(error.message);
            });
    };

    const menu = ref(false);

    const menuItems = [
        {
            icon: 'material-symbols:search-rounded',
            title: 'Find Chats',
            action: () => emit('open-dialog'),
            show: true,
        },
        {
            icon: 'ic:baseline-person-outline',
            title: 'Profile',
            action: () => navigateTo('/profile'),
            show: true,
        },
        {
            icon: 'eos-icons:admin-outlined',
            title: 'Admin Panel',
            action: () => navigateTo('/admin'),
            show: isAdmin(),
        },
        {
            icon: 'lucide:log-out',
            title: 'Logout',
            action: logout,
            show: true,
        },
    ];

    onMounted(getUserAvatar);
</script>

<template>
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
                        <Icon :name="item.icon" class="menu-option-icon" />
                        <VListItemTitle class="menu-option-title">{{
                            item.title
                        }}</VListItemTitle>
                    </div>
                </VListItem>
            </div>
        </VList>
    </VMenu>
</template>

<style scoped lang="scss">
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
