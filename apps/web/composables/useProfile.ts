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
        const { data: profile, error: profileError } = await supabase
            .from('profiles')
            .select('*')
            .eq('id', userId)
            .single();

        if (profileError) {
            console.error(profileError);
        }

        return profile!;
    };

    const getFromChatId = async (chatId: string): Promise<Profile> => {
        const chatUsers = await fetchChatUsers(chatId);

        const otherUser: any = chatUsers.find(
            (chatUser: ChatUser) => chatUser.user_id !== user.value!.id
        );

        const profile = await fetchProfile(otherUser!.user_id);

        return profile!;
    };

    const update = async (profile: Profile) => {
        const { error } = await supabase
            .from('profiles')
            .update(profile as never)
            .eq('id', user.value!.id);

        if (error) {
            throw error;
        }
    };

    return {
        fetchProfile,
        getFromChatId,
        update,
    };
};
