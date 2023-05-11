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
        startProfilesWatcher,
        stopProfilesWatcher,
    };
};
