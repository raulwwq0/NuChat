export default defineNuxtRouteMiddleware(async () => {
    const supabase = useSupabaseClient()
    const user = useSupabaseUser()

    const { data } = await supabase
        .from('profiles')
        .select(`username, full_name`)
        .eq('id', user.value!.id)
        .single()

    if (!data) {
        return navigateTo('/profile/new')
    }

    const { username, full_name: fullName } = data

    if (!username || !fullName) {
        return navigateTo('/profile/new')
    }
})
