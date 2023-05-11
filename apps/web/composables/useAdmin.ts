export const useAdmin = () => {
    const supabase = useSupabaseClient();

    const fetchAllProfilesWithTotalMessages = async () => {
        const { data: profiles, error: profilesError } = await supabase
            .from('profiles_with_total_messages')
            .select('*');

        if (profilesError) {
            console.error(profilesError);
            return [];
        }

        return profiles;
    };

    return {
        fetchAllProfilesWithTotalMessages,
    };
};
