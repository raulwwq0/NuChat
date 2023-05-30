<script lang="ts" setup>
    const { errorNotification } = useSwal();
    const { signInWithEmail, verifyOTP } = useAuth();
    const isSendingLink = ref(false);
    const emailSentDialog = ref(false);
    const email = ref('');
    const emailCode = ref('');
    const handleLogin = () => {
        if (!email.value) {
            errorNotification('Please enter your email');
            return;
        }
        isSendingLink.value = true;
        signInWithEmail(email.value)
            .then(() => {
                emailSentDialog.value = true;
            })
            .catch(error => {
                errorNotification(error.message);
            })
            .finally(() => {
                isSendingLink.value = false;
            });
    };
    const handleVerifyOTP = () => {
        if (!emailCode.value) {
            errorNotification('Please enter the code');
            return;
        }
        verifyOTP(email.value, emailCode.value)
            .then(() => {
                navigateTo('/auth/processing');
            })
            .catch(error => {
                errorNotification(error.message);
            });
    };
</script>

<template>
    <form @submit.prevent="handleLogin">
        <h1>Sign In with Magic Link</h1>
        <input
            v-model="email"
            class="input"
            type="email"
            placeholder="Your Email"
        />
        <button class="btn" :disabled="isSendingLink">
            {{ isSendingLink ? 'Sending...' : 'Send Magic Link' }}
        </button>
    </form>
    <VDialog v-model="emailSentDialog" title="Email Sent">
        <div class="sign-in-dialog">
            <h2>Check your email for the login link!</h2>
            <p>or</p>
            <h2>You can also check your email for the code!</h2>
            <input
                v-model="emailCode"
                class="input"
                type="text"
                placeholder="Enter the code here"
            />
            <button class="btn" @click="handleVerifyOTP">Check Code</button>
            <Icon
                name="material-symbols:close-rounded"
                class="close-icon"
                @click="emailSentDialog = false"
            />
        </div>
    </VDialog>
</template>

<style lang="scss" scoped>
    form {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100%;
        padding: 3rem;
        width: 100%;
        h1 {
            margin-bottom: 2rem;
            font-size: 3rem;
            font-family: $body-font;
            color: #fff;
        }
        input {
            border: none;

            &:focus {
                outline: none;
            }
        }

        button {
            border: none;
        }
    }

    .sign-in-dialog {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100%;
        padding: 3rem;
        width: 50%;
        margin: 0 auto;
        background-color: #fff;
        position: relative;

        h2 {
            margin-bottom: 2rem;
            font-size: 2rem;
            font-family: $body-font;
            color: $secondary;
        }

        p {
            margin-bottom: 2rem;
            font-size: 1.5rem;
            font-family: $body-font;
            color: #333;
        }

        .close-icon {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 2rem;
            color: #ccc;
            cursor: pointer;

            &:hover {
                color: $primary;
                transition: all 0.2s ease-in-out;
            }
        }
    }
</style>
