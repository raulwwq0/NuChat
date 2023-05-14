<script lang="ts" setup>
    import { Profile } from '~~/interfaces/profile.interface';

    const supabase = useSupabaseClient();
    const user = useSupabaseUser();
    const username = ref('');

    const profilesFound = ref<Profile[]>([]);
    const areUsersFound = computed(() => profilesFound.value.length > 0);

    const emit = defineEmits<{
        (e: 'close'): void;
    }>();

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

    watch(profilesFound, () => {
        for (const profile of profilesFound.value) {
            useBucket('avatars')
                .get(profile.avatar)
                .then(url => (profile.avatar = url));
        }
    });

    const createChat = async (profileId: string) => {
        const chatId = await useChat().create(profileId);
        emit('close');
        navigateTo(`/chats/${chatId}/messages`);
    };
</script>

<template>
    <main class="find-dialog">
        <header>
            <input
                v-model="username"
                type="text"
                class="input"
                @input="findUserByUsername"
            />
        </header>
        <section>
            <VList v-if="areUsersFound" lines="one">
                <ChatsListItem
                    v-for="userProfile in profilesFound"
                    :key="userProfile.id"
                    :data="userProfile"
                    @click="createChat(userProfile.id)"
                />
            </VList>
            <div v-else class="no-users-found-message">
                <strong>Find already existing chats</strong>
                <span>or</span>
                <strong>Search for new ones</strong>
            </div>
        </section>
        <Icon
            name="material-symbols:close-rounded"
            class="close-icon"
            @click="$emit('close')"
        />
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
        }

        section {
            width: 80%;
            height: 100%;
            overflow-y: scroll;
            padding: 0 1rem;

            .no-users-found-message {
                display: flex;
                flex-flow: column;
                justify-content: center;
                align-items: center;
                text-align: center;
                font-size: 1.2rem;
                color: #aaa;
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;

                strong {
                    font-size: 1.5rem;
                    color: $primary;
                }

                span {
                    margin: 0.5rem;
                }
            }
        }

        .close-icon {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 2rem;
            color: #ccc;
            cursor: pointer;

            &:hover {
                color: $primary;
                transition: all 0.2s ease-in-out;
            }
        }
    }
</style>
