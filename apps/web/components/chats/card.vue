<script lang="ts" setup>
import { ProfileResponse } from '~/types/response.types'

const props = defineProps({
  profile: {
    type: Object as PropType<ProfileResponse>,
    required: true,
  },
});
</script>

<template>
  <figure>
    <img :src="props.profile.avatar_url" alt="avatar" />
    <figcaption>
      <h3>{{ props.profile.full_name }}</h3>
      <p>@{{ props.profile.username }}</p>
    </figcaption>
  </figure>
</template>

<style lang="scss" scoped>
figure {
  display: flex;
  flex-flow: row;
  align-items: center;
  justify-content: center;
  width: 100%;
  background-color: #fff;
  border: 1px solid black;

  img {
    width: 100px;
    height: 100px;
    border-radius: 50%;
  }

  figcaption {
    display: flex;
    flex-flow: column;
    justify-content: center;
    width: 100%;
    padding: 0 1rem;

    h3 {
      font-size: 1.5rem;
      font-weight: 600;
      font-family: $title-font;
    }

    p {
      font-size: 1rem;
      font-weight: 400;
      font-family: $body-font;
    }
  }
}
</style>
