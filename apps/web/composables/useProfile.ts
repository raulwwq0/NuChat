import { ChatUser } from '~~/interfaces/chat-user.interface';
import { Profile } from '~~/interfaces/profile.interface';

export const useProfile = () => {
    const supabase = useSupabaseClient();
    const user = useSupabaseUser();

    const fetchChatUsers = async (chatId: string) => {
        const { data: chatUsers, error: chatUsersError } = await supabase
            .from('chat_user')
            .select('*')
            .eq('chat_id', chatId);

        if (chatUsersError) {
            console.error(chatUsersError);
            return [];
        }

        return chatUsers;
    };

    const fetchProfile = async (userId: string): Promise<Profile> => {
        const { data: profileData, error: profileError } = await supabase
            .from('profiles')
            .select('*')
            .eq('id', userId)
            .single();

        if (profileError) {
            console.error(profileError);
        }

        return profileData!;
    };

    const getFromChatId = async (chatId: string): Promise<Profile> => {
        const chatUsers = await fetchChatUsers(chatId);

        const otherUser: any = chatUsers.find(
            (chatUser: ChatUser) => chatUser.user_id !== user.value!.id
        );

        const profile = await fetchProfile(otherUser!.user_id);

        return profile!;
    };

    const upsert = async (profile: Profile) => {
        const { error } = await supabase
            .from('profiles')
            .upsert(profile as never)
            .eq('id', profile.id);

        if (error) {
            throw error;
        }
    };

    return {
        fetchProfile,
        getFromChatId,
        upsert,
    };
};
