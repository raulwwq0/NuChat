import { ChatUser } from '~~/interfaces/chat-user.interface';
import { ProfileWithTotalMessages } from '~~/interfaces/profile.interface';

export const useAdmin = () => {
    const supabase = useSupabaseClient();
    const profilesWithTotalMessages = ref<ProfileWithTotalMessages[]>([]);
    const chatsWatcher = ref();
    const { get } = useBucket('avatars');

    const fetchAllProfilesWithTotalMessages = async () => {
        const { data: profiles, error: profilesError } = await supabase
            .from('profiles_with_total_messages')
            .select('*');

        if (profilesError) {
            console.error(profilesError);
            return [];
        }

        profilesWithTotalMessages.value = [...(profiles || [])];
    };

    const deleteProfile = async (profileId: string) => {
        await deleteUserChats(profileId);
        const { error } = await supabase
            .from('profiles')
            .delete()
            .eq('id', profileId);

        if (error) {
            console.error(error);
        }
    };

    const deleteUserChats = async (userId: string) => {
        const { data: chatUsers, error: chatUsersError } = await supabase
            .from('chat_user')
            .select('*')
            .eq('user_id', userId);

        if (chatUsersError) {
            console.error(chatUsersError);
            return [];
        }

        const chatIds = chatUsers?.map(
            (chatUser: ChatUser) => chatUser.chat_id
        );

        const { error: deleteChatsError } = await supabase
            .from('chats')
            .delete()
            .in('id', chatIds || []);

        if (deleteChatsError) {
            console.error(deleteChatsError);
        }
    };

    function startProfilesWatcher() {
        chatsWatcher.value = supabase
            .channel('profiles-channel')
            .on(
                'postgres_changes',
                { event: '*', schema: 'public', table: 'profiles' },
                async () => {
                    await fetchAllProfilesWithTotalMessages();
                    for (const profile of profilesWithTotalMessages.value) {
                        get(profile.avatar).then(
                            url => (profile.avatarUrl = url)
                        );
                    }
                }
            )
            .subscribe();
    }

    function stopProfilesWatcher() {
        chatsWatcher.value?.unsubscribe();
    }

    return {
        profilesWithTotalMessages,
        fetchAllProfilesWithTotalMessages,
        deleteProfile,
        startProfilesWatcher,
        stopProfilesWatcher,
    };
};
