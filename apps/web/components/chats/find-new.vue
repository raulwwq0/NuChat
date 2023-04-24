<script lang="ts" setup>
    const supabase = useSupabaseClient();
    const username = ref('');

    const possibleUsers = ref([]);

    const findUserByUsername = async () => {
        if (username.value.length < 3) {
            possibleUsers.value = [];
            return;
        }
        const { data, error } = await supabase
            .from('profiles')
            .select('*')
            .ilike('username', `%${username.value}%`);

        if (error) {
            console.error(error);
            return;
        }

        possibleUsers.value = data;
        console.log(possibleUsers.value);
    };
</script>

<template>
    <main>
        <header>
            <input v-model="username" type="text" @input="findUserByUsername" />
        </header>
        <section>
            <ul>
                <li v-for="user in possibleUsers" :key="user.id">
                    {{ user.username }}
                </li>
            </ul>
        </section>
    </main>
</template>

<style scoped>
    main {
        display: flex;
        flex-flow: column;
        justify-content: center;
        align-items: center;
        background-color: white;
    }
</style>
