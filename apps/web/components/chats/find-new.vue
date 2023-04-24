<script lang="ts" setup>
    import { Profile } from '~~/interfaces/profile.interface';

    const supabase = useSupabaseClient();
    const user = useSupabaseUser();
    const username = ref('');

    const profilesFound = ref<Profile[]>([]);
    const areUsersFound = computed(() => profilesFound.value.length > 0);

    const findUserByUsername = async () => {
        if (username.value.length < 3) {
            profilesFound.value = [];
            return;
        }

        const { data, error } = await supabase
            .from('profiles')
            .select('*')
            .ilike(
                'username',
                `%${
                    username.value[0] === '@'
                        ? username.value.slice(1)
                        : username.value
                }%`
            );

        if (error) {
            console.error(error);
            return;
        }

        profilesFound.value = data.filter(
            (profile: Profile) => profile.id !== user.value!.id
        );
    };

    const createChat = async (profileId: string) => {
        const chatId = await useChat().create(profileId);
        navigateTo(`/chats/${chatId}/messages`);
    };
</script>

<template>
    <main class="find-dialog">
        <header>
            <input v-model="username" type="text" @input="findUserByUsername" />
        </header>
        <section>
            <VList v-if="areUsersFound" lines="one">
                <VListItem
                    v-for="userProfile in profilesFound"
                    :key="userProfile.id"
                    :title="userProfile.full_name"
                    :subtitle="`@${userProfile.username}`"
                    :prepend-avatar="userProfile.avatar_url"
                    @click="createChat(userProfile.id)"
                >
                    <VDivider />
                </VListItem>
            </VList>
            <span v-else class="no-users-found-message"
                >Find people by their username</span
            >
        </section>
    </main>
</template>

<style lang="scss" scoped>
    main.find-dialog {
        display: flex;
        flex-flow: column;
        justify-content: flex-start;
        align-items: center;
        background-color: white;
        padding-top: 5rem;
        position: relative;

        header {
            width: 100%;
            padding: 0 1rem;
            margin-bottom: 1rem;
            display: flex;
            justify-content: center;

            input {
                width: 80%;
                padding: 0.5rem;
                border: 1px solid $primary;
                border-radius: 5px;
                outline: none;
            }
        }

        section {
            width: 80%;
            height: 100%;
            overflow-y: scroll;
            padding: 0 1rem;

            .no-users-found-message {
                text-align: center;
                font-size: 1.2rem;
                color: $primary;
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
            }
        }
    }
</style>
