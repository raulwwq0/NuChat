export default defineNuxtRouteMiddleware(async (to, from) => {
    const supabase = useSupabaseClient();
    const user = useSupabaseUser();

    const { data } = await supabase
        .from("profiles")
        .select(`username, website, avatar_url`)
        .eq("id", user.value!.id)
        .single();

    if (!data?.username || !data?.website || !data?.avatar_url) {
        console.log(data);
        //return navigateTo("/profile/new");
    }

    return navigateTo("/profile");
});
