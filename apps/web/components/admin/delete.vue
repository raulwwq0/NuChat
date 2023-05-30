<script setup lang="ts">
    import { Profile } from '~~/interfaces/profile.interface';

    interface ProfileProps {
        profile: Profile;
    }

    const props = defineProps<ProfileProps>();

    const emit = defineEmits<{
        (e: 'close'): void;
    }>();

    const { deleteProfile } = useAdmin();
    const { errorNotification } = useSwal();

    const handleDelete = () => {
        deleteProfile(props.profile.id).catch(error => {
            errorNotification(error.message);
        });
        emit('close');
    };
</script>

<template>
    <main class="delete-dialog">
        <section class="warn">
            <h2>Are you sure you want to delete this profile?</h2>
            <p>This action cannot be undone.</p>
        </section>
        <section class="profile-data">
            <article>
                <h4>ID:</h4>
                <p>{{ props.profile.id }}</p>
            </article>
            <article>
                <h4>Full name:</h4>
                <p>{{ props.profile.full_name }}</p>
            </article>
            <article>
                <h4>Username:</h4>
                <p>{{ props.profile.username }}</p>
            </article>
        </section>
        <section class="buttons">
            <div @click="$emit('close')">Cancel</div>
            <div class="delete" @click="handleDelete">Delete</div>
        </section>
    </main>
</template>

<style scoped lang="scss">
    main.delete-dialog {
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        background-color: #fff;
        padding: 1rem;

        section {
            display: flex;
            flex-flow: column;
            justify-content: center;
            align-items: center;

            &.warn {
                h2 {
                    font-size: 1.5rem;
                    font-weight: 600;
                    font-family: $body-font;
                    color: $primary;
                }

                p {
                    font-size: 1rem;
                    font-weight: 400;
                    font-family: $body-font;
                    color: #333;
                }
            }

            &.profile-data {
                width: 80%;
                margin: 3rem 0;
                display: flex;
                flex-flow: column;
                justify-content: center;
                align-items: center;

                article {
                    width: 100%;
                    display: flex;
                    flex-flow: row;
                    justify-content: center;
                    align-items: center;
                    margin-bottom: 0.5rem;

                    h4 {
                        font-size: 1rem;
                        font-weight: 600;
                        color: $primary;
                        margin-right: 10px;
                    }

                    p {
                        font-size: 1rem;
                        font-weight: 400;
                        color: #333;
                    }
                }
            }

            &.buttons {
                width: 80%;
                display: flex;
                flex-flow: row;
                justify-content: space-between;
                align-items: center;
                margin-top: 1rem;

                div {
                    width: 35%;
                    padding: 1rem 1.3rem;
                    border-radius: 0.5rem;
                    background-color: #000;
                    color: #fff;
                    font-size: 1.2rem;
                    font-weight: 500;
                    text-decoration: none;
                    text-align: center;
                    cursor: pointer;

                    &.delete {
                        background-color: red;
                    }

                    &:hover {
                        background-color: $primary;
                        transition: all 0.2s ease-in-out;
                    }
                }
            }
        }
    }
</style>
