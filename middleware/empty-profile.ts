export default defineNuxtRouteMiddleware(async (to, from) => {
    const supabase = useSupabaseClient();
    const user = useSupabaseUser();

    console.log("user", user, user.value);

    const { data } = await supabase
        .from("profiles")
        .select(`username, full_name`)
        .eq("id", user.value!.id)
        .single();

    const { username, full_name: fullName } = data!;

    if (!username || !fullName) {
        //return navigateTo("/profile/new");
    }

    //return navigateTo("/chats");
});
