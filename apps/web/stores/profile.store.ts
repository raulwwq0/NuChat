import { Profile } from '~~/interfaces/profile.interface';
import { Role } from '~~/enums/role.enum';

export const useProfileStore = defineStore('profile', () => {
    const user = useSupabaseUser();
    const profile = ref<Profile>();

    const { fetchProfile } = useProfile();

    const isAdmin = (): boolean => {
        const { role } = profile.value || {};
        return role === Role.ADMIN;
    };

    const fetch = async () => {
        const profileData = await fetchProfile(user.value!.id);
        profile.value = profileData;
    };

    fetch();

    return {
        profile,
        isAdmin,
        fetch,
    };
});
