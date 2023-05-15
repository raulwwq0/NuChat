import { SupabaseException } from '~~/exceptions/supabase.exception';
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
            throw new SupabaseException(chatUsersError.message);
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
            throw new SupabaseException(profileError.message);
        }

        return profileData!;
    };

    const getFromChatId = async (chatId: string): Promise<Profile> => {
        try {
            const chatUsers = await fetchChatUsers(chatId);

            const otherUser: any = chatUsers.find(
                (chatUser: ChatUser) => chatUser.user_id !== user.value!.id
            );

            const profile = await fetchProfile(otherUser!.user_id);

            return profile!;
        } catch (error: any) {
            throw new SupabaseException(error.message);
        }
    };

    const findByUsername = async (username: string): Promise<Profile[]> => {
        const { data, error } = await supabase
            .from('profiles')
            .select('*')
            .ilike(
                'username',
                `%${username[0] === '@' ? username.slice(1) : username}%`
            );

        if (error) {
            throw new SupabaseException(error.message);
        }

        return data.filter(
            (profile: Profile) => profile.id !== user.value!.id
        ) as Profile[];
    };

    const upsert = async (profile: Profile) => {
        const { error } = await supabase
            .from('profiles')
            .upsert(profile as never)
            .eq('id', profile.id);

        if (error) {
            throw new SupabaseException(error.message);
        }
    };

    return {
        fetchProfile,
        getFromChatId,
        findByUsername,
        upsert,
    };
};
