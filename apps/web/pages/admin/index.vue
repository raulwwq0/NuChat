<script lang="ts" setup>
    import {
        Profile,
        ProfileWithTotalMessages,
    } from '@/interfaces/profile.interface';

    definePageMeta({
        middleware: ['authenticated', 'empty-profile', 'is-admin'],
    });

    useServerSeoMeta({
        title: 'NuChat | Admin',
        description: 'Just a chat app built with Nuxt 3 and Supabase',
    });

    const { errorNotification } = useSwal();
    const { ifNeeded } = useDefaultAvatar();
    const { get } = useBucket('avatars');
    const {
        profilesWithTotalMessages: profiles,
        fetchAllProfilesWithTotalMessages,
        startProfilesWatcher,
        stopProfilesWatcher,
    } = useAdmin();

    type Dialogs = 'edit' | 'delete';

    const dialogs = reactive({
        edit: false,
        delete: false,
    });
    const profileForActions = ref<Profile | null>(null);

    const headers = [
        { title: 'ID', key: 'id', sortable: false },
        { title: 'Username', key: 'username' },
        { title: 'Full Name', key: 'full_name' },
        { title: 'Avatar', key: 'avatar', sortable: false },
        { title: 'Role', key: 'role' },
        { title: 'Total Messages', key: 'total_messages' },
        { title: 'Actions', key: 'actions', sortable: false, align: 'center' },
    ];

    const prepareProfileForActions = (profile: ProfileWithTotalMessages) => {
        const profileToClean = { ...profile };
        delete profileToClean.avatarUrl;
        delete profileToClean.total_messages;
        profileForActions.value = profileToClean;
    };

    const openDialog = (dialog: Dialogs, profile: ProfileWithTotalMessages) => {
        prepareProfileForActions(profile);
        dialogs[dialog] = true;
    };

    const closeDialog = (dialog: Dialogs) => {
        dialogs[dialog] = false;
    };

    onMounted(() => {
        startProfilesWatcher();
        fetchAllProfilesWithTotalMessages()
            .then(() => {
                for (const profile of profiles.value) {
                    get(profile.avatar)
                        .then(url => (profile.avatarUrl = url))
                        .catch(error => {
                            errorNotification(error.message);
                        });
                }
            })
            .catch(error => {
                errorNotification(error.message);
            });
    });

    onUnmounted(() => {
        stopProfilesWatcher();
    });
</script>

<template>
    <main>
        <header>
            <h1>Admin Panel</h1>
            <div @click="navigateTo('/chats')">
                <Icon
                    name="material-symbols:keyboard-backspace-rounded"
                    class="icon"
                />
                <span>Back to Chats</span>
            </div>
        </header>
        <VDataTable
            v-if="profiles"
            :headers="headers"
            :items="profiles"
            :items-per-page="5"
            multi-sort
            class="data-table"
        >
            <template #item="{ item }">
                <tr>
                    <td>{{ item.raw.id }}</td>
                    <td>{{ item.raw.username }}</td>
                    <td>{{ item.raw.full_name }}</td>
                    <td>
                        <img
                            :src="ifNeeded(item.raw.avatarUrl)"
                            :alt="item.raw.full_name"
                        />
                    </td>
                    <td>{{ item.raw.role }}</td>
                    <td>{{ item.raw.total_messages }}</td>
                    <td>
                        <Icon
                            name="material-symbols:edit-outline-rounded"
                            class="icon edit"
                            @click="() => openDialog('edit', item.raw)"
                        />
                        <Icon
                            name="material-symbols:delete-outline-rounded"
                            class="icon delete"
                            @click="() => openDialog('delete', item.raw)"
                        />
                    </td>
                </tr>
            </template>
        </VDataTable>
        <span v-else>No users found</span>
        <VDialog v-model="dialogs.edit" width="50%" height="50%">
            <AdminEdit
                :profile="profileForActions!"
                @close="closeDialog('edit')"
            />
        </VDialog>
        <VDialog v-model="dialogs.delete" width="50%" height="50%">
            <AdminDelete
                :profile="profileForActions!"
                @close="closeDialog('delete')"
            />
        </VDialog>
    </main>
</template>

<style lang="scss" scoped>
    main {
        display: flex;
        flex-flow: column;
        justify-content: start;
        align-items: center;
        height: 100vh;
        width: 70%;
        margin: 0 auto;

        header {
            display: flex;
            flex-flow: column;
            justify-content: center;
            align-items: center;

            h1 {
                text-align: center;
                margin-top: 70px;
                font-size: 2rem;
            }

            div {
                display: flex;
                align-items: center;
                justify-content: center;
                margin-top: 20px;
                cursor: pointer;
                transition: all 0.2s ease-in-out;
                border-bottom: 2px solid transparent;
                padding-bottom: 10px;
                width: fit-content;

                span {
                    margin-left: 10px;
                    font-size: 1.2rem;
                }

                &:hover {
                    color: $primary;
                    border-bottom: 2px solid $primary;
                }
            }
        }

        .data-table {
            border: 1px solid $primary;
            border-radius: 5px;
            padding: 20px;
            max-height: 75%;
            overflow-y: scroll;
            margin-top: 40px;

            td {
                padding-top: 10px;

                img {
                    width: 50px;
                    height: 50px;
                    border-radius: 50%;
                    border: 1px solid #ccc;
                    vertical-align: middle;
                }

                .icon {
                    cursor: pointer;
                    margin: 0 5px;
                    font-size: 1.5rem;
                    color: $primary;
                    transition: all 0.2s ease-in-out;

                    &.edit:hover {
                        color: #fbbc00;
                    }

                    &.delete:hover {
                        color: #ff1744;
                    }
                }
            }
        }

        .dialog {
            width: 50%;
            height: 50%;
            background-color: #fff;
        }
    }
</style>
