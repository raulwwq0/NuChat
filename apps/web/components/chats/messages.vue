<script lang="ts" setup>
    import { Message } from '~~/interfaces/message.interface';
    import { Profile } from '~~/interfaces/profile.interface';

    const chatId = useRoute().params.id;
    const { ifNeeded } = useDefaultAvatar();
    const { errorNotification } = useSwal();
    const { get: getAvatar } = useBucket('avatars');
    const {
        get: getMessages,
        startMessagesWatcher,
        stopMessagesWatcher,
    } = useMessages(chatId as string);
    const messages = ref<Message[] | ['loading']>(['loading']);
    const areMessagesLoading = computed(() => messages.value[0] === 'loading');
    const messageList = ref<HTMLElement>();
    const scrollBehavior = ref<'smooth' | 'auto'>('auto');
    const { y: messageListVerticalScrollPosition } = useScroll(messageList, {
        behavior: scrollBehavior,
    });
    const profile = reactive<Profile>(
        await useProfile().getFromChatId(chatId as string)
    );

    function updateMessages() {
        return getMessages()
            .then(messagesResponse => {
                messages.value = messagesResponse!;
            })
            .then(() => {
                if (isAtBottom.value) scrollToBottom();
            })
            .catch(error => {
                errorNotification(error.message);
            });
    }

    function scrollToBottom() {
        messageListVerticalScrollPosition.value =
            messageList.value!.scrollHeight;
    }

    const isAtBottom = computed(() => {
        if (!messageList.value) return false;
        const pxMarginOfError = 15;
        return (
            messageListVerticalScrollPosition.value +
                messageList.value.offsetHeight -
                messageList.value.scrollHeight <=
                pxMarginOfError &&
            messageListVerticalScrollPosition.value +
                messageList.value.offsetHeight -
                messageList.value.scrollHeight >=
                -pxMarginOfError
        );
    });

    onMounted(() => {
        startMessagesWatcher(updateMessages);
        updateMessages().then(() => {
            scrollToBottom();
            scrollBehavior.value = 'smooth';
        });
        getAvatar(profile.avatar)
            .then((url: string) => (profile.avatar = url))
            .catch(error => {
                errorNotification(error.message);
            });
    });

    onBeforeUnmount(() => {
        stopMessagesWatcher();
    });
</script>

<template>
    <main>
        <header>
            <img :src="ifNeeded(profile.avatar)" :alt="profile.full_name" />
            <h1>{{ profile.full_name }}</h1>
        </header>
        <section ref="messageList">
            <div v-if="areMessagesLoading" class="loading">
                <img
                    src="@/assets/images/SvgSpinnersPulseRings3.svg"
                    alt="Loading"
                />
            </div>
            <div v-else-if="!messages.length" class="no-messages">
                No messages yet. Be the first to send one!
            </div>
            <ChatsMessage
                v-for="message in (messages as Message[])"
                v-else
                :key="message.id"
                :message="message"
                @img-loaded="scrollToBottom"
            />
            <button
                v-if="!areMessagesLoading && !isAtBottom"
                class="down-button"
                @click="scrollToBottom"
            >
                <img
                    src="@/assets/images/scroll-down-arrow.svg"
                    alt="Scroll down arrow"
                />
                <VTooltip activator="parent" location="left"
                    >Scroll down</VTooltip
                >
            </button>
        </section>
        <ChatsSendMessage :chat-id="chatId" @message-sent="scrollToBottom" />
    </main>
</template>

<style lang="scss" scoped>
    main {
        display: flex;
        flex-flow: column;
        width: 100%;
        height: 100%;
        z-index: 1;

        header {
            font-size: 1.5rem;
            font-weight: 600;
            height: 60px;
            background-color: $primary;
            width: 100%;
            border-radius: 10px;
            border-bottom-left-radius: 0px;
            border-bottom-right-radius: 0px;
            display: flex;
            align-items: center;

            h1 {
                margin: 0;
                padding: 10px;
                color: #fff;
            }

            img {
                width: 60px;
                height: 60px;
                border-top-left-radius: 10px;
                margin-right: 10px;
            }
        }

        section {
            display: flex;
            flex-flow: column;
            align-items: center;
            height: 100%;
            width: 100%;
            background-color: #fff;
            overflow-y: scroll;

            .loading {
                width: 100%;
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;

                img {
                    width: 5rem;
                    height: 5rem;
                }
            }

            .no-messages {
                width: 100%;
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                color: #ccc;
            }

            .down-button {
                position: fixed;
                bottom: 0;
                right: 0;
                margin: 20px;
                padding: 5px;
                background-color: #000;
                color: #fff;
                border-radius: 9999px;
                border: none;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;

                img {
                    width: 30px;
                    height: 30px;
                }
            }
        }
    }
</style>
