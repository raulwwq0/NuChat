<script lang="ts" setup>
    import { ProfileWithTotalMessages } from '@/interfaces/profile.interface';

    definePageMeta({
        middleware: ['empty-profile', 'authenticated', 'is-admin'],
    });

    const { fetchAllProfilesWithTotalMessages } = useAdmin();
    const { ifNeeded } = useDefaultAvatar();
    const { get } = useBucket('avatars');

    const profiles = ref<ProfileWithTotalMessages[]>(
        await fetchAllProfilesWithTotalMessages()
    );

    const headers = [
        { title: 'ID', key: 'id', sortable: false },
        { title: 'Username', key: 'username' },
        { title: 'Full Name', key: 'full_name' },
        { title: 'Avatar', key: 'avatar', sortable: false },
        { title: 'Role', key: 'role' },
        { title: 'Total Messages', key: 'total_messages' },
        { title: 'Actions', key: 'actions', sortable: false, align: 'center' },
    ];

    onMounted(() => {
        for (const profile of profiles.value) {
            get(profile.avatar).then(url => (profile.avatarUrl = url));
        }
    });
</script>

<template>
    <main>
        <h1>Admin Panel</h1>
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
                        />
                        <Icon
                            name="material-symbols:delete-outline-rounded"
                            class="icon delete"
                        />
                    </td>
                </tr>
            </template>
        </VDataTable>
        <span v-else>No users found</span>
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

        h1 {
            text-align: center;
            margin-top: 70px;
            font-size: 2rem;
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
